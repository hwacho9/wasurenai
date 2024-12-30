import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:wasurenai/widgets/Buttons/reusable_buttons.dart';
import 'package:wasurenai/screens/edit_tiem_view.dart';
import '../../models/situation.dart';
import '../../widgets/custom_list_tile.dart';
import '../../widgets/custom_header.dart';

class ItemListScreen extends StatefulWidget {
  final Situation situation;
  final String userId;

  const ItemListScreen(
      {super.key, required this.situation, required this.userId});

  @override
  _ItemListScreenState createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
  late List<Item> items;

  @override
  void initState() {
    super.initState();
    // 초기화: 상황의 아이템 리스트를 로컬에 저장
    items = List.from(widget.situation.items);
  }

  void _updateItemCheckedState(int index, bool isChecked) {
    setState(() {
      items[index].isChecked = isChecked;
    });
  }

  // 카드 스와이퍼를 표시하는 함수
  void _showItemSwiper(BuildContext context, int index) {
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
    return Scaffold(
      body: Stack(
        children: [
          // 상단 헤더
          CustomHeader(
            title: widget.situation.name,
            onBackPress: () {
              Navigator.pop(context); // 이전 화면으로 이동
            },
          ),
          Column(
            children: [
              const SizedBox(height: 150), // 헤더 높이 조정
              Expanded(
                child: items.isEmpty
                    ? const Center(child: Text('リストが空です。'))
                    : ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return CustomListTile(
                            title: item.name,
                            subtitle: item.location,
                            isChecked: item.isChecked,
                            onCheckedChange: (bool value) {
                              _updateItemCheckedState(index, value);
                            },
                            onTap: () {
                              _showItemSwiper(context, index);
                            },
                            showSwitch: true,
                          );
                        },
                      ),
              ),
              // 하단 버튼
              ReusableButtons(
                settingsBackgroundColor: Colors.white, // 설정 버튼 배경색
                settingsForegroundColor: Colors.black, // 설정 버튼 텍스트 색
                editBackgroundColor: Colors.white, // 편집 버튼 배경색
                editForegroundColor: Colors.black, // 편집 버튼 텍스트 색
                settingsLabel: 'リセット',
                settingsIcon: Icons.restart_alt,
                onPressed: () {
                  // 설정 버튼 동작
                },
                editLabel: '編集',
                editIcon: Icons.edit,
                onEditPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditItemView(
                        situation: widget.situation,
                        userId: widget.userId,
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
