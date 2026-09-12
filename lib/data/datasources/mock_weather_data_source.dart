import '../models/weather_model.dart';
import '../models/hourly_forecast_model.dart';
import '../models/daily_forecast_model.dart';
import '../models/location_model.dart';
import '../../domain/entities/weather_entity.dart';

class MockWeatherDataSource {
  MockWeatherDataSource._();

  static WeatherModel getMockCurrentWeather({String? cityName}) {
    final city = cityName ?? 'San Francisco';
    final isSF = city.toLowerCase().contains('francisco');

    return WeatherModel(
      cityName: city,
      neighborhood: isSF ? 'Financial District' : 'Central District',
      country: isSF ? 'United States' : 'Global',
      temperature: 20.0, // 68°F
      apparentTemperature: 18.9, // 66°F
      tempMax: 22.2, // 72°F
      tempMin: 12.8, // 55°F
      weatherCode: 2, // Partly Cloudy
      isDay: true,
      conditionText: 'Partly Cloudy',
      microTag: 'Crisp coastal breeze from the bay',
      telemetry: const TelemetryEntity(
        windSpeed: 14.0,
        windDirection: 'WSW',
        windDirectionDegrees: 247.5,
        windGust: 21.0,
        humidity: 74,
        dewPoint: 14.4, // 58°F
        uvIndex: 4.0,
        uvCategory: 'Moderate',
        aqi: 38,
        aqiStatus: 'Good',
        sunrise: '2026-09-12T06:42:00',
        sunset: '2026-09-12T19:58:00',
        solarProgress: 0.65,
      ),
    );
  }

  static List<HourlyForecastModel> getMockHourlyForecast() {
    return const [
      HourlyForecastModel(
        time: '2026-09-12T14:00:00',
        temperature: 20.0, // 68°F
        weatherCode: 0,
        precipitationProbability: 0,
        isNow: true,
      ),
      HourlyForecastModel(
        time: '2026-09-12T15:00:00',
        temperature: 21.1, // 70°F
        weatherCode: 0,
        precipitationProbability: 0,
      ),
      HourlyForecastModel(
        time: '2026-09-12T16:00:00',
        temperature: 21.7, // 71°F
        weatherCode: 2,
        precipitationProbability: 10,
      ),
      HourlyForecastModel(
        time: '2026-09-12T17:00:00',
        temperature: 20.6, // 69°F
        weatherCode: 3,
        precipitationProbability: 20,
      ),
      HourlyForecastModel(
        time: '2026-09-12T18:00:00',
        temperature: 19.4, // 67°F
        weatherCode: 61,
        precipitationProbability: 40,
      ),
      HourlyForecastModel(
        time: '2026-09-12T19:00:00',
        temperature: 18.3, // 65°F
        weatherCode: 63,
        precipitationProbability: 60,
      ),
      HourlyForecastModel(
        time: '2026-09-12T20:00:00',
        temperature: 17.2, // 63°F
        weatherCode: 65,
        precipitationProbability: 85,
      ),
      HourlyForecastModel(
        time: '2026-09-12T21:00:00',
        temperature: 16.1, // 61°F
        weatherCode: 0,
        precipitationProbability: 0,
      ),
    ];
  }

  static List<DailyForecastModel> getMockDailyForecast() {
    return const [
      DailyForecastModel(
        date: '2026-09-12',
        dayLabel: 'Today',
        weatherCode: 2,
        conditionDescription: 'Partly Cloudy',
        tempMax: 22.2, // 72°F
        tempMin: 12.8, // 55°F
        precipitationProbability: 40,
        precipitationSum: 0.2,
        isToday: true,
      ),
      DailyForecastModel(
        date: '2026-09-13',
        dayLabel: 'Tue, 24',
        weatherCode: 0,
        conditionDescription: 'Mostly Sunny',
        tempMax: 21.1, // 70°F
        tempMin: 12.2, // 54°F
        precipitationProbability: 10,
        precipitationSum: 0.0,
      ),
      DailyForecastModel(
        date: '2026-09-14',
        dayLabel: 'Wed, 25',
        weatherCode: 61,
        conditionDescription: 'Scattered Showers',
        tempMax: 17.8, // 64°F
        tempMin: 11.1, // 52°F
        precipitationProbability: 75,
        precipitationSum: 0.5,
      ),
      DailyForecastModel(
        date: '2026-09-15',
        dayLabel: 'Thu, 26',
        weatherCode: 95,
        conditionDescription: 'Rain & Wind',
        tempMax: 16.1, // 61°F
        tempMin: 10.0, // 50°F
        precipitationProbability: 85,
        precipitationSum: 0.7,
      ),
      DailyForecastModel(
        date: '2026-09-16',
        dayLabel: 'Fri, 27',
        weatherCode: 2,
        conditionDescription: 'Clearing Up',
        tempMax: 18.9, // 66°F
        tempMin: 11.7, // 53°F
        precipitationProbability: 20,
        precipitationSum: 0.0,
      ),
      DailyForecastModel(
        date: '2026-09-17',
        dayLabel: 'Sat, 28',
        weatherCode: 0,
        conditionDescription: 'Sunny & Mild',
        tempMax: 22.8, // 73°F
        tempMin: 13.3, // 56°F
        precipitationProbability: 5,
        precipitationSum: 0.0,
      ),
      DailyForecastModel(
        date: '2026-09-18',
        dayLabel: 'Sun, 29',
        weatherCode: 0,
        conditionDescription: 'Golden Sunshine',
        tempMax: 23.9, // 75°F
        tempMin: 13.9, // 57°F
        precipitationProbability: 0,
        precipitationSum: 0.0,
      ),
    ];
  }

  static List<LocationModel> getMockSavedLocations() {
    return const [
      LocationModel(
        id: 1,
        name: 'San Francisco',
        country: 'United States',
        latitude: 37.7749,
        longitude: -122.4194,
        currentTemp: 20.0,
        tempMax: 22.2,
        tempMin: 12.8,
        conditionText: 'Partly Cloudy',
        localTime: '2:45 PM',
        isSaved: true,
      ),
      LocationModel(
        id: 2,
        name: 'Tokyo',
        country: 'Japan',
        latitude: 35.6762,
        longitude: 139.6503,
        currentTemp: 18.9,
        tempMax: 21.7,
        tempMin: 13.9,
        conditionText: 'Clear Night',
        localTime: 'Tomorrow, 6:45 AM',
        isSaved: true,
      ),
      LocationModel(
        id: 3,
        name: 'London',
        country: 'United Kingdom',
        latitude: 51.5074,
        longitude: -0.1278,
        currentTemp: 13.9,
        tempMax: 15.6,
        tempMin: 11.1,
        conditionText: 'Drizzle',
        localTime: '10:45 PM',
        isSaved: true,
      ),
      LocationModel(
        id: 4,
        name: 'New York',
        country: 'United States',
        latitude: 40.7128,
        longitude: -74.0060,
        currentTemp: 23.3,
        tempMax: 24.4,
        tempMin: 16.7,
        conditionText: 'Sunny',
        localTime: '5:45 PM',
        isSaved: true,
      ),
    ];
  }

  static List<LocationModel> getTrendingCities() {
    return const [
      LocationModel(
        id: 101,
        name: 'Paris',
        country: 'France',
        latitude: 48.8566,
        longitude: 2.3522,
        currentTemp: 18.0,
        conditionText: 'Mostly Clear',
      ),
      LocationModel(
        id: 102,
        name: 'Reykjavik',
        country: 'Iceland',
        latitude: 64.1466,
        longitude: -21.9426,
        currentTemp: 4.0,
        conditionText: 'Chilly',
      ),
      LocationModel(
        id: 103,
        name: 'Sydney',
        country: 'Australia',
        latitude: -33.8688,
        longitude: 151.2093,
        currentTemp: 22.0,
        conditionText: 'Sunny',
      ),
      LocationModel(
        id: 104,
        name: 'Dubai',
        country: 'United Arab Emirates',
        latitude: 25.2048,
        longitude: 55.2708,
        currentTemp: 34.0,
        conditionText: 'Clear Sky',
      ),
      LocationModel(
        id: 105,
        name: 'Vancouver',
        country: 'Canada',
        latitude: 49.2827,
        longitude: -123.1207,
        currentTemp: 15.0,
        conditionText: 'Cloudy',
      ),
    ];
  }
}
