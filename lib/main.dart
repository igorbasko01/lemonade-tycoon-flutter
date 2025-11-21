import 'package:flutter/material.dart';
import 'welcome_screen.dart';

void main() {
  runApp(const LemonadeTycoonApp());
}

class LemonadeTycoonApp extends StatelessWidget {
  const LemonadeTycoonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lemonade Tycoon',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
    );
  }
}
