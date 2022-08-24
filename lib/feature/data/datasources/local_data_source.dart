import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/core/error/exception.dart';
import 'package:todo/feature/data/model/task.dart';

abstract class SqlLocalDataSource {
  Future<List<Tasks>?> getAllTasks();
  Future<void> createTask(String title, String details);
  Future<void> editTask(int id, String title, String details);
  Future<void> deleteTask(int id);
  Future<void> checkTask(int id, bool checked);
}

class SqlLocalDataSourceImpl implements SqlLocalDataSource {
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
  Future<void> createTask(String title, String details) async {
    final db = await database;
    final result = await db.rawQuery('SELECT max(id) FROM $_nameDB');
    var count = 0;
    if (Sqflite.firstIntValue(result) == null) {
      count = 1;
    } else {
      count = Sqflite.firstIntValue(result)! + 1;
    }

    await db.rawInsert(
        "INSERT Into $_nameDB (id, title, details, checked)"
        "VALUES (?, ?, ?, ?)",
        [count, title, details, 0]);
  }

  @override
  Future<void> deleteTask(int id) async {
    final db = await database;
    db.delete(_nameDB, where: "id = ?", whereArgs: [id]);
  }

  @override
  Future<void> editTask(int id, String title, String details) async {
    final db = await database;
    await db.rawUpdate(
        'UPDATE $_nameDB SET title = ?, details = ? WHERE id = ?',
        [title, details, id]);
  }

  @override
  Future<List<Tasks>?> getAllTasks() async {
    try {
      final db = await database;
      final res = await db.query(_nameDB);
      List<Map<String, Object?>> tasksMap =
          res.map((e) => Map<String, dynamic>.from(e)).toList();
      List<Tasks> listTasks = tasksMap.map((task) {
        if (task['checked'] == 0) {
          task['checked'] = false;
        } else if (task['checked'] == 1) {
          task['checked'] = true;
        }
        return Tasks.fromJson(task);
      }).toList();
      return listTasks;
    } catch (e) {
      throw CacheException();
    }
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), '$_nameDB.db');
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE $_nameDB ("
          "id INTEGER PRIMARY KEY,"
          "title TEXT,"
          "details TEXT,"
          "checked BIT"
          ")");
    });
  }
}
