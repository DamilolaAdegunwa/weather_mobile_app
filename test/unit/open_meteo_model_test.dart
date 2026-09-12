import 'package:flutter_test/flutter_test.dart';
import 'package:weather_mobile_app/data/models/weather_model.dart';
import 'package:weather_mobile_app/data/models/hourly_forecast_model.dart';
import 'package:weather_mobile_app/data/models/daily_forecast_model.dart';

void main() {
  group('Open-Meteo Model Deserialization Tests', () {
    test('WeatherModel deserializes valid Open-Meteo JSON payload', () {
      final mockJson = {
        'current': {
          'temperature_2m': 20.0,
          'apparent_temperature': 18.9,
          'relative_humidity_2m': 74,
          'weather_code': 2,
          'is_day': 1,
          'wind_speed_10m': 14.0,
          'wind_direction_10m': 247.5,
          'wind_gusts_10m': 21.0,
        },
        'daily': {
          'temperature_2m_max': [22.2],
          'temperature_2m_min': [12.8],
          'uv_index_max': [4.0],
          'sunrise': ['2026-09-12T06:42:00'],
          'sunset': ['2026-09-12T19:58:00'],
        },
      };

      final model = WeatherModel.fromOpenMeteoJson(
        forecastJson: mockJson,
        cityName: 'San Francisco',
      );

      expect(model.cityName, 'San Francisco');
      expect(model.temperature, 20.0);
      expect(model.apparentTemperature, 18.9);
      expect(model.telemetry.humidity, 74);
      expect(model.telemetry.windSpeed, 14.0);
      expect(model.conditionText, 'Partly Cloudy');
    });

    test('HourlyForecastModel handles array correctly', () {
      final mockJson = {
        'hourly': {
          'time': ['2026-09-12T14:00:00', '2026-09-12T15:00:00'],
          'temperature_2m': [20.0, 21.1],
          'weather_code': [0, 1],
          'precipitation_probability': [0, 10],
        }
      };

      final items = HourlyForecastModel.fromOpenMeteoJson(mockJson);
      expect(items.isNotEmpty, true);
    });

    test('DailyForecastModel parses 7 days correctly', () {
      final mockJson = {
        'daily': {
          'time': ['2026-09-12', '2026-09-13'],
          'temperature_2m_max': [22.2, 21.1],
          'temperature_2m_min': [12.8, 12.2],
          'weather_code': [2, 0],
          'precipitation_sum': [0.2, 0.0],
          'precipitation_probability_max': [40, 10],
        }
      };

      final items = DailyForecastModel.fromOpenMeteoJson(mockJson);
      expect(items.length, 2);
      expect(items[0].tempMax, 22.2);
      expect(items[0].isToday, true);
    });
  });
}
