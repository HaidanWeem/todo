import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo/feature/presentation/widgets/image_picker.dart';
import 'package:todo/feature/presentation/widgets/todo_date_range_picker.dart';

class BottomTaskManager extends StatefulWidget {
  final String? titleInitial;
  final String? detailsInitial;
  final Uint8List? imageInitial;
  final DateTimeRange? initialRange;
  final String header;
  final Function(String, String, XFile?, DateTimeRange) onConfirm;
  final VoidCallback? onCancel;

  const BottomTaskManager({
    required this.header,
    required this.onConfirm,
    this.initialRange,
    this.titleInitial,
    this.detailsInitial,
    this.imageInitial,
    this.onCancel,
    super.key,
  });

  @override
  State<BottomTaskManager> createState() => _BottomTaskManagerState();
}

class _BottomTaskManagerState extends State<BottomTaskManager> {
  final _titleController = TextEditingController();
  final _detailsController = TextEditingController();
  XFile? _image;
  DateTimeRange _selectedRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.titleInitial ?? '';
    _detailsController.text = widget.detailsInitial ?? '';
    _selectedRange = widget.initialRange ?? _selectedRange;
    final initialImage = widget.imageInitial;
    if (initialImage == null) return;
    _image = XFile.fromData(initialImage);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.header,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: TextField(
                maxLength: 100,
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            TextField(
              controller: _detailsController,
              decoration: InputDecoration(
                hintText: 'Text of your Task',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Column(
                children: [
                  TodoDateRangePickerWidget(
                    initialRange: widget.initialRange,
                      onConfirm: (range) => _selectedRange = range),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ImagePickerButton(
                          imageInitial: _image,
                          onChanged: (img) => _image = img),
                      const Spacer(),
                      TextButton(
                        onPressed: () =>
                            widget.onCancel ?? Navigator.of(context).pop(),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.black),
                        ),
                        onPressed: () {
                          widget.onConfirm(
                            _titleController.text,
                            _detailsController.text,
                            _image,
                            _selectedRange,
                          );
                          _titleController.clear();
                          _detailsController.clear();
                        },
                        child: Text(widget.header),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
