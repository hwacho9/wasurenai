import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../../models/situation.dart';
import '../../widgets/custom_list_tile.dart';

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
    if (items.isEmpty) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 1.0,
          child: CardSwiper(
            cardsCount: items.length,
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
                          Text(item.name,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center),
                          SizedBox(height: 10),
                          Text(item.location,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                              textAlign: TextAlign.center),
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

  void _showAddItemModal() {
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
                    setState(() {
                      items.add(Item(name: itemName, location: itemLocation));
                    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.situation.name,
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return CustomListTile(
            title: item.name,
            subtitle: item.location,
            isChecked: item.isChecked,
            onCheckedChange: (bool value) {
              setState(() {
                item.isChecked = value;
              });
            },
            onTap: _showItemSwiper,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddItemModal,
        child: Icon(Icons.add),
      ),
    );
  }
}
