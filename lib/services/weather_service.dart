import 'dart:math';
import '../models/weather.dart';

class WeatherService {
  final Random _random = Random();
  WeatherType _currentWeather = WeatherType.sunny;

  WeatherType get currentWeather => _currentWeather;

  void startDay() {
    _randomizeWeather();
  }

  void _randomizeWeather() {
    _currentWeather =
        WeatherType.values[_random.nextInt(WeatherType.values.length)];
  }
}
