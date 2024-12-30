import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:provider/provider.dart';
import '../../models/situation.dart';
import '../../viewmodels/item_list_view_model.dart';
import '../../widgets/custom_list_tile.dart';

class ItemListScreen extends StatefulWidget {
  final Situation situation;
  final String userId;

  ItemListScreen({required this.situation, required this.userId});

  @override
  _ItemListScreenState createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
  late ItemListViewModel viewModel;

  @override
  void initState() {
    super.initState();

    // ViewModel 초기화 및 데이터 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel = Provider.of<ItemListViewModel>(context, listen: false);
      viewModel.fetchItems(widget.userId, widget.situation.name);
    });
  }

  // 카드 스와이퍼를 표시하는 함수
  void _showItemSwiper(int index, ItemListViewModel viewModel) {
    if (viewModel.items.isEmpty) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.8,
          child: CardSwiper(
            cardsCount: viewModel.items.length,
            initialIndex: index,
            numberOfCardsDisplayed:
                viewModel.items.length < 5 ? viewModel.items.length : 5,
            cardBuilder:
                (context, index, percentThresholdX, percentThresholdY) {
              final item = viewModel.items[index];
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
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10),
                          Text(
                            item.location,
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                            textAlign: TextAlign.center,
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
    final viewModel = Provider.of<ItemListViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.situation.name,
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: viewModel.isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: viewModel.items.length,
              itemBuilder: (context, index) {
                final item = viewModel.items[index];
                return CustomListTile(
                  title: item.name,
                  subtitle: item.location,
                  isChecked: item.isChecked,
                  onCheckedChange: (bool value) {
                    setState(() {
                      item.isChecked = value;
                    });
                  },
                  onTap: () {
                    _showItemSwiper(index, viewModel); // 클릭 시 스와이퍼 호출
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddItemModal(context, viewModel);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // 아이템 추가 모달 표시
  void _showAddItemModal(BuildContext context, ItemListViewModel viewModel) {
    String itemName = '';
    String itemLocation = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Item Name'),
                onChanged: (value) {
                  itemName = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Item Location'),
                onChanged: (value) {
                  itemLocation = value;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (itemName.isNotEmpty && itemLocation.isNotEmpty) {
                    final newItem =
                        Item(name: itemName, location: itemLocation);
                    viewModel.addItem(
                        widget.userId, widget.situation.name, newItem);
                    Navigator.pop(context);
                  }
                },
                child: Text('Add Item'),
              ),
            ],
          ),
        );
      },
    );
  }
}
