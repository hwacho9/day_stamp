import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MoodSelector extends StatefulWidget {
  final void Function(String, String) onMoodSelected;

  const MoodSelector({
    super.key,
    required this.onMoodSelected,
  });

  @override
  State<MoodSelector> createState() => _MoodSelectorState();
}

class _MoodSelectorState extends State<MoodSelector> {
  String _selectedMood = '';
  String _selectedMoodString = '';

  String getMoodWord(String imagePath) {
    Map<String, String> imagePathToMood = {
      'assets/images/happy.png': 'happy',
      'assets/images/sad.png': 'sad',
      'assets/images/angry.png': 'angry',
      'assets/images/love.png': 'love',
      'assets/images/tired.png': 'tired',
      'assets/images/ridiculous.png': 'ridiculous'
    };
    return imagePathToMood[imagePath] ?? 'unknown';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 150.0,
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          const Text('今日の気分',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <String>[
                'assets/images/happy.png',
                'assets/images/love.png',
                'assets/images/sad.png',
                'assets/images/tired.png',
                'assets/images/angry.png',
                'assets/images/ridiculous.png'
              ].map((String imagePath) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedMood = imagePath;
                      _selectedMoodString = getMoodWord(imagePath);
                      // print(_selectedMood);
                    });

                    widget.onMoodSelected(_selectedMood, _selectedMoodString);
                  },
                  child: Image.asset(
                    imagePath,
                    width: 80,
                    height: 80,
                    color: _selectedMood == imagePath ? null : Colors.grey,
                    // 이 부분에서 선택된 이미지는 원래 색상을 유지하고, 그렇지 않은 이미지는 회색으로 설정합니다.
                    colorBlendMode: BlendMode.modulate,
                    // color 속성을 사용할 때 colorBlendMode를 modulate로 설정하여 색상이 올바르게 적용되도록 합니다.
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
