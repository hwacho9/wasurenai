import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color? color;
  final IconData? icon; // 선택적으로 아이콘을 추가할 수 있는 필드
  final Widget? trailing; // 추가된 trailing 필드

  const CustomCard({
    required this.text,
    required this.onTap,
    this.color,
    this.icon, // 아이콘 초기값은 null
    this.trailing,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 287,
        height: 45,
        decoration: BoxDecoration(
          color: color ?? Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: const [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 2.99,
              offset: Offset(-0.96, 1.93),
            ),
          ],
        ),
        child: Stack(
          children: [
            InkWell(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16), // 양쪽 여백 추가
                child: Center(
                  child: Expanded(
                    child: Text(
                      text,
                      maxLines: 1, // 최대 줄 수를 1로 설정
                      overflow: TextOverflow.ellipsis, // 글자가 넘치면 "..."으로 표시
                      textAlign: TextAlign.left, // 왼쪽 정렬
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (icon != null) // 아이콘이 존재하는 경우만 표시
              Positioned(
                right: 16,
                top: 0,
                bottom: 0,
                child: Icon(
                  icon,
                  color: Colors.black, // 아이콘 색상
                  size: 20, // 아이콘 크기
                ),
              ),
            if (trailing != null) // trailing이 존재하는 경우만 표시
              Positioned(
                right: 16,
                top: 0,
                bottom: 0,
                child: trailing!,
              ),
          ],
        ),
      ),
    );
  }
}
