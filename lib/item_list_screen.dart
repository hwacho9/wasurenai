import 'package:flutter/material.dart';
import '../models/situation.dart';
import '../widgets/item_card.dart';

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

  void _showItemCard(int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 스크롤 제어 활성화
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 1.0, // 전체 화면 높이로 설정
          child: ItemCard(
            item: items[index],
            onCheckNext: () {
              setState(() {
                items[index].isChecked = true; // 현재 항목 체크
              });
              Navigator.pop(context);
              if (index < items.length - 1) {
                _showItemCard(index + 1); // 다음 항목으로 이동
              }
            },
            onCheckPrevious: () {
              setState(() {
                items[index].isChecked = true; // 현재 항목 체크
              });
              Navigator.pop(context);
              if (index > 0) {
                _showItemCard(index - 1); // 이전 항목으로 이동
              }
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
          widget.situation.name, // 상황 이름 표시
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey[100],
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: Offset(0, 2), // 그림자 방향
                    ),
                  ],
                ),
                child: ListTile(
                  key: Key('$index'),
                  title: Text(
                    item.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                  onTap: () => _showItemCard(index), // 리스트 아이템 클릭 시 카드 표시
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
