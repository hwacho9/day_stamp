import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_stamp/providers/user_provider.dart';
import 'package:day_stamp/screens/daily/daily_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnalysisPage extends StatefulWidget {
  const AnalysisPage({super.key});

  @override
  _AnalysisPageState createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  Future<Map<String, int>> analyzeMood() async {
    final user = Provider.of<UserProvider>(context, listen: false);
    // Firestore에서 데이터 조회
    var userId = user.currentUser?.uid; // 사용자 ID 설정
    QuerySnapshot snapshot = await firestore
        .collection('entries')
        .doc(userId)
        .collection('entries_202407')
        .get();
    Map<String, int> moodCount = {};

    for (var doc in snapshot.docs) {
      print(doc);
      String mood = doc['mood'];
      if (moodCount.containsKey(mood)) {
        moodCount[mood] = moodCount[mood]! + 1;
      } else {
        moodCount[mood] = 1;
      }
    }
    return moodCount;
  }

  @override
  void initState() {
    super.initState(); // 항상 super.initState()를 호출해야 합니다.
    Future.delayed(Duration.zero, () {
      analyzeMood().then((result) {
        // 여기에서 결과를 사용할 수 있습니다.
        // 예: 상태를 업데이트하거나, 결과를 화면에 표시합니다.
        print(result);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text('분석'),
          ],
        ),
      ),
    );
  }
}
