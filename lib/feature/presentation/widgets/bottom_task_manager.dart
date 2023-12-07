import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo/feature/presentation/widgets/image_picker.dart';

class BottomTaskManager extends StatefulWidget {
  final String? titleInitial;
  final String? detailsInitial;
  final Uint8List? imageInitial;
  final String header;
  final Function(String, String, XFile?) onConfirm;
  final VoidCallback? onCancel;

  const BottomTaskManager({
    required this.header,
    required this.onConfirm,
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
  TextEditingController titleController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  XFile? _image;

  @override
  void initState() {
    super.initState();
    titleController.text = widget.titleInitial ?? '';
    detailsController.text = widget.detailsInitial ?? '';

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
                controller: titleController,
                decoration: InputDecoration(
                  hintText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            TextField(
              controller: detailsController,
              decoration: InputDecoration(
                hintText: 'Text of your Task',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ImagePickerButton(
                      imageInitial: _image, onChanged: (img) => _image = img),
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
                      backgroundColor: MaterialStateProperty.all(Colors.black),
                    ),
                    onPressed: () {
                      print('bottom task');
                      print(_image?.path);
                      widget.onConfirm(
                        titleController.text,
                        detailsController.text,
                        _image,
                      );
                      titleController.clear();
                      detailsController.clear();
                    },
                    child: Text(widget.header),
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
