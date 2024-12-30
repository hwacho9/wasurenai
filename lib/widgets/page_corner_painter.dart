import 'package:flutter/material.dart';

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
