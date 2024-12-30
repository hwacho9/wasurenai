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
  late List<Item> localItems;

  @override
  void initState() {
    super.initState();
    // 로컬 상태 초기화
    localItems = List.from(widget.situation.items);
  }

  void _updateItemCheckedState(int index, bool isChecked) {
    setState(() {
      localItems[index].isChecked = isChecked;
    });
  }

  void _resetItems() {
    setState(() {
      for (var item in localItems) {
        item.isChecked = false;
      }
    });
  }

  void _showItemSwiper(BuildContext context, int index) {
    if (localItems.isEmpty) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        if (localItems.isEmpty) {
          return const Center(child: Text('No items available'));
        }

        return FractionallySizedBox(
          heightFactor: 0.8,
          child: CardSwiper(
            cardsCount: localItems.length,
            initialIndex: index,
            numberOfCardsDisplayed:
                localItems.length < 5 ? localItems.length : 5,
            cardBuilder:
                (context, index, percentThresholdX, percentThresholdY) {
              final item = localItems[index];
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
                child: localItems.isEmpty
                    ? const Center(child: Text('リストが空です。'))
                    : ListView.builder(
                        itemCount: localItems.length,
                        itemBuilder: (context, index) {
                          final item = localItems[index];
                          return CustomListTile(
                            title: item.name,
                            subtitle: item.location,
                            isChecked: item.isChecked,
                            onCheckedChange: (bool value) {
                              _updateItemCheckedState(index, value);
                            },
                            onTap: () {
                              _showItemSwiper(
                                  context, index); // 클릭 시 카드 스와이퍼 표시
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
                onPressed: _resetItems, // 리셋 버튼 동작
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
