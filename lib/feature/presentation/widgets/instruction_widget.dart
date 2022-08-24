import 'package:flutter/material.dart';

class InstructionWidget extends StatelessWidget {
  const InstructionWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            'No tasks',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            '''
            Notes: In order to add a task you may press 
            the button in right corner bottom.
            In order to edit a task you may long press by task.
            In order to create a task you may just press by task.
            In order to delete a task you may swap task ltr or rtl.
            ''',
            style: TextStyle(fontSize: 15, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
