import 'package:flutter_test/flutter_test.dart';
import 'package:weather_mobile_app/core/utils/unit_converter.dart';

void main() {
  group('UnitConverter Tests', () {
    test('celsiusToFahrenheit converts correctly', () {
      expect(UnitConverter.celsiusToFahrenheit(0), 32);
      expect(UnitConverter.celsiusToFahrenheit(20), 68);
      expect(UnitConverter.celsiusToFahrenheit(100), 212);
    });

    test('fahrenheitToCelsius converts correctly', () {
      expect(UnitConverter.fahrenheitToCelsius(32), 0);
      expect(UnitConverter.fahrenheitToCelsius(68), 20);
    });

    test('formatTemperature returns proper string with degree symbol', () {
      expect(UnitConverter.formatTemperature(20, TemperatureUnit.celsius), '20°');
      expect(UnitConverter.formatTemperature(20, TemperatureUnit.fahrenheit), '68°');
    });

    test('getTemperatureValue returns rounded int', () {
      expect(UnitConverter.getTemperatureValue(20.4, TemperatureUnit.celsius), 20);
      expect(UnitConverter.getTemperatureValue(20.0, TemperatureUnit.fahrenheit), 68);
    });
  });
}
