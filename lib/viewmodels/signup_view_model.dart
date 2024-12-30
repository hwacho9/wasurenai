import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class SignupViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  String email = '';
  String password = '';
  String? errorMessage;

  Future<void> signup() async {
    try {
      errorMessage = null;
      await _authService.signUpWithEmail(email, password);
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }
}
