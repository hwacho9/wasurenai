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
            const Text(
              '◯◯アプリへようこそ！',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'いつでも同期できるようにサインインしてください',
              style: TextStyle(fontSize: 15),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            RectangleButton(
              text: 'メーアドでログイン',
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
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignupView()),
                );
              },
              child: const Text(
                '会員登録',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
