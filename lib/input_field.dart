import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  InputField({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(hintText: 'Type a message...'),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: onSend,
          ),
        ],
      ),
    );
  }
}
