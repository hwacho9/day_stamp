import 'package:day_stamp/providers/user_provider.dart';
import 'package:day_stamp/screens/monthly/widgets/customCalendar.dart';
import 'package:day_stamp/screens/monthly/widgets/monthlyProgress.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MonthlyPage extends StatefulWidget {
  const MonthlyPage({super.key});

  @override
  _MonthlyPageState createState() => _MonthlyPageState();
}

class _MonthlyPageState extends State<MonthlyPage> {
  late Map<DateTime, List<String>> _events;
  late List _selectedEvents;
  late CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  // 현재 보고 있는 연도와 월을 저장할 변수
  int _currentYear = DateTime.now().year;
  int _currentMonth = DateTime.now().month;

  //progress indicator
  final int totalDays = 30; // 가정: 이번 달은 30일까지 있음
  final int filledDays = 20; // 가정: 20일 동안 일기를 작성함

  @override
  void initState() {
    super.initState();
    _calendarFormat = CalendarFormat.month;
    _events = {};
    _selectedEvents = [];
    // _fetchEvents();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Now it's safe to call _fetchEvents() here
    _fetchEvents();
  }

  List<String> _getEventsForDay(DateTime day) {
    // 같은 날짜의 이벤트를 가져오기 위해, 시간을 무시합니다.
    return _events.entries
        .where((entry) =>
            entry.key.year == day.year &&
            entry.key.month == day.month &&
            entry.key.day == day.day)
        .expand((entry) => entry.value)
        .toList();
  }

  // have to make Cache logic
  //
  void _fetchEvents() async {
    final user = Provider.of<UserProvider>(context, listen: false);
    // Firestore에서 데이터 조회
    var userId = user.currentUser?.uid; // 사용자 ID 설정
    var collectionMonth = 'entries_$_currentYear' '0$_currentMonth';
    // print(collectionMonth);
    var collection = FirebaseFirestore.instance
        .collection('entries')
        .doc(userId)
        .collection(collectionMonth);
    var querySnapshot = await collection.get();
    Map<DateTime, List<String>> events = {};
    for (var doc in querySnapshot.docs) {
      // print("Document data: ${doc.data()}"); // 문서 데이터 확인
      var dateField = doc.data()['date'];
      DateTime date;
      if (dateField is Timestamp) {
        date = dateField.toDate();
      } else {
        print("Date field is not a Timestamp: $dateField"); // 타입 불일치 로그
        continue;
      }
      String? emoji = doc.data()['emojis']; // 이모티콘 데이터, null 가능성 고려
      if (emoji == null) {
        print("Emoji is null for document: ${doc.id}"); // 이모티콘 데이터 없음 로그
        continue;
      }
      // print(emoji); //
      if (!events.containsKey(date)) {
        events[date] = [];
      }
      events[date]!.add(emoji);
    }
    setState(() {
      _events = events;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false);
    var userId = user.currentUser?.uid; // 사용자 ID 설정
    var collectionMonth = 'entries_$_currentYear' '0$_currentMonth';

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            MonthlyProgressIndicator(
              userId: userId,
              collectionMonth: collectionMonth,
            ),
            CustomTableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              onPageChanged: (date) {
                // 현재 보고 있는 연도와 월 업데이트
                setState(() {
                  _currentYear = date.year;
                  _currentMonth = date.month;
                  _focusedDay = date;
                });
                _fetchEvents();
                // 선택적으로 현재 연도와 월을 출력
                // print("현재 보고 있는 연도: $_currentYear, 월: $_currentMonth");
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  _selectedEvents = _getEventsForDay(selectedDay);
                });
              },
              getEventsForDay:
                  _getEventsForDay, // Assuming this is a method that returns events for a given day
            )
          ],
        ),
      ),
    );
  }
}
