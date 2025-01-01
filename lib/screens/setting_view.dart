import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wasurenai/data/app_colors.dart';
import 'package:wasurenai/splash_view.dart';
import 'package:wasurenai/viewmodels/settings_view_model.dart';
import 'package:wasurenai/widgets/custom_card.dart';
import 'package:wasurenai/widgets/custom_header.dart';

class SettingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SettingsViewModel>(context);
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
                // CustomCard for "言語"
                CustomCard(
                  color: Colors.white,
                  text: '言語',
                  onTap: () {
                    // "更新準備中です" 메시지 다이얼로그 표시
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          title: const Text('お知らせ'),
                          content: const Text('更新準備中です。'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // 다이얼로그 닫기
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
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
                const SizedBox(height: 375), // 두 버튼 사이 간격 추가
                // TextButton for "アカウントを削除"
                TextButton(
                  onPressed: () {
                    // 확인 다이얼로그 표시
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('アカウントを削除する'),
                          content: const Text('本当にアカウントを削除しますか？'),
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
                              onPressed: () {
                                // TODO: 회원 삭제 로직 호출

                                // 다이얼로그 닫기
                                Navigator.of(context).pop();

                                // 삭제 완료 메시지 표시
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('회원이 삭제되었습니다。'),
                                  ),
                                );
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
