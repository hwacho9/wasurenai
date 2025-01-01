import 'package:flutter/material.dart';
import '../models/situation.dart';
import '../services/situation_service.dart';

class EditSituationsViewModel extends ChangeNotifier {
  final SituationService _situationService = SituationService();
  List<Situation> _situations = [];
  bool _isLoading = false;

  List<Situation> get situations => _situations;
  bool get isLoading => _isLoading;

  Future<void> fetchSituations() async {
    _isLoading = true; // 로딩 상태 활성화
    notifyListeners();

    try {
      _situations = await _situationService.getSituations();
    } finally {
      _isLoading = false; // 로딩 상태 비활성화
      notifyListeners();
    }
  }

  Future<void> addSituation(String name) async {
    // 알람 초기값 설정 (빈 시각과 빈 Map)
    const String initialAlarmTime = ""; // 빈 시각
    final Map<String, bool> initialAlarmDays = {
      'mon': false,
      'tue': false,
      'wed': false,
      'thu': false,
      'fri': false,
      'sat': false,
      'sun': false,
    };

    await _situationService.addSituation(
        name, initialAlarmTime, initialAlarmDays);
    await fetchSituations();
  }

  Future<void> deleteSituation(int index) async {
    final situation = _situations[index];
    await _situationService.deleteSituation(situation.name);
    await fetchSituations();
  }
}
