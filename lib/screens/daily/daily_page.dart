import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_stamp/providers/user_provider.dart';
import 'package:day_stamp/screens/components/mood_selector.dart';
import 'package:day_stamp/screens/components/weather_selector.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../service/database_service.dart';

final _firebase = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;

class DailyPage extends StatefulWidget {
  const DailyPage({super.key});

  @override
  _DailyPageState createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage> {
  String _selectedMood = '';
  String _selectedWeather = '';
  TextEditingController _diaryController = TextEditingController();
  DatabaseService dbService = DatabaseService();
  @override
  void initState() {
    super.initState();
    _diaryController = TextEditingController();
  }

  @override
  void dispose() {
    _diaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final user = Provider.of<UserProvider>(context);
    // print(user.currentUser);
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
                  // print(_selectedMood);
                });
              },
            ),
            const SizedBox(height: 20),
            WeatherSelector(
              onWeatherSelected: (String weather) {
                setState(() {
                  _selectedWeather = weather;
                  // print(_selectedWeather);
                });
              },
            ),
            const SizedBox(height: 20),
            const Text('오늘의 일기'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _diaryController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '여기에 일기를 작성하세요',
                ),
                maxLines: 5,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                dbService.addEntry(
                    user.currentUser?.uid ?? '',
                    DateTime.now(),
                    _selectedMood,
                    _selectedWeather,
                    [],
                    _diaryController.text,
                    []);
              },
              child: const Text('保存'),
            )
          ],
        ),
      ),
    );
  }
}
