import 'package:wasurenai/services/notification_service.dart';

class NotificationViewModel {
  final NotificationService _notificationService = NotificationService();

  Future<void> updateNotificationSettings({
    required String userId,
    required String situationName,
    required Map<String, bool> alarmDays,
    required String alarmTime,
  }) async {
    await _notificationService.updateNotificationSettings(
      userId: userId,
      situationName: situationName,
      alarmDays: alarmDays,
      alarmTime: alarmTime,
    );
  }

  Future<Map<String, dynamic>> getNotificationSettings({
    required String userId,
    required String situationName,
  }) async {
    return await _notificationService.getNotificationSettings(
      userId: userId,
      situationName: situationName,
    );
  }
}
