import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wasurenai/screens/home_view.dart';
import 'package:wasurenai/viewmodels/signup_view_model.dart';
import 'package:wasurenai/widgets/Buttons/RectangleButton.dart';
import 'package:wasurenai/widgets/Input_form_field.dart';

class SignupView extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SignupViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('新規登録')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
              onPressed: () async {
                viewModel.email = emailController.text;
                viewModel.password = passwordController.text;

                await viewModel.signup();
                if (viewModel.errorMessage == null) {
                  // 회원가입 성공 시 홈 뷰로 이동
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
              text: '新規登録',
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
          ],
        ),
      ),
    );
  }
}
