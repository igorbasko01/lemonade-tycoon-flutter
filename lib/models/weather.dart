enum WeatherType {
  sunny,
  cloudy,
  rainy;

  double get customerMultiplier {
    switch (this) {
      case WeatherType.sunny:
        return 1.5;
      case WeatherType.cloudy:
        return 1.0;
      case WeatherType.rainy:
        return 0.6;
    }
  }

  String get displayName {
    switch (this) {
      case WeatherType.sunny:
        return 'Sunny';
      case WeatherType.cloudy:
        return 'Cloudy';
      case WeatherType.rainy:
        return 'Rainy';
    }
  }
}
