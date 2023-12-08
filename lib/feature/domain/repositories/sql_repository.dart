import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo/core/error/failure.dart';
import 'package:todo/feature/data/model/task.dart';

abstract class SqlRepository {
  Future<Either<Failure, List<Tasks>>> getAllTasks();
  Future<void> createTask({
    required String title,
    required String details,
    required XFile? image,
  });
  Future<void> editTask(int id, String title, String details, XFile? image);
  Future<void> deleteTask(int id);
  Future<void> checkTask(int id, bool checked);
}
