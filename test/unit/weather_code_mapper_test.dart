import 'package:flutter_test/flutter_test.dart';
import 'package:weather_mobile_app/core/utils/weather_code_mapper.dart';

void main() {
  group('WeatherCodeMapper Tests', () {
    test('Code 0 Day maps to Sunny', () {
      final res = WeatherCodeMapper.map(0, isDay: true);
      expect(res.description, 'Sunny');
    });

    test('Code 0 Night maps to Clear Night', () {
      final res = WeatherCodeMapper.map(0, isDay: false);
      expect(res.description, 'Clear Night');
    });

    test('Code 1 and 2 map to Partly Cloudy', () {
      final res1 = WeatherCodeMapper.map(1, isDay: true);
      final res2 = WeatherCodeMapper.map(2, isDay: true);
      expect(res1.description, 'Partly Cloudy');
      expect(res2.description, 'Partly Cloudy');
    });

    test('Code 61 maps to Scattered Showers', () {
      final res = WeatherCodeMapper.map(61);
      expect(res.description, 'Scattered Showers');
    });

    test('Code 95 maps to Thunderstorm', () {
      final res = WeatherCodeMapper.map(95);
      expect(res.description, 'Thunderstorm');
    });

    test('Null code falls back safely', () {
      final res = WeatherCodeMapper.map(null);
      expect(res.description, 'Clear');
    });
  });
}
