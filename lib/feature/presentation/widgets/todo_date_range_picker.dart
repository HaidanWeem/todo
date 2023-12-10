import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

class TodoDateRangePickerWidget extends StatefulWidget {
  final DateTimeRange? initialRange;
  final ValueChanged<DateTimeRange> onConfirm;

  const TodoDateRangePickerWidget({
    required this.onConfirm,
    required this.initialRange,
    super.key,
  });

  @override
  TodoDateRangePickerWidgetState createState() =>
      TodoDateRangePickerWidgetState();
}

class TodoDateRangePickerWidgetState extends State<TodoDateRangePickerWidget> {
  static const _formatter = ['yyyy', '.', 'mm', '.', 'dd'];
  DateTimeRange _selectedRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );

  @override
  void initState() {
    super.initState();
    _selectedRange = widget.initialRange ?? _selectedRange;
  }

  @override
  Widget build(BuildContext context) {
    final startDate = formatDate(_selectedRange.start, _formatter);
    final endDate = formatDate(_selectedRange.end, _formatter);

    return Center(
      child: ElevatedButton(
        onPressed: () async {
          await _selectDate(context);
        },
        child: Text('$startDate - $endDate'),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      initialDateRange:
          DateTimeRange(start: DateTime.now(), end: DateTime.now()),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedRange) {
      setState(() => _selectedRange = picked);
      widget.onConfirm(_selectedRange);
    }
  }
}
