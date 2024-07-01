import 'package:flutter/material.dart';
import 'package:day_stamp/service/user_service.dart';
import 'package:day_stamp/models/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel? _currentUser;

  UserProvider() {
    initializeUser().catchError((error) {
      // 예외 처리 추가
      debugPrint('initializeUser error: $error');
    });
  }

  Future<void> initializeUser() async {
    try {
      debugPrint('Initializing user...');
      _currentUser = await UserService().getCurrentUser();
      notifyListeners(); // 상태 변경 알림
      debugPrint('User initialized: ${_currentUser?.email}');
    } catch (e) {
      debugPrint('Error in initializeUser: $e');
      throw e; // 예외를 다시 던져서 외부에서 처리할 수 있도록 함
    }
  }

  UserModel? get currentUser => _currentUser;
}
