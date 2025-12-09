import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view_models/game_view_model.dart';

class DaySummaryScreen extends StatelessWidget {
  const DaySummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Day Summary')),
      body: Consumer<GameViewModel>(
        builder: (context, viewModel, child) {
          final report = viewModel.gameManager.lastDailyReport;

          if (report == null) {
            return const Center(child: Text('No report available.'));
          }

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Day ${report.dayNumber} Complete!',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 32),
                  _buildStatRow(
                    context,
                    'Starting Funds:',
                    '\$${report.startingFunds.toStringAsFixed(2)}',
                  ),
                  _buildStatRow(
                    context,
                    'Ending Funds:',
                    '\$${report.endingFunds.toStringAsFixed(2)}',
                  ),
                  const Divider(),
                  _buildStatRow(
                    context,
                    'Profit/Loss:',
                    '\$${report.totalProfit.toStringAsFixed(2)}',
                    isProfit: true,
                    numericValue: report.totalProfit,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Customers: ${report.customersServed} / ${report.potentialCustomers}',
                  ),
                  const SizedBox(height: 16),
                  const Text('Items Sold:'),
                  ...report.itemsSold.entries.map(
                    (e) => Text('${e.key.name}: ${e.value}'),
                  ),

                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      viewModel.nextMorning();
                    },
                    child: const Text('Start Next Day'),
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatRow(
    BuildContext context,
    String label,
    String value, {
    bool isProfit = false,
    double numericValue = 0,
  }) {
    Color? color;
    if (isProfit) {
      color = numericValue >= 0 ? Colors.green : Colors.red;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
