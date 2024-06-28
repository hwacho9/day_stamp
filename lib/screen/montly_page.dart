import 'package:flutter/material.dart';

class MontlyPage extends StatefulWidget {
  const MontlyPage({super.key});

  @override
  _MontlyPageState createState() => _MontlyPageState();
}

class _MontlyPageState extends State<MontlyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text('월간 캘린더'),
          ],
        ),
      ),
    );
  }
}
