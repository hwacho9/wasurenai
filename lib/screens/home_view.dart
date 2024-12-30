import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wasurenai/provider/auth_provider.dart';
import 'package:wasurenai/screens/item_list_screen.dart';
import 'package:wasurenai/splash_view.dart';
import '../../models/situation.dart';
import '../../widgets/custom_list_tile.dart';

class HomeView extends StatelessWidget {
  final List<Situation> situations = [
    Situation(
      name: '学校に行くとき',
      items: [
        Item(name: '本', location: '机の上'),
        Item(name: '鍵', location: '玄関'),
        Item(name: 'マックブック', location: '机の上'),
      ],
    ),
    Situation(
      name: '운동하러 갈 때',
      items: [
        Item(name: '운동화', location: '신발장'),
        Item(name: '물병', location: '부엌'),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('상황별 체크리스트'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              final authProvider =
                  Provider.of<AuthProvider>(context, listen: false);
              await authProvider.signOut();

              // 로그아웃 후 SplashView로 이동
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => SplashView()),
                (route) => false, // 이전 경로 제거
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: situations.length,
        itemBuilder: (context, index) {
          final situation = situations[index];
          return CustomListTile(
            title: situation.name,
            subtitle: '', // 필요한 경우 상황에 맞는 설명 추가
            showSwitch: false, // 스위치 대신 화살표 표시
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ItemListScreen(situation: situation),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class PageCornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 회색 삼각형
    final paintGray = Paint()
      ..color = Color.fromARGB(255, 222, 216, 209)
      ..style = PaintingStyle.fill;

    final pathGray = Path();
    pathGray.moveTo(0, 0); // 시작점
    pathGray.lineTo(size.width, 0); // 위쪽 경계선
    pathGray.lineTo(0, size.height); // 왼쪽 경계선
    pathGray.close(); // 삼각형 닫기

    canvas.drawPath(pathGray, paintGray);

    // 빨간색 삼각형
    final paintRed = Paint()
      ..color = Color.fromARGB(255, 229, 151, 151)
      ..style = PaintingStyle.fill;

    final pathRed = Path();
    pathRed.moveTo(size.width, size.height); // 오른쪽 아래
    pathRed.lineTo(size.width, size.height - size.height); // 중간 높이
    pathRed.lineTo(size.width - size.width, size.height); // 중간 너비
    pathRed.close(); // 삼각형 닫기

    canvas.drawPath(pathRed, paintRed);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
