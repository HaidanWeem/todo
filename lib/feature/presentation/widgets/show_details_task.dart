import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:todo/feature/data/model/task.dart';

Future<dynamic> showDetailsTask(BuildContext context, Tasks task) {
  const formatter = ['yyyy', '-', 'mm', '-', 'dd'];

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      final image = task.image;
      final startDate = formatDate(task.start, formatter);
      final endDate = formatDate(task.end, formatter);

      return SingleChildScrollView(
        child: AlertDialog(
          title: Center(
            child: Text(
              task.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          content: Column(
            children: [
              Text(
                '${task.details}\n $startDate - $endDate',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              if (image != null) Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Image.memory(image)),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    },
  );
}
