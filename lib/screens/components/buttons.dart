import 'package:flutter/material.dart';

class SaveButton extends StatelessWidget {
  final VoidCallback onSave;

  const SaveButton({super.key, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: const Color.fromARGB(255, 247, 162, 191),
        ),
        onPressed: onSave,
        child: const Text(
          '保存',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
