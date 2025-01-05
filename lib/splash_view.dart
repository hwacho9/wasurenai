import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart'; // ATT 패키지
import 'package:wasurenai/provider/auth_provider.dart';
import 'package:wasurenai/screens/home_view.dart';
import 'welcome_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _requestTrackingPermission(); // initState에서 권한 요청
    _navigateBasedOnAuth(); // 인증 상태에 따라 화면 이동
  }

  Future<void> _requestTrackingPermission() async {
    final status = await AppTrackingTransparency.trackingAuthorizationStatus;

    if (status == TrackingStatus.notDetermined) {
      final result =
          await AppTrackingTransparency.requestTrackingAuthorization();
      print('Tracking permission status: $result');
    }
  }

  Future<void> _navigateBasedOnAuth() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await Future.delayed(const Duration(seconds: 1)); // 스플래시 화면 표시 시간
    if (authProvider.user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeView()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeView()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/icon.png', // 로컬 이미지 경로
              width: 250, // 원하는 크기로 설정
              height: 250,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
