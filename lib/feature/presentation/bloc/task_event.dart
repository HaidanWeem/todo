import 'package:equatable/equatable.dart';

abstract class TasksEvent extends Equatable {
  const TasksEvent();

  @override
  List<Object> get props => [];
}

class GetTasks extends TasksEvent {
  @override
  List<Object> get props => [];
}

class CreateTask extends TasksEvent {
  final String title;
  final String details;

  const CreateTask({required this.title, required this.details,});

  @override
  List<Object> get props => [];
}

class EditTask extends TasksEvent {
  final int id;
  final String title, details;
  const EditTask({required this.title, required this.id, required this.details});

  @override
  List<Object> get props => [];
}

class DeleteTask extends TasksEvent {
  final int id;
  const DeleteTask({required this.id});
  @override
  List<Object> get props => [];
}

class CheckTask extends TasksEvent {
  final int id;
  final bool checked;
  const CheckTask({required this.id, required this.checked});
  @override
  List<Object> get props => [];
}
