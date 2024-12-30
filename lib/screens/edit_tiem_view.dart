import 'package:flutter/material.dart';
import '../../models/situation.dart';
import '../../viewmodels/edit_item_view_model.dart';
import '../../widgets/custom_list_tile.dart';
import 'package:provider/provider.dart';

class EditItemView extends StatefulWidget {
  final Situation situation;
  final String userId;

  EditItemView({required this.situation, required this.userId});

  @override
  _EditItemViewState createState() => _EditItemViewState();
}

class _EditItemViewState extends State<EditItemView> {
  late EditItemViewModel viewModel;

  @override
  void initState() {
    super.initState();

    // ViewModel 초기화 및 데이터 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel = Provider.of<EditItemViewModel>(context, listen: false);
      viewModel.fetchItems(widget.userId, widget.situation.name);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<EditItemViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text('${widget.situation.name} 편집')),
      body: viewModel.isLoading
          ? Center(child: CircularProgressIndicator())
          : viewModel.items.isEmpty
              ? Center(child: Text('리스트가 비어 있습니다.'))
              : ListView.builder(
                  itemCount: viewModel.items.length,
                  itemBuilder: (context, index) {
                    final item = viewModel.items[index];
                    return CustomListTile(
                      title: item.name,
                      subtitle: item.location,
                      showSwitch: false,
                      onTap: () {},
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          viewModel.deleteItem(
                              widget.userId, widget.situation.name, item);
                        },
                      ),
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

  void _showAddItemModal(BuildContext context, EditItemViewModel viewModel) {
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
                    viewModel.addItem(widget.userId, widget.situation.name,
                        Item(name: itemName, location: itemLocation));
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
