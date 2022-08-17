import 'package:dartz/dartz.dart';
import 'package:todo/core/error/failure.dart';
import 'package:todo/feature/data/model/task.dart';


abstract class SqlRepository {
  Future<Either<Failure, List<Tasks>>> getAllTasks();
  Future<void> createTask(String text);
  Future<void> editTask(int id, String text);
  Future<void> deleteTask(int id);
  Future<void> checkTask(int id, bool checked);
}
