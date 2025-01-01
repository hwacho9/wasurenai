import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wasurenai/data/app_colors.dart';
import 'package:wasurenai/screens/auth/terms_and_privacy_view.dart';
import 'package:wasurenai/splash_view.dart';
import 'package:wasurenai/viewmodels/settings_view_model.dart';
import 'package:wasurenai/widgets/custom_card.dart';
import 'package:wasurenai/widgets/custom_header.dart';

class SettingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SettingsViewModel>(context);
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final user = _auth.currentUser;
    final uid = user?.uid;

    return Scaffold(
      body: Stack(
        children: [
          // 상단 HOME 버튼
          CustomHeader(
            title: 'HOME',
            onBackPress: () {
              Navigator.pop(context); // 뒤로가기 동작
            },
          ),
          // 설정 카드
          Positioned(
            left: 53,
            top: 200,
            child: CustomCard(
              text: '設定',
              color: AppColors.lightRed,
              onTap: () {
                // 설정 카드 동작
              },
            ),
          ),
          Positioned(
            left: 53,
            top: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomCard(
                  color: Colors.white,
                  text: 'アラーム設定',
                  onTap: () {},
                  trailing: FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('Users')
                        .doc(uid) // 사용자 ID
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }

                      if (!snapshot.hasData || snapshot.data == null) {
                        return const Text('データなし');
                      }

                      final data =
                          snapshot.data!.data() as Map<String, dynamic>;
                      final bool isAlarmOn = data['isAlarmOn'] ?? false;

                      return Theme(
                        data: ThemeData(
                          useMaterial3: true,
                        ).copyWith(
                          colorScheme: Theme.of(context)
                              .colorScheme
                              .copyWith(outline: AppColors.lightRed),
                        ),
                        child: Switch(
                          value: isAlarmOn,
                          onChanged: (bool newValue) async {
                            await viewModel.toggleIsAlarmOn(uid!, isAlarmOn);
                          },
                          activeColor: Colors.white,
                          activeTrackColor: AppColors.lightRed,
                          inactiveTrackColor: Colors.white,
                          inactiveThumbColor: AppColors.lightRed,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 25), // 두 버튼 사이 간격 추가
                // TODO: "言語" 変換
                // CustomCard(
                //   color: Colors.white,
                //   text: '言語',
                //   onTap: () {},
                // ),
                // const SizedBox(height: 25),

                CustomCard(
                  color: Colors.white,
                  text: '利用契約&プライバシーポリシー',
                  onTap: () {
                    // 이용약관 및 개인정보 처리방침 화면으로 이동
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TermsAndPrivacyView(),
                        ));
                  },
                ),
                const SizedBox(height: 25), // 두 버튼 사이 간격 추가
                CustomCard(
                  color: Colors.white,
                  text: 'ログアウト',
                  onTap: () {
                    // "更新準備中です" 메시지 다이얼로그 표시
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('ログアウトしますか？'),
                          content: const Text('ログアウトしますか？'),
                          backgroundColor: Colors.white,
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // 다이얼로그 닫기
                              },
                              child: const Text(
                                'キャンセル',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                await viewModel.logout();
                                // 다이얼로그 닫기
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SplashView()),
                                );

                                // 삭제 완료 메시지 표시
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('ログアウトしました。'),
                                  ),
                                );
                              },
                              child: const Text(
                                'ログアウト',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 30), // 두 버튼 사이 간격 추가
                // TextButton for "アカウントを削除"
                TextButton(
                  onPressed: () {
                    // 확인 다이얼로그 표시
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          title: const Text('アカウントを削除する'),
                          content: const Text('本当にアカウントを削除しますか？'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // 다이얼로그 닫기
                              },
                              child: const Text(
                                'キャンセル',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 10),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // 확인 다이얼로그 닫기

                                // 비밀번호 입력 다이얼로그 호출
                                _showPasswordInputDialog(context, viewModel);
                              },
                              child: const Text(
                                'アカウントを削除',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text(
                    'アカウントを削除',
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void _showPasswordInputDialog(
    BuildContext context, SettingsViewModel viewModel) async {
  final TextEditingController passwordController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('パスワードを入力してください'),
        content: TextField(
          controller: passwordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'パスワード',
            hintText: 'パスワードを入力してください',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // 다이얼로그 닫기
            },
            child: const Text('キャンセル', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              final password = passwordController.text;

              if (password.isNotEmpty) {
                try {
                  await viewModel.deleteAccount(password); // 회원 삭제 호출

                  Navigator.of(context).pop(); // 입력 다이얼로그 닫기

                  // 삭제 후 스플래시 화면으로 이동
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SplashView()),
                  );

                  // 성공 메시지 표시
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('アカウントが削除されました。')),
                  );
                } catch (e) {
                  // 실패 메시지 표시
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('削除に失敗しました: $e')),
                  );
                }
              }
            },
            child: const Text('確認', style: TextStyle(color: Colors.red)),
          ),
        ],
      );
    },
  );
}
