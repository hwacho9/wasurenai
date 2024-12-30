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
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/icon.png', // 로컬 이미지 경로
                  width: 150, // 원하는 크기로 설정
                  height: 150,
                ),
                SizedBox(height: 20),
                CircularProgressIndicator(),
              ],
            );
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
