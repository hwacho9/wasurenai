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
}
