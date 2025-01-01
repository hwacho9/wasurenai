import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wasurenai/screens/home_view.dart';
import 'package:wasurenai/viewmodels/login_view_model.dart';
import 'package:wasurenai/widgets/Buttons/RectangleButton.dart';
import 'package:wasurenai/widgets/Input_form_field.dart';
import 'signup_view.dart';

class LoginView extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LoginViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('ログイン')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InputFormField(
              controller: emailController,
              labelText: "メールアドレス",
              keyboardType: TextInputType.emailAddress,
              hintText: 'メールアドレスを入力してください',
            ),
            const SizedBox(height: 16),
            InputFormField(
              controller: passwordController,
              labelText: "パスワード",
              isPassword: true,
              hintText: 'パスワードを入力してください',
            ),
            const SizedBox(height: 16),
            RectangleButton(
              text: 'ログイン',
              onPressed: () async {
                viewModel.email = emailController.text;
                viewModel.password = passwordController.text;

                await viewModel.login();
                if (viewModel.errorMessage == null) {
                  // 로그인 성공 시 홈 뷰로 이동
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeView()),
                  );
                } else {
                  // 에러 메시지 표시
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(viewModel.errorMessage!),
                      backgroundColor: Colors.red,
                    ),
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
                  style: const TextStyle(color: Colors.red),
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
                  fontSize: 14,
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
