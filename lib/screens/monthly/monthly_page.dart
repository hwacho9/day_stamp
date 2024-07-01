import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MonthlyPage extends StatefulWidget {
  @override
  _MonthlyPageState createState() => _MonthlyPageState();
}

class _MonthlyPageState extends State<MonthlyPage> {
  late Map<DateTime, List<String>> _events;
  late List _selectedEvents;
  late CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _calendarFormat = CalendarFormat.month;
    _events = {};
    _selectedEvents = [];
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

  void _fetchEvents() async {
    // Firestore에서 데이터 조회
    String userId = "juSqhcNR21hGkinR5wivxyPRGZ03"; // 사용자 ID 설정
    String collectionMonth = "entries_202407"; // 조회할 월 설정
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
      String? emoji = doc.data()['mood']; // 이모티콘 데이터, null 가능성 고려
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
      // print(_events);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text("gage 入れる予定"),
          TableCalendar(
            calendarStyle: const CalendarStyle(
              defaultTextStyle: TextStyle(fontSize: 20), // 날짜 글자 크기 조정
              weekendTextStyle: TextStyle(fontSize: 20), // 주말 글자 크기 조정
              // 여기에 더 많은 스타일 조정을 추가할 수 있습니다.
            ),
            headerStyle: const HeaderStyle(
                formatButtonVisible: false, // 달력 포맷 버튼 숨기기
                titleCentered: true),
            rowHeight: 100, // 달력 행의 높이 조정
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
                _selectedEvents = _getEventsForDay(selectedDay);
              });
            },
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, date, events) {
                var emoji = _getEventsForDay(date).join();
                return Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    emoji.isNotEmpty
                        ? Text(
                            emoji,
                            style: const TextStyle(
                              fontSize: 36,
                            ),
                          )
                        : Container(
                            width: 50,
                            height: 50,
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                          ),
                    Text(
                      date.day.toString(),
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
