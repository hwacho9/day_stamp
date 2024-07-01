import 'package:flutter/material.dart';

class MoodSelector extends StatefulWidget {
  final void Function(String) onMoodSelected;

  const MoodSelector({super.key, required this.onMoodSelected});

  @override
  State<MoodSelector> createState() => _MoodSelectorState();
}

class _MoodSelectorState extends State<MoodSelector> {
  String _selectedMood = '';

  String getMoodWord(String emoji) {
    Map<String, String> emojiToMood = {
      '😊': 'happy',
      '😢': 'sad',
      '😠': 'angry',
      '😍': 'in love',
    };
    return emojiToMood[emoji] ?? 'unknown';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100.0,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          const Text('오늘의 기분',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <String>['😊', '😢', '😠', '😍'].map((String mood) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedMood = getMoodWord(mood);
                  });
                  widget.onMoodSelected(getMoodWord(mood));
                },
                child: CircleAvatar(
                  radius: 20,
                  child: Text(mood),
                  backgroundColor: _selectedMood == getMoodWord(mood)
                      ? Colors.blue
                      : Colors.grey,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
