import 'package:flutter/material.dart';
import '../models/situation.dart';
import '../services/item_service.dart';

class ItemListViewModel extends ChangeNotifier {
  final ItemService _itemService = ItemService();
  List<Item> _items = [];
  bool _isLoading = false;
  String? _currentSituationName;

  List<Item> get items => _items;
  bool get isLoading => _isLoading;

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
}