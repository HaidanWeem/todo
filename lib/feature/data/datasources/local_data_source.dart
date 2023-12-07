import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/core/error/exception.dart';
import 'package:todo/feature/data/model/task.dart';

abstract class SqlLocalDataSource {
  Future<List<Tasks>> getAllTasks();
  Future<void> createTask({
    required String title,
    required String details,
    XFile? image,
  });
  Future<void> editTask(int id, String title, String details, XFile? image);
  Future<void> deleteTask(int id);
  Future<void> checkTask(int id, bool checked);
}

class SqlLocalDataSourceImpl implements SqlLocalDataSource {
  final _storage = FirebaseStorage.instance;
  final _auth = FirebaseAuth.instance;

  Database? _database;
  final String _nameDB = 'Tasks2';

  Future<Database> get database async => _database ??= await _initDB();

  @override
  Future<void> checkTask(int id, bool checked) async {
    final int checkedBit;
    if (checked == true) {
      checkedBit = 1;
    } else {
      checkedBit = 0;
    }
    final db = await database;
    await db.rawUpdate(
        'UPDATE $_nameDB SET checked = ? WHERE id = ?', [checkedBit, id]);
  }

  @override
  Future<void> createTask({
    required String title,
    required String details,
    XFile? image,
  }) async {
    final db = await database;
    final result = await db.rawQuery('SELECT max(id) FROM $_nameDB');
    var count = 0;
    if (Sqflite.firstIntValue(result) == null) {
      count = 1;
    } else {
      count = Sqflite.firstIntValue(result)! + 1;
    }

    if (image != null && !(await isImageExisted(image))) {
      await _storage
          .ref()
          .child('images/${_auth.currentUser?.uid}/${image.name}')
          .putFile(File(image.path));
    }

    final imageName = image?.name ?? '';

    await db.rawInsert(
        "INSERT Into $_nameDB (id, title, details, checked, image_name)"
        "VALUES (?, ?, ?, ?, ?)",
        [count, title, details, 0, imageName]);
  }

  @override
  Future<void> deleteTask(int id) async {
    final db = await database;
    final task =
        await db.rawQuery('SELECT image_name FROM $_nameDB WHERE id = $id');
    final imageName = task.first['image_name'].toString();
    _deleteUnuseImage(imageName);

    db.delete(_nameDB, where: "id = ?", whereArgs: [id]);
  }

  @override
  Future<void> editTask(
    int id,
    String title,
    String details,
    XFile? image,
  ) async {
    print(image?.path.split('/').last);
    await checkEdittedImage(id, image);
    await updateTask(
      id: id,
      title: title,
      details: details,
      imageName: image?.path.split('/').last,
    );
  }

  Future<void> checkEdittedImage(int id, XFile? image) async {
    final db = await database;

    final query = 'SELECT image_name FROM $_nameDB WHERE id = ?';
    final imageQuery = await db.rawQuery(query, [id]);

    final sqlImageName = imageQuery.first['image_name'].toString();
    final imageName = image?.path.split('/').last;

    if (sqlImageName == imageName ||
        image == null ||
        (await isImageExisted(image))) {
      return;
    }

    _storage
        .ref()
        .child('images/${_auth.currentUser?.uid}/$imageName')
        .putFile(File(image.path));

    if (sqlImageName.isEmpty) return;

    _deleteUnuseImage(sqlImageName);
  }

  Future<void> updateTask({
    required int id,
    required String title,
    required String details,
    String? imageName = '',
  }) async {
    (await database).rawUpdate(
        'UPDATE $_nameDB SET title = ?, details = ?, image_name = ? WHERE id = ?',
        [title, details, id, imageName]);
  }

  @override
  Future<List<Tasks>> getAllTasks() async {
    try {
      final db = await database;
      final res = await db.query(_nameDB);

      List<Map<String, Object?>> tasksMap =
          res.map((e) => Map<String, dynamic>.from(e)).toList();

      for (final task in tasksMap) {
        task['checked'] = task['checked'] == 1;

        final imageName = task['image_name'];

        if (imageName.toString().isEmpty) {
          task['image_name'] = null;

          continue;
        }

        final imagePath = await _storage
            .ref()
            .child('images/${_auth.currentUser?.uid}/$imageName')
            .getDownloadURL();

        print(imagePath);

        final response = await http.get(Uri.parse(imagePath));

        task['image_name'] = response.bodyBytes;
      }

      final a = tasksMap.map(Tasks.fromJson).toList();

      return a;
    } catch (e) {
      throw CacheException();
    }
  }

  Future<bool> isImageExisted(XFile image) async {
    bool exists = true;
    await _storage
        .ref()
        .child('images/${_auth.currentUser?.uid}/${image.name}')
        .getDownloadURL()
        .catchError((e) {
      exists = false;

      return '';
    });

    return exists;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), '$_nameDB.db');
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE $_nameDB ("
          "id INTEGER PRIMARY KEY,"
          "title TEXT,"
          "details TEXT,"
          "checked BIT,"
          "image_name TEXT"
          ")");
    });
  }

  Future<void> _deleteUnuseImage(String path) async {
    final db = await database;
    final tasksWithSameImage = await db
        .rawQuery('SELECT * FROM $_nameDB WHERE image_name = ?', [path]);
    if (tasksWithSameImage.length == 1) {
      await _storage
          .ref()
          .child('images/${_auth.currentUser?.uid}/$path')
          .delete();
    }
  }
}
