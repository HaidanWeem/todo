import 'package:flutter/material.dart';
import 'package:todo/feature/data/model/task.dart';

Future<dynamic> showDetailsTask(BuildContext context, Tasks task) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return SingleChildScrollView(
        child: AlertDialog(
          title: Center(
            child: Text(
              task.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          content: Text(
            task.details,
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
