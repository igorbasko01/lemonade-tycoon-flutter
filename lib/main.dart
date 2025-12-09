import 'package:flutter/material.dart';
import 'package:lemonade_tycoon/view_models/game_view_model.dart';
import 'package:provider/provider.dart';
import 'game_screen.dart';

void main() {
  runApp(const LemonadeTycoonApp());
}

class LemonadeTycoonApp extends StatelessWidget {
  const LemonadeTycoonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GameViewModel(),
      child: MaterialApp(
        title: 'Lemonade Tycoon',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
          useMaterial3: true,
        ),
        home: const GameScreen(),
      ),
    );
  }
}
