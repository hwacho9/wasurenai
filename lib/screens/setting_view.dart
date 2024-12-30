import 'package:flutter/material.dart';
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

class CustomCard extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const CustomCard({
    required this.text,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 287,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: const [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 7.99,
              offset: Offset(-0.96, -1.93),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
