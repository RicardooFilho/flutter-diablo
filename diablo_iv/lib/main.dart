import 'package:diablo_iv/characterDashboard.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerenciador de Personagens',
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFF1A1A1A),
        scaffoldBackgroundColor: Color(0xFF1A1A1A),
      ),
      home: Dashboard(),
    );
  }
}
