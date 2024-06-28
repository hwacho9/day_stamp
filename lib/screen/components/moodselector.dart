import 'package:flutter/material.dart';

class MoodSelector extends StatefulWidget {
  final void Function(String) onMoodSelected;

  const MoodSelector({super.key, required this.onMoodSelected});

  @override
  State<MoodSelector> createState() => _MoodSelectorState();
}

class _MoodSelectorState extends State<MoodSelector> {
  String _selectedMood = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <String>['😊', '😢', '😠', '😍'].map((String mood) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedMood = mood;
              });
              widget.onMoodSelected(mood);
            },
            child: CircleAvatar(
              child: Text(mood),
              backgroundColor:
                  _selectedMood == mood ? Colors.blue : Colors.grey,
            ),
          );
        }).toList(),
      ),
    );
  }
}
