import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wasurenai/screens/home_view.dart';
import 'package:wasurenai/viewmodels/signup_view_model.dart';

class SignupView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SignupViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
            ElevatedButton(
              onPressed: () async {
                await viewModel.signup();
                if (viewModel.errorMessage == null) {
                  // 회원가입 성공 시 홈 뷰로 이동
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeView()),
                  );
                }
              },
              child: Text('Sign Up'),
            ),
            if (viewModel.errorMessage != null)
              Text(viewModel.errorMessage!,
                  style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
