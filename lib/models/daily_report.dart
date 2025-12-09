import 'ingredients.dart';

class DailyReport {
  final int dayNumber;
  final double startingFunds;
  final double endingFunds;
  final int customersServed;
  final int potentialCustomers;
  final Map<Ingredient, int> itemsSold;

  double get totalProfit => endingFunds - startingFunds;

  DailyReport({
    required this.dayNumber,
    required this.startingFunds,
    required this.endingFunds,
    required this.customersServed,
    required this.potentialCustomers,
    required this.itemsSold,
  });
}
