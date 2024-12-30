import 'package:flutter/material.dart';
import '../models/situation.dart';
import '../services/home_service.dart';

class HomeViewModel extends ChangeNotifier {
  final HomeService _homeService = HomeService();

  List<Situation> _situations = [];
  List<Situation> get situations => _situations;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Stream<List<Situation>> fetchSituations(String userId) {
    return _homeService.getSituations(userId);
  }
}
