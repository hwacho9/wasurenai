import 'package:flutter/material.dart';
import '../models/situation.dart';
import '../services/item_service.dart';

class ItemListViewModel extends ChangeNotifier {
  List<Item> _items = [];
  bool _isLoading = false;
  String? _currentSituationName;

  List<Item> get items => _items;
  bool get isLoading => _isLoading;

  final ItemService _itemService = ItemService();

  void setSituation(String situationName) {
    if (_currentSituationName != situationName) {
      _currentSituationName = situationName;
      _items = [];
      notifyListeners();
    }
  }

  Future<void> fetchItems(String userId, String situationName) async {
    if (_currentSituationName != situationName) {
      setSituation(situationName);
    }
    _isLoading = true;
    notifyListeners();

    debugPrint("situationName: $situationName");
    try {
      _items = await _itemService.fetchItems(userId, situationName);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addItem(String userId, String situationName, Item item) async {
    try {
      await _itemService.addItemToSituation(userId, situationName, item);
      _items.add(item);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to add item: $e');
    }
  }

  void updateItemState(int index, bool isChecked) {
    _items[index].isChecked = isChecked;
    notifyListeners();
  }

  Future<void> updateItemCheckedState(
      String userId, String situationName, int index, bool isChecked) async {
    try {
      _items[index].isChecked = isChecked;
      notifyListeners();
      // Firebase 업데이트
      await _itemService.updateItemCheckedState(
        userId,
        situationName,
        _items[index],
      );
    } catch (e) {
      debugPrint('Failed to update item checked state: $e');
    }
  }

  Future<void> resetAllItems(String userId, String situationName) async {
    try {
      for (var item in _items) {
        item.isChecked = false;
      }
      notifyListeners();
      // Firebase 업데이트
      await _itemService.resetAllItems(userId, situationName, _items);
    } catch (e) {
      debugPrint('Failed to reset items: $e');
    }
  }
}
