import 'package:day_stamp/screen/components/moodselector.dart';
import 'package:day_stamp/screen/components/weatherselector.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _firebase = FirebaseAuth.instance;

class DailyPage extends StatefulWidget {
  const DailyPage({super.key});

  @override
  _DailyPageState createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage> {
  String _selectedMood = '';
  String _selectedWeather = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            MoodSelector(
              onMoodSelected: (String mood) {
                setState(() {
                  _selectedMood = mood;
                });
              },
            ),
            const SizedBox(height: 20),
            WeatherSelector(
              onWeatherSelected: (String weather) {
                setState(() {
                  _selectedWeather = weather;
                });
              },
            ),
            const SizedBox(height: 20),
            const Text('오늘의 일기'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '여기에 일기를 작성하세요',
                ),
                maxLines: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
