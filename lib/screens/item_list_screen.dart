import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wasurenai/screens/home_view.dart';
import 'package:wasurenai/widgets/Buttons/reusable_buttons.dart';
import 'package:wasurenai/screens/edit_tiem_view.dart';
import 'package:wasurenai/widgets/custom_card.dart';
import 'package:wasurenai/widgets/item_swiper.dart';
import '../../models/situation.dart';
import '../../viewmodels/item_list_view_model.dart';
import '../../widgets/custom_list_tile.dart';
import '../../widgets/custom_header.dart';

class ItemListScreen extends StatefulWidget {
  final Situation situation;
  final String userId;

  const ItemListScreen({
    Key? key,
    required this.situation,
    required this.userId,
  }) : super(key: key);

  @override
  _ItemListScreenState createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
  late ItemListViewModel viewModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel = Provider.of<ItemListViewModel>(context, listen: false);
      viewModel.fetchItems(widget.userId, widget.situation.name);
    });
  }

  void _updateItemCheckedState(int index, bool isChecked) {
    viewModel.updateItemCheckedState(
        widget.userId, widget.situation.name, index, isChecked);
  }

  void _resetItems() {
    viewModel.resetAllItems(widget.userId, widget.situation.name);
  }

  void _showItemSwiper(BuildContext context, int index) {
    if (viewModel.items.isEmpty) return;

    showItemSwiper(
      context: context,
      items: viewModel.items,
      initialIndex: index,
      updateItemCheckedState: _updateItemCheckedState,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomHeader(
            title: 'HOME',
            onBackPress: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeView(),
                ),
              );
            },
          ),
          Column(
            children: [
              const SizedBox(height: 200),
              CustomCard(
                text: widget.situation.name,
                onTap: () {},
              ),
              const SizedBox(height: 25),
              Expanded(
                child: Consumer<ItemListViewModel>(
                  builder: (context, viewModel, _) {
                    if (viewModel.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (viewModel.items.isEmpty) {
                      return const Center(child: Text('リストが空です。'));
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.only(bottom: 100),
                      itemCount: viewModel.items.length,
                      itemBuilder: (context, index) {
                        final item = viewModel.items[index];
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
                    );
                  },
                ),
              ),
              const SizedBox(height: 130),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ReusableButtons(
              settingsBackgroundColor: Colors.white,
              settingsForegroundColor: Colors.black,
              editBackgroundColor: Colors.white,
              editForegroundColor: Colors.black,
              settingsLabel: 'リセット',
              settingsIcon: Icons.restart_alt,
              onPressed: _resetItems,
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
          ),
        ],
      ),
    );
  }
}
