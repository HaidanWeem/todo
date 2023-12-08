import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/feature/presentation/bloc/task/task_bloc.dart';
import 'package:todo/feature/presentation/bloc/task/task_event.dart';
import 'package:todo/feature/presentation/widgets/bottom_task_manager.dart';

void addTask(BuildContext context) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (context) => SingleChildScrollView(
      child: BottomTaskManager(
        header: 'Create task',
        onConfirm: (title, details, file, dateRange) {
          context.read<TasksBloc>().add(CreateTask(
                title: title,
                details: details,
                image: file,
                range: dateRange,
              ));
          Navigator.of(context).pop();
        },
      ),
    ),
  );
}
