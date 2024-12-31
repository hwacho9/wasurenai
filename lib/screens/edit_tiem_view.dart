import 'package:flutter/material.dart';
import 'package:wasurenai/data/app_colors.dart';
import 'package:wasurenai/screens/item_list_screen.dart';
import 'package:wasurenai/screens/widget/item_modal_helper.dart';
import 'package:wasurenai/widgets/Buttons/CircleFloatingActionButton.dart';
import 'package:wasurenai/widgets/add_modal.dart';
import '../../models/situation.dart';
import '../../viewmodels/edit_item_view_model.dart';
import '../../widgets/custom_list_tile.dart';
import '../../widgets/custom_header.dart';
import 'package:provider/provider.dart';

class EditItemView extends StatefulWidget {
  final Situation situation;
  final String userId;

  const EditItemView({
    Key? key,
    required this.situation,
    required this.userId,
  }) : super(key: key);

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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ItemListScreen(
                    situation: widget.situation,
                    userId: widget.userId,
                  ),
                ),
              );
            },
          ),
          // 리스트 콘텐츠
          Padding(
            padding: const EdgeInsets.only(top: 150), // 헤더 아래로 내용 배치
            child: viewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : viewModel.items.isEmpty
                    ? const Center(child: Text('リストがビューにありません。'))
                    : ListView.builder(
                        itemCount: viewModel.items.length,
                        itemBuilder: (context, index) {
                          final item = viewModel.items[index];
                          return CustomListTile(
                            title: item.name,
                            subtitle: item.location,
                            showSwitch: false,
                            onTap: () {},
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: AppColors.lightRed),
                                  onPressed: () {
                                    _showEditItemModal(
                                        context, viewModel, item);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: AppColors.lightRed),
                                  onPressed: () {
                                    viewModel.deleteItem(
                                      widget.userId,
                                      widget.situation.name,
                                      item,
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: CircleFloatingActionButton(
        onPressed: () {
          showAddItemModal(
              context, viewModel, widget.userId, widget.situation.name);
        },
        icon: Icons.add_circle_outline,
      ),
    );
  }

  void _showEditItemModal(
      BuildContext context, EditItemViewModel viewModel, Item item) {
    final oldName = item.name; // 원래 이름 저장

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return AddModal(
          title: 'アイテムを編集',
          labels: const ['アイテムの名前', '忘れた時のための "お助けメモ"'],
          hints: const ['名前を入力してください', '場所などのメモを入力してください'],
          initialValues: [item.name, item.location], // 기존 값 전달
          buttonText: '更新する',
          onSubmit: (values) {
            final updatedName = values[0];
            final updatedLocation = values[1];
            viewModel.updateItem(
              widget.userId,
              widget.situation.name,
              oldName, // 기존 이름 전달
              Item(name: updatedName, location: updatedLocation),
            );
          },
        );
      },
    );
  }
}
