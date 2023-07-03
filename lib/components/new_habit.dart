import 'package:flutter/material.dart';

class EnterNewHabitBox extends StatelessWidget {

  final TextEditingController controller;
  final String initialData;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const EnterNewHabitBox({
    super.key,
    required this.initialData,
    required this.controller,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[900],
      content: TextField(
        controller: controller,
        style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
        decoration: InputDecoration(
            hintText: initialData,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            enabledBorder:
              const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            focusedBorder:
              const OutlineInputBorder(borderSide: BorderSide(color: Colors.green))
        ),
      ),
      actions: [
        MaterialButton(
            onPressed: onSave,
            child: Text(
                "Save",
              style: TextStyle(color: Colors.grey.shade400),
            ),
        ),
        MaterialButton(
          onPressed: onCancel,
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.grey.shade400),
          ),
        ),
      ],
    );
  }
}
