import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'buy_ingredients_screen.dart';
import 'prepare_lemonade_screen.dart';
import 'set_prices_screen.dart';
import '../view_models/game_view_model.dart';

class GameMenuScreen extends StatelessWidget {
  const GameMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<GameViewModel>(
          builder: (context, viewModel, child) {
            return Text('Day ${viewModel.gameManager.currentDay} - Morning');
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<GameViewModel>(
              builder: (context, viewModel, child) {
                return Column(
                  children: [
                    Text(
                      'Balance: \$${viewModel.balance.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Weather: ${viewModel.currentWeather.displayName}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      'Traffic: ${(viewModel.currentWeather.customerMultiplier * 100).toInt()}%',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const BuyIngredientsScreen(),
                  ),
                );
              },
              child: const Text('Buy Ingredients'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const PrepareLemonadeScreen(),
                  ),
                );
              },
              child: const Text('Prepare Lemonade'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SetPricesScreen(),
                  ),
                );
              },
              child: const Text('Set Prices'),
            ),
            const SizedBox(height: 48),
            Consumer<GameViewModel>(
              builder: (context, viewModel, child) {
                return ElevatedButton(
                  onPressed: () {
                    viewModel.startDaySimulation();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Start Day',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
