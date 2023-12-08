import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerButton extends StatefulWidget {
  final XFile? imageInitial;
  final ValueChanged<XFile?> onChanged;
  const ImagePickerButton({
    required this.onChanged,
    this.imageInitial,
    super.key,
  });

  @override
  State<ImagePickerButton> createState() => _ImagePickerButtonState();
}

class _ImagePickerButtonState extends State<ImagePickerButton> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  @override
  void initState() {
    super.initState();
    _image = widget.imageInitial;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: getImage,
          icon: _image == null
              ? const Icon(Icons.upload)
              : Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2)),
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: FutureBuilder(
                        future: _image?.readAsBytes(),
                        builder: (context, snapshot) {
                          final data = snapshot.data;
                          if (data == null) return const SizedBox();
                          return Image.memory(data as Uint8List);
                        }),
                  ),
                ),
        ),
        if (_image != null)
          IconButton(
            onPressed: () {
              setState(() => _image = null);
              widget.onChanged(null);
            },
            icon: const Icon(Icons.close),
          )
      ],
    );
  }

  Future getImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() => _image = image);

    widget.onChanged(_image);
  }
}
