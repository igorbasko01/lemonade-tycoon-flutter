import '../../models/daily_report.dart';
import '../../models/player.dart';

import '../../models/shop.dart';
import '../../models/weather.dart';
import 'strategies/simulation_strategy.dart';
import 'strategies/weather_based_strategy.dart';

class SimulationService {
  final SimulationStrategy _strategy;

  SimulationService({SimulationStrategy? strategy})
    : _strategy = strategy ?? WeatherBasedSimulationStrategy();

  DailyReport simulateDay({
    required Player player,
    required Shop shop,
    required int dayNumber,
    required WeatherType weather,
  }) {
    final context = SimulationContext(
      player: player,
      shop: shop,
      dayNumber: dayNumber,
      weather: weather,
    );
    return _strategy.run(context);
  }
}
