import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_stamp/providers/user_provider.dart';
import 'package:day_stamp/screens/components/buttons.dart';
import 'package:day_stamp/screens/components/input_box.dart';
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
  String _selectedMoodString = '';
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
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 20),
              MoodSelector(
                onMoodSelected: (String mood, String moodstring) {
                  setState(() {
                    _selectedMood = mood;
                    _selectedMoodString = moodstring;
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
              DiaryEntryComponent(
                diaryController: _diaryController,
              ),
              const SizedBox(height: 20),
              SaveButton(
                onSave: () {
                  dbService.addEntry(
                      user.currentUser?.uid ?? '',
                      DateTime.now(),
                      _selectedMoodString,
                      _selectedWeather,
                      [],
                      _diaryController.text,
                      _selectedMood);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('保存されました'), // "저장되었습니다" 메시지
                      duration: Duration(seconds: 2), // 스낵바 지속 시간 설정
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
