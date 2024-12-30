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
