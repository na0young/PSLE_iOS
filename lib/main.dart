import 'package:flutter/material.dart';
import 'package:psle/screens/home_screen.dart';
import 'package:psle/screens/login_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PSLE',
      home: const HomeScreen(),
    );
  }
}
