import 'package:dartz/dartz.dart';
import 'package:todo/core/error/failure.dart';
import 'package:todo/feature/data/model/task.dart';
import 'package:todo/feature/domain/repositories/repositories.dart';

class GetAllTasks {
  final SqlRepository sqlRepository;

  GetAllTasks(this.sqlRepository);

  Future<Either<Failure, List<Tasks>?>> getAllTasks() async {
    return await sqlRepository.getAllTasks();
  }

  Future<void> createTask(String title, String details) async {
    return await sqlRepository.createTask(title, details);
  }

  Future<void> editTask(int id, String title, String details) async {
    return await sqlRepository.editTask(id, title, details);
  }

  Future<void> deleteTask(int id) async {
    return await sqlRepository.deleteTask(id);
  }

  Future<void> checkTask(int id, bool checked) async {
    return await sqlRepository.checkTask(id, checked);
  }
}
