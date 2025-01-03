import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 알림 설정 업데이트
  Future<void> updateNotificationSettings({
    required String userId,
    required String situationName,
    required Map<String, bool> alarmDays,
    required String alarmTime,
    required bool isAlarmOn, // 추가
  }) async {
    try {
      // Firestore 경로
      final situationRef = _firestore
          .collection('Users')
          .doc(userId)
          .collection('situations')
          .doc(situationName);

      // 알림 설정 업데이트
      await situationRef.update({
        'alarmDays': alarmDays,
        'alarmTime': alarmTime,
        'isAlarmOn': isAlarmOn, // 추가
      });

      print("Notification settings updated successfully.");
    } catch (e) {
      throw Exception('Failed to update notification settings: $e');
    }
  }

  /// 알림 설정 가져오기
  Future<Map<String, dynamic>> getNotificationSettings({
    required String userId,
    required String situationName,
  }) async {
    try {
      final situationRef = _firestore
          .collection('Users')
          .doc(userId)
          .collection('situations')
          .doc(situationName);

      final snapshot = await situationRef.get();

      if (snapshot.exists) {
        final data = snapshot.data();
        return {
          'alarmDays': data?['alarmDays'] ?? {},
          'alarmTime': data?['alarmTime'] ?? "",
          'isAlarmOn': data?['isAlarmOn'] ?? false, // 추가
        };
      } else {
        throw Exception('Situation not found.');
      }
    } catch (e) {
      throw Exception('Failed to fetch notification settings: $e');
    }
  }
}
