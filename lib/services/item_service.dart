import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/situation.dart';

class ItemService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addItemToSituation(
      String userId, String situationName, Item item) async {
    try {
      final situationRef = _firestore
          .collection('Users')
          .doc(userId)
          .collection('situations')
          .doc(situationName);

      final doc = await situationRef.get();

      if (doc.exists) {
        // 기존 상황에 새 항목 추가
        await situationRef.update({
          'items': FieldValue.arrayUnion([item.toJson()]),
        });
      } else {
        // 상황이 없으면 새로 생성
        await situationRef.set({
          'name': situationName,
          'items': [item.toJson()],
        });
      }
    } catch (e) {
      throw Exception('Failed to add item: $e');
    }
  }

  Future<List<Item>> fetchItems(String userId, String situationName) async {
    try {
      final situationRef = _firestore
          .collection('Users')
          .doc(userId)
          .collection('situations')
          .doc(situationName);

      final doc = await situationRef.get();

      if (doc.exists) {
        final data = doc.data();
        if (data != null && data['items'] != null) {
          return (data['items'] as List<dynamic>)
              .map((itemJson) => Item.fromJson(itemJson))
              .toList();
        }
      }

      return [];
    } catch (e) {
      throw Exception('Failed to fetch items: $e');
    }
  }

  Future<void> deleteItem(
      String userId, String situationName, Item item) async {
    try {
      // 해당 situation 문서 가져오기
      final situationDoc = _firestore
          .collection('Users')
          .doc(userId)
          .collection('situations')
          .doc(situationName);

      final snapshot = await situationDoc.get();

      if (snapshot.exists) {
        final data = snapshot.data();
        final List<dynamic> items = data?['items'] ?? [];

        // items 배열에서 삭제할 item 제외
        final updatedItems = items.where((element) {
          return element['name'] != item.name ||
              element['location'] != item.location;
        }).toList();

        // 업데이트된 배열 Firestore에 저장
        await situationDoc.update({'items': updatedItems});
      }
    } catch (e) {
      print('Error deleting item: $e');
    }
  }

  Stream<List<Item>> listenToItems(String userId, String situationName) {
    return _firestore
        .collection('Users')
        .doc(userId)
        .collection('situations')
        .doc(situationName)
        .snapshots()
        .map((snapshot) {
      final data = snapshot.data();
      if (data != null && data['items'] != null) {
        return (data['items'] as List<dynamic>)
            .map((itemJson) => Item.fromJson(itemJson))
            .toList();
      } else {
        return [];
      }
    });
  }

  Future<void> updateItemOrder(
      String userId, String situationName, List<Item> items) async {
    try {
      // 아이템 리스트를 JSON으로 변환
      final itemsJson = items.map((item) => item.toJson()).toList();

      // Firestore에 저장
      await _firestore
          .collection('Users')
          .doc(userId)
          .collection('situations')
          .doc(situationName)
          .update({'items': itemsJson});
    } catch (e) {
      throw Exception('Failed to update item order: $e');
    }
  }

  Future<void> updateItemCheckedState(
      String userId, String situationName, Item item) async {
    try {
      final situationRef = _firestore
          .collection('Users')
          .doc(userId)
          .collection('situations')
          .doc(situationName);

      final snapshot = await situationRef.get();
      if (snapshot.exists) {
        final data = snapshot.data()!;
        final items = (data['items'] as List<dynamic>)
            .map((itemJson) => Item.fromJson(itemJson))
            .toList();

        final updatedItems = items.map((existingItem) {
          if (existingItem.name == item.name) {
            return item.toJson();
          }
          return existingItem.toJson();
        }).toList();

        await situationRef.update({'items': updatedItems});
      }
    } catch (e) {
      throw Exception('Failed to update item checked state: $e');
    }
  }

  Future<void> resetAllItems(
      String userId, String situationName, List<Item> items) async {
    try {
      final situationRef = _firestore
          .collection('Users')
          .doc(userId)
          .collection('situations')
          .doc(situationName);

      final updatedItems = items
          .map((item) => item.copyWith(isChecked: false).toJson())
          .toList();

      await situationRef.update({'items': updatedItems});
    } catch (e) {
      throw Exception('Failed to reset items: $e');
    }
  }
}
