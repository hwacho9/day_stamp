import 'package:day_stamp/screens/analsis/analysis_page.dart';
import 'package:day_stamp/screens/daily/daily_page.dart';
import 'package:day_stamp/screens/login_page.dart';
import 'package:day_stamp/screens/monthly/monthly_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    DailyPage(),
    MonthlyPage(),
    AnalysisPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Day Stamp'),
                automaticallyImplyLeading: false,
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.exit_to_app),
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                    },
                  )
                ],
              ),
              body: WillPopScope(
                onWillPop: () async {
                  return false;
                },
                child: Center(
                  child: _widgetOptions.elementAt(_selectedIndex),
                ),
              ),
              bottomNavigationBar: BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.book),
                    label: '일기',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.calendar_today),
                    label: '캘린더',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.analytics),
                    label: '분석',
                  ),
                ],
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
              ),
            );
          }
          return const LoginPage();
        });
  }
}
