import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/feature/presentation/bloc/task/task_bloc.dart';
import 'package:todo/feature/presentation/bloc/task/task_event.dart';
import 'package:todo/feature/presentation/bloc/task/task_state.dart';
import 'package:todo/feature/presentation/widgets/show_details_task.dart';
import 'package:todo/feature/presentation/widgets/edit_task_bottom_sheet.dart';
import 'package:todo/feature/presentation/widgets/instruction_widget.dart';

class TodoMainWidget extends StatefulWidget {
  const TodoMainWidget({Key? key}) : super(key: key);

  @override
  State<TodoMainWidget> createState() => _TodoMainWidgetState();
}

class _TodoMainWidgetState extends State<TodoMainWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksBloc, TasksState>(
      builder: (context, state) {
        if (state is TasksLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is TasksError) {
          Text(
            state.error,
            style: const TextStyle(color: Colors.white, fontSize: 25),
          );
        } else if (state is TasksLoaded) {
          if (state.tasks!.isEmpty) {
            return const InstructionWidget();
          }
          return SafeArea(
            child: ListView.builder(
              itemCount: state.tasks!.length,
              itemBuilder: (context, index) {
                final task = state.tasks![index];
                bool checked = task.checked;
                return Dismissible(
                  background: Container(color: Colors.red),
                  key: Key(task.id.toString()),
                  onDismissed: (direction) {
                    BlocProvider.of<TasksBloc>(context)
                        .add(DeleteTask(id: task.id));
                    setState(() {
                      state.tasks!.removeAt(index);
                    });
                  },
                  child: ListTile(
                    onLongPress: () => editTask(context, task),
                    onTap: () => showDetailsTask(context, task),
                    title: Text(
                      task.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      task.details,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: StatefulBuilder(
                      builder: (context, setState) {
                        return Checkbox(
                          value: checked,
                          onChanged: (value) {
                            setState(() {
                              checked = value!;
                            });
                            BlocProvider.of<TasksBloc>(context)
                                .add(CheckTask(id: task.id, checked: checked));
                          },
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          );
        }
        return const Center(child: Text('Unknown error'));
      },
    );
  }
}
