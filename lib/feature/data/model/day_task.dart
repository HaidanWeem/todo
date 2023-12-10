import 'package:flutter/foundation.dart';
import 'package:todo/feature/data/model/task.dart';

class DayTask {
  final int id;
  final String title;
  final String details;
  final bool checked;
  final Uint8List? image;
  final DateTime day;

  const DayTask({
    required this.id,
    required this.title,
    required this.details,
    required this.checked,
    required this.day,
    this.image,
  });

  static List<DayTask> divideRangedTask(Tasks task) {
    final dayTasks = <DayTask>[];

    final days = task.end.difference(task.start).inDays;

    for (int i = 0; i <= days; i++) {
      dayTasks.add(
        DayTask(
          id: task.id,
          title: task.title,
          details: task.details,
          checked: task.checked,
          day: task.start.add(
            Duration(days: i),
          ),
        ),
      );
    }

    return dayTasks;
  }
}
