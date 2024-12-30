import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wasurenai/provider/auth_provider.dart';
import 'package:wasurenai/screens/home_view.dart';
import 'welcome_view.dart';

class SplashView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: _navigateBasedOnAuth(context),
          builder: (context, snapshot) {
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  Future<void> _navigateBasedOnAuth(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await Future.delayed(Duration(seconds: 1)); // 스플래시 화면 표시 시간
    if (authProvider.user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeView()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomeView()),
      );
    }
  }
}
