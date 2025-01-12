import 'package:flutter/material.dart';
import 'package:wasurenai/widgets/add_modal.dart';
import '../../models/situation.dart';
import '../../viewmodels/edit_item_view_model.dart';

void showAddItemModal(BuildContext context, EditItemViewModel viewModel,
    String userId, String situationName) {
  debugPrint("✅ showAddItemModal 실행됨");

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
        title: 'アイテムを追加',
        labels: const ['アイテムの名前', '忘れた時のための "お助けメモ"'],
        hints: const ['名前を入力してください', '(任意)場所などのメモを入力してください'],
        buttonText: '追加する',
        onSubmit: (values) {
          debugPrint("✅ onSubmit 콜백 실행됨: $values");

          final itemName = values[0].trim();
          var itemMemo = values[1].trim();

          if (itemName.isEmpty) {
            debugPrint("⚠️ 아이템 이름이 비어있음 (onSubmit 내부)");
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('アイテムの名前を入力してください。')),
            );
            return;
          }

          if (itemMemo.isEmpty) {
            itemMemo = '';
            debugPrint("ℹ️ 메모가 비어있어 기본값 설정");
          }

          viewModel.addItem(
            userId,
            situationName,
            Item(name: itemName, location: itemMemo),
          );

          debugPrint("✅ 아이템 추가 완료");
        },
      );
    },
  );
}

void showEditItemModal(BuildContext context, EditItemViewModel viewModel,
    String userId, String situationName, Item item) {
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
        hints: const ['名前を入力してください', '(任意)場所などのメモを入力してください'],
        initialValues: [item.name, item.location], // 기존 값 전달
        buttonText: '更新する',
        onSubmit: (values) {
          final updatedName = values[0];
          final updatedLocation = values[1];
          viewModel.updateItem(
            userId,
            situationName,
            oldName, // 기존 이름 전달
            Item(name: updatedName, location: updatedLocation),
          );
        },
      );
    },
  );
}
