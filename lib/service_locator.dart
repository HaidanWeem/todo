import 'package:get_it/get_it.dart';
import 'package:todo/feature/data/datasources/local_data_source.dart';
import 'package:todo/feature/data/repositories/repositories.dart';
import 'package:todo/feature/domain/repositories/repositories.dart';
import 'package:todo/feature/domain/usecases/get_all_tasks.dart';
import 'package:todo/feature/presentation/bloc/task_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // BLoC / Cubit

  sl.registerFactory(
    () => TasksBloc(getAllTasks: sl()),
  );

  // UseCases
  sl.registerLazySingleton(
    () => GetAllTasks(sl()),
  );

  // Repository
  sl.registerLazySingleton<SqlRepository>(() => SqlRepositoryImpl(
    sqlLocalDataSource: sl()
      ));

  // DataLocalSource
  sl.registerLazySingleton<SqlLocalDataSource>(
      () => SqlLocalDataSourceImpl());

}
