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
  static const _databaseName = 'Tasks3';
  static const databaseTemplate = 'CREATE TABLE $_databaseName ('
      'id INTEGER PRIMARY KEY,'
      'title TEXT,'
      'details TEXT,'
      'checked BIT,'
      'image_name TEXT'
      ')';

  final _storage = FirebaseStorage.instance;
  final _auth = FirebaseAuth.instance;

  Database? _database;

  Future<Database> get database async =>
      _database ??= await _initialzeDatabase();

  Future<Database> _initialzeDatabase() async {
    final path = join(await getDatabasesPath(), '$_databaseName.db');

    return openDatabase(path,
        version: 1, onCreate: (db, _) => db.execute(databaseTemplate));
  }

  @override
  Future<void> checkTask(int id, bool checked) async {
    final int checkedBit;
    checkedBit = checked ? 1 : 0;

    const query = 'UPDATE $_databaseName SET checked = ? WHERE id = ?';
    final db = await database;
    await db.rawUpdate(query, [checkedBit, id]);
  }

  @override
  Future<void> createTask({
    required String title,
    required String details,
    XFile? image,
  }) async {
    final db = await database;
    final result = await db.rawQuery('SELECT max(id) FROM $_databaseName');
    final count = Sqflite.firstIntValue(result) ?? 0 + 1;

    if (image != null) _uploadImage(image);

    final imageName = image?.name ?? '';

    await db.rawInsert(
      "INSERT Into $_databaseName (id, title, details, checked, image_name)"
      "VALUES (?, ?, ?, ?, ?)",
      [count, title, details, 0, imageName],
    );
  }

  @override
  Future<void> deleteTask(int id) async {
    final db = await database;
    const query = 'SELECT image_name FROM $_databaseName WHERE id = ?';
    final queryResult = (await db.rawQuery(query, [id]));

    final imageName = queryResult.first['image_name'].toString();
    await _deleteUnuseImage(imageName);

    db.delete(_databaseName, where: "id = ?", whereArgs: [id]);
  }

  @override
  Future<void> editTask(
      int id, String title, String details, XFile? image) async {
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

    const query = 'SELECT image_name FROM $_databaseName WHERE id = ?';
    final queryResult = await db.rawQuery(query, [id]);

    final sqlImageName = queryResult.first['image_name'].toString();
    final imageName = image?.path.split('/').last;

    if (sqlImageName == imageName || image == null) return;

    _uploadImage(image);

    if (sqlImageName.isEmpty) return;

    await _deleteUnuseImage(sqlImageName);
  }

  Future<void> updateTask({
    required int id,
    required String title,
    required String details,
    String? imageName = '',
  }) async {
    final db = await database;
    const query =
        'UPDATE $_databaseName SET title = ?, details = ?, image_name = ? WHERE id = ?';
    await db.rawUpdate(query, [title, details, id, imageName]);
  }

  @override
  Future<List<Tasks>> getAllTasks() async {
    try {
      final db = await database;
      final result = await db.query(_databaseName);

      for (final task in result) {
        task['checked'] = task['checked'] == 1;

        final imageName = task['image_name'].toString();

        if (imageName.toString().isEmpty) {
          task['image_name'] = null;

          continue;
        }

        final imagePath = await _downloadImage(imageName);
        final response = await http.get(Uri.parse(imagePath));
        task['image_name'] = response.bodyBytes;
      }

      return result.map(Tasks.fromJson).toList();
    } catch (e) {
      throw CacheException();
    }
  }

  Future<bool> isImageExisted(XFile image) async {
    bool exists = true;
    final metadata = await _storage
        .ref()
        .child('images/${_auth.currentUser?.uid}/${image.name}')
        .getMetadata();

    print(metadata);

    return exists;
  }

  Future<void> _deleteUnuseImage(String path) async {
    const query = 'SELECT * FROM $_databaseName WHERE image_name = ?';
    final db = await database;
    final tasksWithSameImage = await db.rawQuery(query, [path]);
    if (tasksWithSameImage.length != 1) return;

    _deleteImage(path);
  }

  Future<void> _uploadImage(XFile image) async {
    if (await isImageExisted(image)) return;

    await _storage
        .ref()
        .child('images/${_auth.currentUser?.uid}/${image.name}')
        .putFile(File(image.path));
  }

  Future<String> _downloadImage(String imageName) => _storage
      .ref()
      .child('images/${_auth.currentUser?.uid}/$imageName')
      .getDownloadURL();

  Future<void> _deleteImage(String imageName) => _storage
      .ref()
      .child('images/${_auth.currentUser?.uid}/$imageName')
      .delete();
}
