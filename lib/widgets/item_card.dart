import 'package:flutter/material.dart';
import '../models/situation.dart';

class ItemCard extends StatelessWidget {
  final Item item;
  final VoidCallback onCheckNext;
  final VoidCallback onCheckPrevious;

  ItemCard({
    required this.item,
    required this.onCheckNext,
    required this.onCheckPrevious,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity != null && details.primaryVelocity! < 0) {
          onCheckNext(); // 왼쪽 스와이프: 다음 항목으로 이동
        } else if (details.primaryVelocity != null &&
            details.primaryVelocity! > 0) {
          onCheckPrevious(); // 오른쪽 스와이프: 이전 항목으로 이동
        }
      },
      child: Container(
        color: Colors.white,
        child: Center(
          child: Card(
            margin: EdgeInsets.all(16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text(
                    item.location,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '왼쪽으로 스와이프하면 다음 항목, 오른쪽으로 스와이프하면 이전 항목',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
