import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:wasurenai/widgets/Buttons/reusable_buttons.dart';
import 'package:wasurenai/screens/edit_tiem_view.dart';
import '../../models/situation.dart';
import '../../services/item_service.dart';
import '../../widgets/custom_list_tile.dart';
import '../../widgets/custom_header.dart';

class ItemListScreen extends StatelessWidget {
  final Situation situation;
  final String userId;

  ItemListScreen({required this.situation, required this.userId});

  // 카드 스와이퍼를 표시하는 함수
  void _showItemSwiper(BuildContext context, List<Item> items, int index) {
    if (items.isEmpty) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.8,
          child: CardSwiper(
            cardsCount: items.length,
            initialIndex: index,
            numberOfCardsDisplayed: items.length < 5 ? items.length : 5,
            cardBuilder:
                (context, index, percentThresholdX, percentThresholdY) {
              final item = items[index];
              return Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: Card(
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
                                fontSize: 20, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            item.location,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.grey),
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

  @override
  Widget build(BuildContext context) {
    final ItemService itemService = ItemService();

    return Scaffold(
      body: Stack(
        children: [
          // 상단 헤더
          CustomHeader(
            title: situation.name,
            onBackPress: () {
              Navigator.pop(context); // 이전 화면으로 이동
            },
          ),
          Column(
            children: [
              const SizedBox(height: 150), // 헤더 높이 조정
              Expanded(
                child: StreamBuilder<List<Item>>(
                  stream: itemService.listenToItems(userId, situation.name),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('리스트가 비어 있습니다.'));
                    }

                    final items = snapshot.data!;

                    return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return CustomListTile(
                          title: item.name,
                          subtitle: item.location,
                          showSwitch: false, // 스위치 비활성화
                          onTap: () {
                            _showItemSwiper(context, items, index);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              // 하단 버튼
              ReusableButtons(
                settingsLabel: '설정',
                settingsIcon: Icons.settings,
                onPressed: () {
                  // 설정 버튼 동작
                },
                editLabel: '편집',
                editIcon: Icons.edit,
                onEditPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditItemView(
                        situation: situation,
                        userId: userId,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
