import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  String email = '';
  String password = '';
  String? errorMessage;

  Future<void> login() async {
    try {
      errorMessage = null;
      await _authService.signInWithEmail(email, password);
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }
}
