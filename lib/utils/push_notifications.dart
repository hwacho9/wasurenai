import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class PushNotificationService {
  Future<void> setupPushNotifications() async {
    final fcm = FirebaseMessaging.instance;

    // 알림 권한 요청
    await fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Foreground 알림 설정
    await fcm.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // FCM 토큰 출력 (디버깅용)
    final token = await fcm.getToken();
    debugPrint('FCM Token: $token');
  }
}
