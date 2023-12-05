import 'package:todo/core/error/exception.dart';
import 'package:todo/feature/data/datasources/local_data_source.dart';
import 'package:todo/feature/data/model/task.dart';
import 'package:todo/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:todo/feature/domain/repositories/sql_repository.dart';

class SqlRepositoryImpl implements SqlRepository {
  SqlLocalDataSource sqlLocalDataSource;

  SqlRepositoryImpl({required this.sqlLocalDataSource});

  @override
  Future<void> checkTask(int id, bool checked) async {
    await sqlLocalDataSource.checkTask(id, checked);
  }

  @override
  Future<void> createTask(String title, String details) async {
    await sqlLocalDataSource.createTask(title, details);
  }

  @override
  Future<void> deleteTask(int id) async {
    await sqlLocalDataSource.deleteTask(id);
  }

  @override
  Future<void> editTask(int id, String title, String details) async {
    await sqlLocalDataSource.editTask(id, title, details);
  }

  @override
  Future<Either<Failure, List<Tasks>?>> getAllTasks() async {
    try {
      final tasks = await sqlLocalDataSource.getAllTasks();
      return Right(tasks);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
