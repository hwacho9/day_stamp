import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomTableCalendar extends StatelessWidget {
  final DateTime firstDay;
  final DateTime lastDay;
  final DateTime focusedDay;
  final CalendarFormat calendarFormat;
  final Function(DateTime) onPageChanged;
  final Function(DateTime, DateTime) onDaySelected;
  final List<dynamic> Function(DateTime) getEventsForDay;

  const CustomTableCalendar({
    Key? key,
    required this.firstDay,
    required this.lastDay,
    required this.focusedDay,
    required this.calendarFormat,
    required this.onPageChanged,
    required this.onDaySelected,
    required this.getEventsForDay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
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
      onDaySelected: onDaySelected,
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, date, events) {
          var emoji = getEventsForDay(date).join();
          return Column(
            children: [
              const SizedBox(height: 20),
              emoji.isNotEmpty
                  ? Text(emoji, style: const TextStyle(fontSize: 36))
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
                  ? Text(
                      emoji,
                      style: const TextStyle(
                        fontSize: 36,
                      ),
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
                  ? Text(
                      emoji,
                      style: const TextStyle(
                        fontSize: 36,
                      ),
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
