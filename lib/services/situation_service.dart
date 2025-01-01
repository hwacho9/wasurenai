import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/situation.dart';

class SituationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Firestore에서 모든 Situation 가져오기
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
        name: doc.id, // 도큐먼트 이름(situationName)을 name으로 사용
        items: (data['items'] as List<dynamic>)
            .map((item) => Item.fromJson(item))
            .toList(),
      );
    }).toList();
  }

  /// Firestore에 새로운 Situation 추가하기
  Future<void> addSituation(String situationName, String alarmTime,
      Map<String, bool> alarmDays) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await _firestore
        .collection('Users')
        .doc(user.uid)
        .collection('situations')
        .doc(situationName) // situationName을 도큐먼트 이름으로 사용
        .set({
      'name': situationName,
      'items': [], // 초기에는 빈 items 리스트
      'alarmTime': alarmTime, // 알람 시각 (예: "07:30")
      'alarmDays': alarmDays, // 알림 활성화 요일 (예: {'mon': true, 'tue': false, ...})
      'isAlarmOn': false, // 알림 활성화 여부
    });
  }

  /// Firestore에서 특정 Situation 삭제하기
  Future<void> deleteSituation(String situationName) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final situationRef = _firestore
        .collection('Users')
        .doc(user.uid)
        .collection('situations')
        .doc(situationName);

    await situationRef.delete();
  }
}
