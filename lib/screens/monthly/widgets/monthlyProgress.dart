import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class MonthlyProgressIndicator extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final userId;
  final String collectionMonth;

  const MonthlyProgressIndicator({
    super.key,
    required this.userId,
    required this.collectionMonth,
  });

  @override
  _MonthlyProgressIndicatorState createState() =>
      _MonthlyProgressIndicatorState();
}

class _MonthlyProgressIndicatorState extends State<MonthlyProgressIndicator> {
  int totalDays = 0;
  int filledDays = 0;

  @override
  void initState() {
    super.initState();
    calculateDays();
  }

  void calculateDays() async {
    // 현재 월의 총 일수 계산
    final now = DateTime.now();
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    final totalDaysTemp = lastDayOfMonth.day;

    // Firestore에서 현재 월에 해당하는 entries의 수 계산
    final querySnapshot = await FirebaseFirestore.instance
        .collection('entries')
        .doc(widget.userId)
        .collection(widget.collectionMonth)
        .get();
    final filledDaysTemp = querySnapshot.docs.length;

    // 상태 업데이트
    setState(() {
      totalDays = totalDaysTemp;
      filledDays = filledDaysTemp;
    });
  }

  @override
  Widget build(BuildContext context) {
    double fillPercentage = totalDays > 0 ? (filledDays / totalDays) * 100 : 0;
    // print(fillPercentage);
    return Row(
      children: [
        // Expanded(
        //   child: LinearProgressIndicator(
        //     value: fillPercentage / 100,
        //     backgroundColor: Colors.grey[300],
        //     valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
        //   ),
        // ),
        LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          double screenWidth = MediaQuery.of(context).size.width;
          return SizedBox(
            width: screenWidth * 0.9, // 명시적인 너비 제공
            height: 50, // 명시적인 높이 제공
            child: CustomPaint(
              painter: ThermometerPainter(fillPercentage: fillPercentage),
            ),
          );
        }),
        Icon(
          fillPercentage == 100 ? Icons.check_circle : Icons.circle,
          color: fillPercentage == 100 ? Colors.orange : Colors.grey,
        ),
      ],
    );
  }
}

class ThermometerPainter extends CustomPainter {
  final double fillPercentage; // 0 to 100
  final double padding = 10.0; // 패딩 값
  final double borderRadius = 8.0; // 보더 라디우스 값

  ThermometerPainter({required this.fillPercentage});

  @override
  void paint(Canvas canvas, Size size) {
    Paint backgroundPaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.fill;

    Paint fillPaint = Paint()
      ..color = const Color.fromARGB(255, 247, 162, 191)
      ..style = PaintingStyle.fill;

    // 온도계 배경 그리기 (패딩과 둥근 모서리 적용)
    RRect backgroundRRect = RRect.fromLTRBR(
        padding, // left
        padding, // top
        size.width - padding, // right
        size.height - padding, // bottom
        Radius.circular(borderRadius)); // 둥근 모서리 반경
    canvas.drawRRect(backgroundRRect, backgroundPaint);

    // 온도계 채워진 부분 그리기 (패딩과 둥근 모서리 적용)
    double fillWidth = (size.width - 2 * padding) * (fillPercentage / 100);
    RRect fillRRect = RRect.fromLTRBR(
        padding, // left
        padding, // top
        padding + fillWidth, // right
        size.height - padding, // bottom
        Radius.circular(borderRadius)); // 둥근 모서리 반경
    canvas.drawRRect(fillRRect, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // 간단한 예제에서는 항상 다시 그립니다.
  }
}
