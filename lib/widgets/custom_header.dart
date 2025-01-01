import 'package:flutter/material.dart';

class CustomHeader extends StatelessWidget {
  final String title;
  final VoidCallback onBackPress;

  const CustomHeader({
    required this.title,
    required this.onBackPress,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      top: 100,
      child: GestureDetector(
        onTap: onBackPress,
        child: SizedBox(
          width: 120,
          height: 75,
          child: Row(
            children: [
              Container(
                width: 35.47,
                height: 40.47,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(),
                ),
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
              ),
              Expanded(
                child: Container(
                  height: 40.47,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(28),
                      bottomRight: Radius.circular(28),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      title,
                      maxLines: 1, // 최대 줄 수를 1로 설정
                      overflow: TextOverflow.ellipsis, // 글자가 넘치면 "..."으로 표시
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
