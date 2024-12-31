import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color? color;

  const CustomCard({
    required this.text,
    required this.onTap,
    this.color,
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
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
