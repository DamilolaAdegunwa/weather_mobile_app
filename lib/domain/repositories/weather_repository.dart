import '../entities/weather_entity.dart';
import '../entities/hourly_forecast_entity.dart';
import '../entities/daily_forecast_entity.dart';
import '../entities/location_entity.dart';

abstract class WeatherRepository {
  Future<WeatherEntity> getCurrentWeather({
    required double latitude,
    required double longitude,
    String? cityName,
    String? country,
  });

  Future<List<HourlyForecastEntity>> getHourlyForecast({
    required double latitude,
    required double longitude,
  });

  Future<List<DailyForecastEntity>> getDailyForecast({
    required double latitude,
    required double longitude,
  });

  Future<List<LocationEntity>> searchLocations(String query);

  Future<List<LocationEntity>> getSavedLocations();

  Future<void> saveLocation(LocationEntity location);

  Future<void> removeSavedLocation(int locationId);
}
