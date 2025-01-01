import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wasurenai/screens/home_view.dart';
import 'package:wasurenai/viewmodels/login_view_model.dart';
import 'package:wasurenai/widgets/Buttons/RectangleButton.dart';
import 'signup_view.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LoginViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Email'),
              onChanged: (value) => viewModel.email = value,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
              onChanged: (value) => viewModel.password = value,
            ),
            SizedBox(height: 16),
            RectangleButton(
              text: 'ログイン',
              onPressed: () async {
                await viewModel.login();
                if (viewModel.errorMessage == null) {
                  // 로그인 성공 시 홈 뷰로 이동
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeView()),
                  );
                }
              },
              color: Colors.white,
              textColor: Colors.black,
            ),
            if (viewModel.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  viewModel.errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignupView()),
                );
              },
              child: const Text(
                '新規登録',
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
