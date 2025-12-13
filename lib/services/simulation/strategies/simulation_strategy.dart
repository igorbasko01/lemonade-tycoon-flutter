import '../../../models/daily_report.dart';
import '../../../models/player.dart';
import '../../../models/shop.dart';
import '../../../models/weather.dart';

class SimulationContext {
  final Player player;
  final Shop shop;
  final int dayNumber;
  final WeatherType weather;

  SimulationContext({
    required this.player,
    required this.shop,
    required this.dayNumber,
    required this.weather,
  });
}

abstract class SimulationStrategy {
  DailyReport run(SimulationContext context);
}
