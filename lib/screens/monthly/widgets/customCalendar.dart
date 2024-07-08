import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_stamp/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class DayDetails {
  final String diary;
  final String emoji;
  final String weather;

  DayDetails({required this.diary, required this.emoji, required this.weather});
}

class CustomTableCalendar extends StatelessWidget {
  final DateTime firstDay;
  final DateTime lastDay;
  final DateTime focusedDay;
  final CalendarFormat calendarFormat;
  final Function(DateTime) onPageChanged;
  final Function(DateTime, DateTime) onDaySelected;
  final List<dynamic> Function(DateTime) getEventsForDay;

  const CustomTableCalendar({
    super.key,
    required this.firstDay,
    required this.lastDay,
    required this.focusedDay,
    required this.calendarFormat,
    required this.onPageChanged,
    required this.onDaySelected,
    required this.getEventsForDay,
  });

  Future<DayDetails> getDayDetails(
      BuildContext context, DateTime selectedDay) async {
    final user = Provider.of<UserProvider>(context, listen: false);
    var userId = user.currentUser?.uid;
    var year = selectedDay.year;
    var month = selectedDay.month
        .toString()
        .padLeft(2, '0'); // Ensure month is in two-digit format

    var collectionMonth =
        'entries_$year$month'; // Corrected string interpolation

    var collection = FirebaseFirestore.instance
        .collection('entries')
        .doc(userId)
        .collection(collectionMonth);

    // 선택된 날짜의 시작 (예: 2023-04-21 00:00:00)
    DateTime startOfDay =
        DateTime(selectedDay.year, selectedDay.month, selectedDay.day);

    // 다음 날짜의 시작 (예: 2023-04-22 00:00:00)
    DateTime startOfNextDay =
        DateTime(selectedDay.year, selectedDay.month, selectedDay.day + 1);

    // Firestore 쿼리 수정
    var querySnapshot = await collection
        .where('date', isGreaterThanOrEqualTo: startOfDay)
        .where('date', isLessThan: startOfNextDay)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Assuming each document has a 'diary' field or it might be null
      var diaryEntry = querySnapshot.docs.first.data()['diary'] as String? ??
          "No entry for this day.";
// Assuming you have emoji and weather fields, adjust as necessary
      var emoji = querySnapshot.docs.first.data()['emojis'] as String? ?? "😊";
      var weather =
          querySnapshot.docs.first.data()['weather'] as String? ?? "Sunny";
      return DayDetails(diary: diaryEntry, emoji: emoji, weather: weather);
    } else {
      // Return default or placeholder values if no matching document is found
      return DayDetails(
          diary: "No entry for this day.", emoji: "😊", weather: "Sunny");
    }
  }

  Future<void> showDayDetailsModal(
      BuildContext context, DateTime selectedDay) async {
    final details = await getDayDetails(context, selectedDay);
    print(details);
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("Diary: ${details.diary}"), // details 객체의 필드에 접근
              Text(
                  "Emoji: ${details.emoji}"), // 예를 들어, details 객체의 emoji 필드에 접근
              Text(
                  "Weather: ${details.weather}"), // 예를 들어, details 객체의 weather 필드에 접근
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      locale: 'ja-JP',
      calendarStyle: const CalendarStyle(
        defaultTextStyle: TextStyle(fontSize: 30),
        weekendTextStyle: TextStyle(fontSize: 20),
      ),
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
      rowHeight: 100,
      firstDay: firstDay,
      lastDay: lastDay,
      onPageChanged: onPageChanged,
      focusedDay: focusedDay,
      calendarFormat: calendarFormat,
      selectedDayPredicate: (day) => isSameDay(focusedDay, day),
      onDaySelected: (selectedDay, focusedDay) {
        showDayDetailsModal(context, selectedDay);
      },
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, date, events) {
          var emoji = getEventsForDay(date).join();
          return Column(
            children: [
              const SizedBox(height: 20),
              emoji.isNotEmpty
                  ? Image.asset(
                      emoji,
                      width: 60,
                      height: 60,
                    )
                  : Container(
                      width: 40,
                      height: 60,
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                    ),
              Text(
                date.day.toString(),
                style: const TextStyle(fontSize: 10, color: Colors.black),
              ),
            ],
          );
        },
        todayBuilder: (context, date, focusedDay) {
          var emoji = getEventsForDay(date).join();
          return Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              emoji.isNotEmpty
                  ? Image.asset(
                      emoji,
                      width: 60,
                      height: 60,
                    )
                  : Container(
                      width: 40,
                      height: 60,
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                    ),
              Container(
                padding: const EdgeInsets.only(
                    left: 20, right: 20), // 텍스트 주변에 여백을 추가
                decoration: BoxDecoration(
                  color: Colors.red, // 배경색을 파란색으로 설정
                  borderRadius: BorderRadius.circular(5), // 배경의 모서리를 둥글게
                ),
                child: Text(
                  date.day.toString(),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          );
        },
        selectedBuilder: (context, date, events) {
          var emoji = getEventsForDay(date).join();
          return Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              emoji.isNotEmpty
                  ? Image.asset(
                      emoji,
                      width: 60,
                      height: 60,
                    )
                  : Container(
                      width: 40,
                      height: 60,
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                    ),
              Container(
                padding: const EdgeInsets.only(
                    left: 20, right: 20), // 텍스트 주변에 여백을 추가
                decoration: BoxDecoration(
                  color: Colors.blue, // 배경색을 파란색으로 설정
                  borderRadius: BorderRadius.circular(5), // 배경의 모서리를 둥글게
                ),
                child: Text(
                  date.day.toString(),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          );
        },
        // Include todayBuilder and selectedBuilder with similar logic
      ),
    );
  }
}
