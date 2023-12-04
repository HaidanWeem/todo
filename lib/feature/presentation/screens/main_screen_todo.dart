import 'package:flutter/material.dart';
import 'package:todo/feature/presentation/widgets/create_task_bottom_sheet.dart';
import 'package:todo/feature/presentation/widgets/todo_main_widget_body.dart';

class TodoMainScreen extends StatelessWidget {
  const TodoMainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'TodoApp',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
      ),
      floatingActionButton: IconButton(
        tooltip: 'Add Task',
        onPressed: () => addTask(context),
        icon: const Icon(Icons.add),
        splashRadius: 30,
      ),
      body: const TodoMainWidget(),
    );
  }
}
