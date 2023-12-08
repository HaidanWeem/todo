import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/core/error/failure.dart';
import 'package:todo/feature/domain/usecases/get_all_tasks.dart';
import 'package:todo/feature/presentation/bloc/task/task_event.dart';
import 'package:todo/feature/presentation/bloc/task/task_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  final GetAllTasks getAllTasks;

  _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case CacheFailure:
        return 'Cache failure';
      default:
        return 'Unknown Error';
    }
  }

  TasksBloc({
    required this.getAllTasks,
  }) : super(TasksLoading()) {
    on<GetTasks>(
      (event, emit) async {
        final failureOrTasks = await getAllTasks.getAllTasks();

        failureOrTasks.fold(
            (failure) => emit(TasksError(error: _mapFailureToMessage(failure))),
            (tasks) => emit(TasksLoaded(tasks: tasks)));
      },
    );

    on<CreateTask>(
      (event, emit) async {
        emit(TasksLoading());
        await getAllTasks.createTask(
          title: event.title,
          details: event.details,
          image: event.image,
        );

        final failureOrTasks = await getAllTasks.getAllTasks();
        failureOrTasks.fold(
            (failure) => emit(TasksError(error: _mapFailureToMessage(failure))),
            (tasks) => emit(TasksLoaded(tasks: tasks)));
      },
    );

    on<DeleteTask>(
      (event, emit) async {
        await getAllTasks.deleteTask(event.id);
      },
    );

    on<EditTask>(
      (event, emit) async {
        emit(TasksLoading());
        await getAllTasks.editTask(
            event.id, event.title, event.details, event.image);

        final failureOrTasks = await getAllTasks.getAllTasks();
        failureOrTasks.fold(
            (failure) => emit(TasksError(error: _mapFailureToMessage(failure))),
            (tasks) => emit(TasksLoaded(tasks: tasks)));
      },
    );

    on<CheckTask>(
      (event, emit) async {
        await getAllTasks.checkTask(event.id, event.checked);
      },
    );
  }
}
