import 'package:flutter/material.dart';
import '../models/situation.dart';
import '../services/item_service.dart';

class EditItemViewModel extends ChangeNotifier {
  final ItemService _itemService = ItemService();

  List<Item> items = [];
  bool isLoading = false;

  // 아이템 목록 불러오기
  Future<void> fetchItems(String userId, String situationName) async {
    isLoading = true;
    notifyListeners();

    try {
      items = await _itemService.fetchItems(userId, situationName);
    } catch (e) {
      debugPrint('Error fetching items: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // 아이템 추가
  Future<void> addItem(String userId, String situationName, Item item) async {
    try {
      await _itemService.addItemToSituation(userId, situationName, item);
      items.add(item); // 로컬 데이터 업데이트
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding item: $e');
    }
  }

  // 아이템 삭제
  Future<void> deleteItem(
      String userId, String situationName, Item item) async {
    try {
      await _itemService.deleteItem(userId, situationName, item);
      items.removeWhere((existingItem) =>
          existingItem.name == item.name &&
          existingItem.location == item.location); // 로컬 데이터 업데이트
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting item: $e');
    }
  }

  void updateItemOrder(String userId, String situationName) async {
    try {
      await _itemService.updateItemOrder(userId, situationName, items);
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to update item order: $e');
    }
  }

  void updateItem(String userId, String situationName, String oldName,
      Item updatedItem) async {
    try {
      await _itemService.updateItem(
          userId, situationName, oldName, updatedItem);
      // UI 갱신을 위해 내부 리스트도 업데이트
      final index = items.indexWhere((item) => item.name == oldName);
      if (index != -1) {
        items[index] = updatedItem;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Failed to update item: $e');
    }
  }
}
