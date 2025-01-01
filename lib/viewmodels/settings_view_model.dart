import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';

class SettingsViewModel extends ChangeNotifier {
  final AuthService _authService;

  SettingsViewModel(this._authService);

  Future<void> logout() async {
    try {
      await _authService.logout();
      // 필요하면 notifyListeners()를 호출해 UI에 변경 사항을 알립니다.
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to logout: $e');
    }
  }

  Future<void> deleteAccount(String password) async {
    try {
      await _authService.deleteAccount(password); // 비밀번호 전달
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to delete account: $e');
    }
  }
}