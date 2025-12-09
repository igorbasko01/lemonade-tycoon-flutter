import 'daily_report.dart';

enum GamePhase { morning, day, evening }

class GameManager {
  int _currentDay = 0;
  GamePhase _currentPhase = GamePhase.morning;
  DailyReport? _lastDailyReport;

  int get currentDay => _currentDay;
  GamePhase get currentPhase => _currentPhase;
  DailyReport? get lastDailyReport => _lastDailyReport;

  void startMorning() {
    _currentDay++;
    _currentPhase = GamePhase.morning;
  }

  void startDay() {
    _currentPhase = GamePhase.day;
  }

  void endDay(DailyReport report) {
    _lastDailyReport = report;
    _currentPhase = GamePhase.evening;
  }
}
