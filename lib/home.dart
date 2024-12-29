import 'package:flutter/material.dart';
import 'models/situation.dart';
import 'item_list_screen.dart';

class HomeScreen extends StatelessWidget {
  final List<Situation> situations = [
    Situation(
      name: '학교 갈 때',
      items: [
        Item(name: '책', location: '책상 위'),
        Item(name: '노트북', location: '가방 안'),
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
          return ListTile(
            title: Text(situations[index].name),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ItemListScreen(situation: situations[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
