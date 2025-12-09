import 'package:flutter_test/flutter_test.dart';
import 'package:lemonade_tycoon/models/daily_report.dart';
import 'package:lemonade_tycoon/models/game_manager.dart';

void main() {
  late GameManager gameManager;

  setUp(() {
    gameManager = GameManager();
  });

  test('Initial state should be Morning Day 0', () {
    expect(gameManager.currentDay, 0);
    expect(gameManager.currentPhase, GamePhase.morning);
  });

  test('startDay should move to Day phase', () {
    gameManager.startMorning(); // Move to Day 1
    gameManager.startDay();
    expect(gameManager.currentPhase, GamePhase.day);
    expect(gameManager.currentDay, 1);
  });

  test(
    'endDay should move to Evening phase but NOT increment day counter yet',
    () {
      gameManager.startMorning(); // Day 1
      gameManager.startDay();
      gameManager.endDay(
        DailyReport(
          dayNumber: 1,
          startingFunds: 0,
          endingFunds: 0,
          customersServed: 0,
          potentialCustomers: 0,
          itemsSold: {},
        ),
      );

      expect(gameManager.currentPhase, GamePhase.evening);
      expect(gameManager.currentDay, 1); // Still day 1 in the evening
      expect(gameManager.lastDailyReport, isNotNull);
    },
  );

  test('startMorning should move to Morning phase and increment day', () {
    gameManager.startMorning(); // Day 1
    gameManager.startDay();
    gameManager.endDay(
      DailyReport(
        dayNumber: 1,
        startingFunds: 0,
        endingFunds: 0,
        customersServed: 0,
        potentialCustomers: 0,
        itemsSold: {},
      ),
    );
    gameManager.startMorning(); // Start Day 2 morning

    expect(gameManager.currentPhase, GamePhase.morning);
    expect(gameManager.currentDay, 2);
  });
}
