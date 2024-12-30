import 'package:flutter/material.dart';
import 'package:wasurenai/widgets/custom_card.dart';
import 'package:wasurenai/widgets/custom_header.dart';

class SettingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
            top: 250,
            child: CustomCard(
              text: '設定',
              onTap: () {
                // 설정 카드 동작
              },
            ),
          ),
        ],
      ),
    );
  }
}
