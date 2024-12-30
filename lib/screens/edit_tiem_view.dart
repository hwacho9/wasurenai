import 'package:flutter/material.dart';
import 'package:wasurenai/widgets/Buttons/CircleFloatingActionButton.dart';
import '../../models/situation.dart';
import '../../viewmodels/edit_item_view_model.dart';
import '../../widgets/custom_list_tile.dart';
import '../../widgets/custom_header.dart';
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
      body: Stack(
        children: [
          // CustomHeader 추가
          CustomHeader(
            title: widget.situation.name,
            onBackPress: () {
              Navigator.pop(context);
            },
          ),
          // 리스트 콘텐츠
          Padding(
            padding: const EdgeInsets.only(top: 150), // 헤더 아래로 내용 배치
            child: viewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : viewModel.items.isEmpty
                    ? const Center(child: Text('리스트가 비어 있습니다.'))
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
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                viewModel.deleteItem(
                                    widget.userId, widget.situation.name, item);
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: CircleFloatingActionButton(
        onPressed: () {
          _showAddItemModal(context, viewModel);
        },
        icon: Icons.add_circle_outline,
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
                decoration: const InputDecoration(labelText: 'Item Name'),
                onChanged: (value) {
                  itemName = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Item Location'),
                onChanged: (value) {
                  itemLocation = value;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (itemName.isNotEmpty && itemLocation.isNotEmpty) {
                    viewModel.addItem(widget.userId, widget.situation.name,
                        Item(name: itemName, location: itemLocation));
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add Item'),
              ),
            ],
          ),
        );
      },
    );
  }
}
