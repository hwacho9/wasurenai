import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:wasurenai/data/app_colors.dart';
import 'package:wasurenai/models/situation.dart';

void showItemSwiper({
  required BuildContext context,
  required List<Item> items,
  required int initialIndex,
  required void Function(int index, bool isChecked) updateItemCheckedState,
}) {
  if (items.isEmpty) return;

  showModalBottomSheet(
    backgroundColor: Colors.white,
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return FractionallySizedBox(
        heightFactor: 0.7,
        child: CardSwiper(
          cardsCount: items.length,
          initialIndex: initialIndex,
          numberOfCardsDisplayed: items.length,
          onSwipe: (int? previousIndex, int? currentIndex,
              CardSwiperDirection direction) {
            if (currentIndex != null && currentIndex < items.length) {
              final swipedItem = items[previousIndex!];

              // isChecked를 true로 업데이트
              updateItemCheckedState(previousIndex, true);

              // 디버그 메세지 출력
              debugPrint(
                  'Swiped item "${swipedItem.name}" isChecked set to true');
              debugPrint(
                  'Swiped from index $previousIndex to $currentIndex in direction $direction');
            }
            return true; // 스와이프 허용
          },
          onEnd: () {
            debugPrint('You have reached the end of the cards.');

            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: Colors.white, // 다이얼로그 배경을 흰색으로 설정
                  title: const Text(
                    '全てチェックしました！',
                    style: TextStyle(
                      color: Colors.black, // 제목 텍스트 색상
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: const Text(
                    '最後のカードに到達しました。',
                    style: TextStyle(
                      color: Colors.black, // 내용 텍스트 색상
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // 다이얼로그 닫기
                      },
                      child: const Text(
                        'OK',
                        style: TextStyle(
                          color: AppColors.lightRed, // 버튼 텍스트 색상
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
          cardBuilder: (context, index, percentThresholdX, percentThresholdY) {
            final item = items[index];
            return Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.55,
                child: Card(
                  color: AppColors.scaffoldBackground,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          item.location,
                          style: const TextStyle(
                              fontSize: 30, color: Colors.black54),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    },
  );
}
