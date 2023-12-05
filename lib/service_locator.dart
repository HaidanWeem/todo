import 'package:get_it/get_it.dart';
import 'package:todo/feature/data/datasources/authentication.dart';
import 'package:todo/feature/data/datasources/local_data_source.dart';
import 'package:todo/feature/data/repositories/auth_repository_impl.dart';
import 'package:todo/feature/data/repositories/sql_repository_impl.dart';
import 'package:todo/feature/domain/repositories/auth_repository.dart';
import 'package:todo/feature/domain/repositories/sql_repository.dart';
import 'package:todo/feature/domain/usecases/auth_usercase.dart';
import 'package:todo/feature/domain/usecases/get_all_tasks.dart';
import 'package:todo/feature/presentation/bloc/auth/auth_bloc.dart';
import 'package:todo/feature/presentation/bloc/task/task_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // BLoC / Cubit

  sl.registerFactory(() => TasksBloc(getAllTasks: sl()));

  sl.registerFactory(() => AuthBloc(sl()));

  // UseCases
  sl.registerLazySingleton(() => GetAllTasks(sl()));

  sl.registerLazySingleton(() => AuthUsecase(sl()));

  // Repository
  sl.registerLazySingleton<SqlRepository>(
      () => SqlRepositoryImpl(sqlLocalDataSource: sl()));

  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  // LocalDataSource
  sl.registerLazySingleton<SqlLocalDataSource>(() => SqlLocalDataSourceImpl());

  // RemoteDateSource
  sl.registerLazySingleton<Authentication>(() => AuthenticationImpl());
}
