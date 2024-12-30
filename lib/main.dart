import 'package:flutter/material.dart';
import 'package:wasurenai/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '물건 체크 앱',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // #D0C3B4
        scaffoldBackgroundColor: Color.fromARGB(255, 227, 224, 221),
        appBarTheme: AppBarTheme(
          color: Color.fromARGB(255, 209, 95, 104),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}
