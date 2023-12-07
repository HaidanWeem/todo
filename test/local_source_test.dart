import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo/core/error/exception.dart';
import 'package:todo/feature/data/datasources/local_data_source.dart';
import 'package:todo/feature/data/model/task.dart';

class TasksMock extends Mock implements SqlLocalDataSource {
  List<Map<String, Object>> tasksFromDB = [
    {"id": 1, "title": "Task1", "details": "Detais Task 1", "checked": 1},
    {"id": 2, "title": "Task2", "details": "Detais Task 2", "checked": 0},
    {"id": 3, "title": "Task3", "details": "Detais Task 3", "checked": 0},
  ];

  @override
  Future<List<Tasks>> getAllTasks() async {
    try {
      final res = tasksFromDB;
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

  @override
  Future<void> createTask({
    required String title,
    required String details,
    XFile? image,
  }) async {
    final result = tasksFromDB.length;
    var count = 0;
    if (result == 0) {
      count = 1;
    } else {
      count = result + 1;
    }

    tasksFromDB.add(
        {"id": count, "title": title, "details": details, "checked": false});
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  group('test_local_data_source', () {
    late TasksMock tasksMock;
    setUp(() {
      tasksMock = TasksMock();
    });

    test('get_tasks', () async {
      final tasks = await tasksMock.getAllTasks();
      expect(tasks.first.checked, true);
    });

    test('create_task', () async {
      await tasksMock.createTask(title: "Task 4", details: "Details Task 4");
      final tasks = await tasksMock.getAllTasks();
      expect(tasks.length, 4);
      expect(tasks.last.id, 4);
    });
  });
}
