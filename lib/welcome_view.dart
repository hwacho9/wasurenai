import 'package:flutter/material.dart';
import 'package:wasurenai/screens/auth/login_veiw.dart';
import 'package:wasurenai/screens/auth/signup_view.dart';
import 'package:wasurenai/widgets/Buttons/RectangleButton.dart';

class WelcomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/icon.png', // 로컬 이미지 경로
              width: 200, // 원하는 크기로 설정
              height: 200,
            ),
            const Text(
              'MOTTAへようこそ',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'いつでも同期できるようにサインインしましょう！',
              style: TextStyle(fontSize: 15),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            RectangleButton(
              text: 'ログイン',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginView()),
                );
              },
              color: Colors.white,
              textColor: Colors.black,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
