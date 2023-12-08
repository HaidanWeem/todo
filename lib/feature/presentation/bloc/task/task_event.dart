import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  final DateTimeRange range;
  final XFile? image;

  const CreateTask({
    required this.title,
    required this.details,
    required this.range,
    this.image,
  });

  @override
  List<Object> get props => [];
}

class EditTask extends TasksEvent {
  final int id;
  final String title, details;
  final DateTimeRange range;
  final XFile? image;
  const EditTask(
      {required this.title,
      required this.id,
      required this.details,
      required this.range,
      this.image});

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
