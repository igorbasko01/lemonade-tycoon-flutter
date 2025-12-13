import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'game_menu_screen.dart';
import 'day_summary_screen.dart';
import '../models/game_manager.dart';
import '../view_models/game_view_model.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameViewModel>(
      builder: (context, viewModel, child) {
        switch (viewModel.gameManager.currentPhase) {
          case GamePhase.morning:
            return const GameMenuScreen();
          case GamePhase.day:
            // For MVP instant simulation, we might momentarily see this
            // or we could show a "Simulating..." spinner.
            return const Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Simulating Day...'),
                  ],
                ),
              ),
            );
          case GamePhase.evening:
            return const DaySummaryScreen();
        }
      },
    );
  }
}
