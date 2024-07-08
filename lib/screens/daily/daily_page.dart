import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_stamp/providers/user_provider.dart';
import 'package:day_stamp/screens/components/mood_selector.dart';
import 'package:day_stamp/screens/components/weather_selector.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    const Text('今日の日記'),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _diaryController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          hintText: '今日の出来事を書いてください',
                        ),
                        maxLines: 5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Color.fromARGB(255, 228, 165, 185),
                  ),
                  onPressed: () {
                    dbService.addEntry(
                        user.currentUser?.uid ?? '',
                        DateTime.now(),
                        _selectedMoodString,
                        _selectedWeather,
                        [],
                        _diaryController.text,
                        _selectedMood);
                  },
                  child: const Text(
                    '保存',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
