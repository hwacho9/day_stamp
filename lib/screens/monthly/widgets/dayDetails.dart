import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_stamp/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DayDetails {
  final String diary;
  final String emoji;
  final String weather;
  final String day;

  DayDetails(
      {required this.day,
      required this.diary,
      required this.emoji,
      required this.weather});
}

class DayDetailsComponent {
  static Future<DayDetails> getDayDetails(
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

    // Format selectedDay to match the date format in Firestore
    String formattedDate = "${selectedDay.month}月${selectedDay.day}日";

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
      return DayDetails(
          day: formattedDate,
          diary: diaryEntry,
          emoji: emoji,
          weather: weather);
    } else {
      // Return default or placeholder values if no matching document is found
      return DayDetails(
          day: "",
          diary: "No entry for this day.",
          emoji: "😊",
          weather: "Sunny");
    }
  }

  static Future<void> showDayDetailsModal(
      BuildContext context, DateTime selectedDay) async {
    final details = await getDayDetails(context, selectedDay);
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("${details.day}"),
              Image.asset(
                details.emoji,
                width: 60,
                height: 60,
              ),
              // Text(
              //     "Weather: ${details.weather}"), //  details 객체의 weather 필드에 접근
              Text("Diary: ${details.diary}"), // details 객체의 필드에 접근
            ],
          ),
        );
      },
    );
  }
}
