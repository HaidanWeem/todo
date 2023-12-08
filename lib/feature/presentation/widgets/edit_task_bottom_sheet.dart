import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/feature/data/model/task.dart';
import 'package:todo/feature/presentation/bloc/task/task_bloc.dart';
import 'package:todo/feature/presentation/bloc/task/task_event.dart';
import 'package:todo/feature/presentation/widgets/bottom_task_manager.dart';

void editTask(BuildContext context, Tasks task) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (context) => SingleChildScrollView(
        child: BottomTaskManager(
      header: 'Edit task',
      titleInitial: task.title,
      detailsInitial: task.details,
      imageInitial: task.image,
      initialRange: DateTimeRange(start: task.start, end: task.end),
      onConfirm: (title, details, file, dateRange) {
        context.read<TasksBloc>().add(EditTask(
              id: task.id,
              title: title,
              details: details,
              image: file,
              range: dateRange,
            ));
        Navigator.of(context).pop();
      },
    )),
  );
}
