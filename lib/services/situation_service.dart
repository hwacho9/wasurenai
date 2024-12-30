import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/situation.dart';

class SituationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Situation>> getSituations() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final snapshot = await _firestore
        .collection('Users')
        .doc(user.uid)
        .collection('situations')
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Situation(
        name: data['name'],
        items: (data['items'] as List<dynamic>)
            .map((item) => Item(
                  name: item['name'],
                  location: item['location'],
                ))
            .toList(),
      );
    }).toList();
  }

  Future<void> addSituation(String name) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await _firestore
        .collection('Users')
        .doc(user.uid)
        .collection('situations')
        .add({
      'name': name,
      'items': [],
    });
  }

  Future<void> deleteSituation(String name) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot = await _firestore
        .collection('Users')
        .doc(user.uid)
        .collection('situations')
        .where('name', isEqualTo: name)
        .get();

    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }
}
