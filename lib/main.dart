import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wasurenai/data/colors.dart';
import 'package:wasurenai/firebase_options.dart';
import 'package:wasurenai/provider/auth_provider.dart';
import 'package:wasurenai/screens/auth/login_veiw.dart';
import 'package:wasurenai/splash_view.dart';
import 'package:wasurenai/viewmodels/login_view_model.dart';
import 'package:wasurenai/viewmodels/signup_view_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => SignupViewModel()),
      ],
      child: MaterialApp(
        title: '물건 체크 앱',
        theme: ThemeData(
          primarySwatch: AppColors.primarySwatch,
          scaffoldBackgroundColor: AppColors.scaffoldBackground,
          appBarTheme: const AppBarTheme(
            color: AppColors.appBarBackground,
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashView(),
      ),
    );
  }
}
