import 'package:flutter/material.dart';
import 'package:lemonade_tycoon/models/game_manager.dart';
import 'package:lemonade_tycoon/view_models/game_view_model.dart';
import 'package:provider/provider.dart';
import 'screens/game_screen.dart';

void main() {
  runApp(const LemonadeTycoonApp());
}

class LemonadeTycoonApp extends StatelessWidget {
  const LemonadeTycoonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<GameManager>(create: (_) => GameManager()),
        ChangeNotifierProxyProvider<GameManager, GameViewModel>(
          create: (context) =>
              GameViewModel(gameManager: context.read<GameManager>()),
          update: (context, gameManager, previous) =>
              previous ?? GameViewModel(gameManager: gameManager),
        ),
      ],
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
