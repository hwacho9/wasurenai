import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:wasurenai/screens/home_view.dart';
import 'package:wasurenai/widgets/Buttons/reusable_buttons.dart';
import 'package:wasurenai/screens/edit_tiem_view.dart';
import 'package:wasurenai/widgets/custom_card.dart';
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
    // ViewModel 초기화 및 데이터 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel = Provider.of<ItemListViewModel>(context, listen: false);
      viewModel.fetchItems(widget.userId, widget.situation.name);
    });
  }

  void _updateItemCheckedState(int index, bool isChecked) {
    // Firebase와 통신하여 체크 상태 업데이트
    viewModel.updateItemCheckedState(
        widget.userId, widget.situation.name, index, isChecked);
  }

  void _resetItems() {
    // Firebase와 통신하여 모든 체크 상태 초기화
    viewModel.resetAllItems(widget.userId, widget.situation.name);
  }

  void _showItemSwiper(BuildContext context, int index) {
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
            title: 'HOME',
            onBackPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeView(),
                ),
              );
            },
          ),
          Column(
            children: [
              const SizedBox(height: 200), // 헤더 아래로 내용 배치
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
                      padding:
                          const EdgeInsets.only(bottom: 100), // 버튼 영역과 겹치지 않게
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
              // 하단 버튼 위에 공간 추가
              const SizedBox(height: 130), // ReusableButtons 영역 확보
            ],
          ),
          // 하단 버튼
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
