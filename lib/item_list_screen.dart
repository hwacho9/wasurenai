import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../models/situation.dart';

class ItemListScreen extends StatefulWidget {
  final Situation situation;

  ItemListScreen({required this.situation});

  @override
  _ItemListScreenState createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
  late List<Item> items;

  @override
  void initState() {
    super.initState();
    items = List.from(widget.situation.items);
  }

  void _showItemSwiper() {
    if (items.isEmpty) {
      // items가 비어 있는 경우 처리
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 1.0,
          child: CardSwiper(
            cardsCount: items.length,
            numberOfCardsDisplayed: items.length < 2 ? items.length : 2,
            cardBuilder:
                (context, index, percentThresholdX, percentThresholdY) {
              final item = items[index];
              return Center(
                // 카드 전체를 화면 가운데 정렬
                child: SizedBox(
                  width: MediaQuery.of(context).size.width *
                      0.8, // 화면 너비의 80%로 카드 크기 설정
                  height: MediaQuery.of(context).size.height *
                      0.4, // 화면 높이의 40%로 카드 크기 설정
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center, // 세로 방향 중앙 정렬
                        crossAxisAlignment:
                            CrossAxisAlignment.center, // 가로 방향 중앙 정렬
                        children: [
                          Text(
                            item.name,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center, // 텍스트 내용도 중앙 정렬
                          ),
                          SizedBox(height: 10),
                          Text(
                            item.location,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center, // 텍스트 내용도 중앙 정렬
                          ),
                          SizedBox(height: 20),
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
      appBar: AppBar(
        title: Text(
          widget.situation.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      key: Key('$index'),
                      title: Text(
                        item.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: Text(
                        item.location,
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      trailing: Switch(
                        value: item.isChecked,
                        onChanged: (bool value) {
                          setState(() {
                            item.isChecked = value;
                          });
                        },
                      ),
                      onTap: _showItemSwiper, // 리스트 아이템 클릭 시 스와이퍼 표시
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
