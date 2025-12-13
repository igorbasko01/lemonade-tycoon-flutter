import 'package:flutter_test/flutter_test.dart';
import 'package:lemonade_tycoon/models/weather.dart';

void main() {
  group('WeatherType', () {
    test('Sunny multiplier should be 1.5', () {
      expect(WeatherType.sunny.customerMultiplier, 1.5);
    });

    test('Cloudy multiplier should be 1.0', () {
      expect(WeatherType.cloudy.customerMultiplier, 1.0);
    });

    test('Rainy multiplier should be 0.6', () {
      expect(WeatherType.rainy.customerMultiplier, 0.6);
    });

    test('Display names should be correct', () {
      expect(WeatherType.sunny.displayName, 'Sunny');
      expect(WeatherType.cloudy.displayName, 'Cloudy');
      expect(WeatherType.rainy.displayName, 'Rainy');
    });
  });
}
