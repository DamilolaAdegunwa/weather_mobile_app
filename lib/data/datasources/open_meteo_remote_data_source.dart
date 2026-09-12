import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../models/weather_model.dart';
import '../models/hourly_forecast_model.dart';
import '../models/daily_forecast_model.dart';
import '../models/location_model.dart';

class OpenMeteoRemoteDataSource {
  final http.Client client;

  OpenMeteoRemoteDataSource({http.Client? client}) : client = client ?? http.Client();

  Future<WeatherModel> fetchCurrentWeather({
    required double latitude,
    required double longitude,
    String? cityName,
    String? country,
    String? neighborhood,
  }) async {
    final forecastUrl = Uri.parse(
      '${ApiConstants.openMeteoForecastBaseUrl}?'
      'latitude=$latitude&longitude=$longitude'
      '&current=temperature_2m,relative_humidity_2m,apparent_temperature,is_day,precipitation,weather_code,wind_speed_10m,wind_direction_10m,wind_gusts_10m,surface_pressure'
      '&daily=weather_code,temperature_2m_max,temperature_2m_min,sunrise,sunset,precipitation_sum,precipitation_probability_max,uv_index_max'
      '&wind_speed_unit=mph'
      '&precipitation_unit=inch'
      '&timezone=auto',
    );

    final airQualityUrl = Uri.parse(
      '${ApiConstants.openMeteoAirQualityBaseUrl}?'
      'latitude=$latitude&longitude=$longitude'
      '&current=us_aqi,pm2_5'
      '&timezone=auto',
    );

    final forecastResponse = await client.get(forecastUrl).timeout(const Duration(seconds: 10));
    if (forecastResponse.statusCode != 200) {
      throw Exception('Failed to load forecast data: ${forecastResponse.statusCode}');
    }

    final forecastJson = jsonDecode(forecastResponse.body) as Map<String, dynamic>;

    Map<String, dynamic>? airQualityJson;
    try {
      final airResponse = await client.get(airQualityUrl).timeout(const Duration(seconds: 5));
      if (airResponse.statusCode == 200) {
        airQualityJson = jsonDecode(airResponse.body) as Map<String, dynamic>;
      }
    } catch (_) {
      // Gracefully continue without air quality if endpoint fails
    }

    return WeatherModel.fromOpenMeteoJson(
      forecastJson: forecastJson,
      airQualityJson: airQualityJson,
      cityName: cityName,
      country: country,
      neighborhood: neighborhood,
    );
  }

  Future<List<HourlyForecastModel>> fetchHourlyForecast({
    required double latitude,
    required double longitude,
  }) async {
    final url = Uri.parse(
      '${ApiConstants.openMeteoForecastBaseUrl}?'
      'latitude=$latitude&longitude=$longitude'
      '&hourly=temperature_2m,precipitation_probability,weather_code'
      '&forecast_days=2'
      '&timezone=auto',
    );

    final response = await client.get(url).timeout(const Duration(seconds: 10));
    if (response.statusCode != 200) {
      throw Exception('Failed to load hourly forecast: ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return HourlyForecastModel.fromOpenMeteoJson(json);
  }

  Future<List<DailyForecastModel>> fetchDailyForecast({
    required double latitude,
    required double longitude,
  }) async {
    final url = Uri.parse(
      '${ApiConstants.openMeteoForecastBaseUrl}?'
      'latitude=$latitude&longitude=$longitude'
      '&daily=weather_code,temperature_2m_max,temperature_2m_min,precipitation_sum,precipitation_probability_max'
      '&forecast_days=7'
      '&timezone=auto',
    );

    final response = await client.get(url).timeout(const Duration(seconds: 10));
    if (response.statusCode != 200) {
      throw Exception('Failed to load 7-day forecast: ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return DailyForecastModel.fromOpenMeteoJson(json);
  }

  Future<List<LocationModel>> searchLocations(String query) async {
    if (query.trim().isEmpty) return [];

    final url = Uri.parse(
      '${ApiConstants.openMeteoGeocodingBaseUrl}?'
      'name=${Uri.encodeComponent(query)}&count=10&language=en&format=json',
    );

    final response = await client.get(url).timeout(const Duration(seconds: 10));
    if (response.statusCode != 200) {
      throw Exception('Geocoding search failed: ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final results = json['results'] as List<dynamic>? ?? [];

    return results.map((item) => LocationModel.fromGeocodingJson(item as Map<String, dynamic>)).toList();
  }
}
