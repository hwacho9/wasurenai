// home_screen.dart
import 'package:flutter/material.dart';
import '../../models/situation.dart';
import 'item_list_screen.dart';
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
        title: Text('상황별 체크리스트'),
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
