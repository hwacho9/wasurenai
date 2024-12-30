import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/situation.dart';

class HomeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Situation>> getSituations(String userId) {
    return _firestore
        .collection('Users')
        .doc(userId)
        .collection('situations')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Situation(
          name: data['name'],
          items: (data['items'] as List<dynamic>)
              .map((item) => Item.fromJson(item))
              .toList(),
        );
      }).toList();
    });
  }
}
