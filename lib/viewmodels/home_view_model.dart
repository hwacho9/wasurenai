import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../models/situation.dart';
import '../services/home_service.dart';

class HomeViewModel extends ChangeNotifier {
  final HomeService _homeService = HomeService();

  List<Situation> _situations = [];
  List<Situation> get situations => _situations;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final fcm = FirebaseMessaging.instance;

  Stream<List<Situation>> fetchSituations(String userId) {
    if (userId.isNotEmpty) {
      fcm.subscribeToTopic(userId).then((_) {
        // 성공적으로 구독했을 경우 디버그 로그 출력
        debugPrint('Subscribed to topic: $userId');
      }).catchError((error) {
        // 구독 중 에러 발생 시 디버그 로그 출력
        debugPrint('Failed to subscribe to topic $userId: $error');
      });
    } else {
      debugPrint('User ID is null, cannot subscribe to FCM topic.');
    }

    return _homeService.getSituations(userId).map((situations) {
      // 상황 데이터를 로깅
      debugPrint('Fetched situations for user $userId: $situations');
      return situations;
    });
  }
}
