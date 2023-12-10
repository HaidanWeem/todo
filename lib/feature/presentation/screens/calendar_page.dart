import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo/feature/data/model/day_task.dart';
import 'package:todo/feature/data/model/task.dart';
import 'package:todo/feature/presentation/bloc/task/task_bloc.dart';
import 'package:todo/feature/presentation/bloc/task/task_event.dart';
import 'package:todo/feature/presentation/bloc/task/task_state.dart';
import 'package:todo/feature/presentation/widgets/show_details_task.dart';
import 'package:todo/feature/presentation/widgets/todo_list_tile.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  CalendarPageState createState() => CalendarPageState();
}

class CalendarPageState extends State<CalendarPage> {
  late final ValueNotifier<List<DayTask>> _selectedEvents;

  final _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOn;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  static final kFirstDay = DateTime(2000, 1, 1, 1);
  static final kLastDay = DateTime(2200, 1, 1, 1);

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier([]);
    final taskBloc = BlocProvider.of<TasksBloc>(context);
    taskBloc.add(GetTasks());
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<DayTask> _getEventsForDay(DateTime day, List<DayTask> tasks) {
    return tasks.where((task) {
      return task.day.year == day.year &&
          task.day.month == day.month &&
          task.day.day == day.day;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: const Text(
          'Calendar - DayTask',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: BlocBuilder<TasksBloc, TasksState>(
        builder: (context, state) {
          if (state is TasksLoaded) {
            final tasks = _dayTasks(state.tasks);

            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Column(
                children: [
                  TableCalendar<DayTask>(
                    availableCalendarFormats: const {
                      CalendarFormat.month: 'Month'
                    },
                    firstDay: kFirstDay,
                    lastDay: kLastDay,
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    rangeStartDay: _rangeStart,
                    rangeEndDay: _rangeEnd,
                    calendarFormat: _calendarFormat,
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    rangeSelectionMode: _rangeSelectionMode,
                    eventLoader: (day) => _getEventsForDay(day, tasks),
                    onPageChanged: (focusedDay) {
                      _focusedDay = focusedDay;
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                        _rangeStart = null;
                        _rangeEnd = null;
                        _rangeSelectionMode = RangeSelectionMode.toggledOff;
                      });

                      _selectedEvents.value =
                          _getEventsForDay(selectedDay, tasks);
                    },
                  ),
                  Expanded(
                    child: ValueListenableBuilder<List<DayTask>>(
                      valueListenable: _selectedEvents,
                      builder: (context, value, _) {
                        return ListView.builder(
                          itemCount: value.length,
                          itemBuilder: (context, index) {
                            return TodoListTile(
                              title: value[index].title,
                              subtitle: value[index].details,
                              onTap: () {
                                showDetailsTask(
                                  context,
                                  state.tasks.firstWhere(
                                    (element) => element.id == value[index].id,
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else if (state is TasksLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TasksError) {
            return Center(child: Text(state.error));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  List<DayTask> _dayTasks(List<Tasks> rangedTasks) {
    final tasks = <DayTask>[];
    for (final task in rangedTasks) {
      tasks.addAll(DayTask.divideRangedTask(task));
    }

    return tasks;
  }
}
