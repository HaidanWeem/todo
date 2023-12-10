import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/feature/presentation/bloc/auth/auth_bloc.dart';
import 'package:todo/feature/presentation/bloc/auth/auth_event.dart';
import 'package:todo/feature/presentation/widgets/create_task_bottom_sheet.dart';
import 'package:todo/feature/presentation/widgets/todo_main_widget_body.dart';
import 'package:todo/todo_navigator.dart';

class TodoMainScreen extends StatelessWidget {
  const TodoMainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                BlocProvider.of<AuthBloc>(context).add(SignOutEvent());
                Navigator.pushReplacementNamed(context, Routes.auth);
              },
              icon: const Icon(Icons.logout)),
        ],
        leading: IconButton(
            onPressed: () => Navigator.pushNamed(
                  context,
                  Routes.calendar,
                ),
            icon: const Icon(
              Icons.calendar_month,
              color: Colors.white,
            )),
        backgroundColor: Colors.black,
        title: const Text(
          'VzhTodo',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
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
