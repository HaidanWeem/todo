import 'package:equatable/equatable.dart';
import 'package:todo/feature/data/model/task.dart';

abstract class TasksState extends Equatable {
  const TasksState();

  @override
  List<Object?> get props => [];
}

class TasksError extends TasksState {
  final String error;

  const TasksError({required this.error});

  @override
  List<Object?> get props => [];
}

class TasksLoading extends TasksState {
  @override
  List<Object?> get props => [];
}

class TasksLoaded extends TasksState {
  final List<Tasks>? tasks;

  const TasksLoaded({this.tasks});
  
  @override
  List<Object?> get props => [];
}
