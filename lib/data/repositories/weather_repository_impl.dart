import '../../domain/repositories/weather_repository.dart';
import '../../domain/entities/weather_entity.dart';
import '../../domain/entities/hourly_forecast_entity.dart';
import '../../domain/entities/daily_forecast_entity.dart';
import '../../domain/entities/location_entity.dart';
import '../datasources/open_meteo_remote_data_source.dart';
import '../datasources/mock_weather_data_source.dart';
import '../datasources/local_storage_data_source.dart';
import '../models/location_model.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final OpenMeteoRemoteDataSource remoteDataSource;
  final LocalStorageDataSource localStorageDataSource;

  WeatherRepositoryImpl({
    OpenMeteoRemoteDataSource? remoteDataSource,
    LocalStorageDataSource? localStorageDataSource,
  })  : remoteDataSource = remoteDataSource ?? OpenMeteoRemoteDataSource(),
        localStorageDataSource = localStorageDataSource ?? LocalStorageDataSource();

  @override
  Future<WeatherEntity> getCurrentWeather({
    required double latitude,
    required double longitude,
    String? cityName,
    String? country,
  }) async {
    try {
      return await remoteDataSource.fetchCurrentWeather(
        latitude: latitude,
        longitude: longitude,
        cityName: cityName,
        country: country,
      );
    } catch (e) {
      // Graceful fallback to mock data with requested city name
      return MockWeatherDataSource.getMockCurrentWeather(cityName: cityName);
    }
  }

  @override
  Future<List<HourlyForecastEntity>> getHourlyForecast({
    required double latitude,
    required double longitude,
  }) async {
    try {
      return await remoteDataSource.fetchHourlyForecast(
        latitude: latitude,
        longitude: longitude,
      );
    } catch (_) {
      return MockWeatherDataSource.getMockHourlyForecast();
    }
  }

  @override
  Future<List<DailyForecastEntity>> getDailyForecast({
    required double latitude,
    required double longitude,
  }) async {
    try {
      return await remoteDataSource.fetchDailyForecast(
        latitude: latitude,
        longitude: longitude,
      );
    } catch (_) {
      return MockWeatherDataSource.getMockDailyForecast();
    }
  }

  @override
  Future<List<LocationEntity>> searchLocations(String query) async {
    try {
      return await remoteDataSource.searchLocations(query);
    } catch (_) {
      // Filter trending mock cities if offline
      return MockWeatherDataSource.getTrendingCities()
          .where((loc) => loc.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  @override
  Future<List<LocationEntity>> getSavedLocations() async {
    final saved = await localStorageDataSource.getSavedLocations();
    if (saved.isEmpty) {
      // Pre-seed with mock saved locations from Stitch design
      final initial = MockWeatherDataSource.getMockSavedLocations();
      await localStorageDataSource.saveLocations(initial);
      return initial;
    }
    return saved;
  }

  @override
  Future<void> saveLocation(LocationEntity location) async {
    final current = await localStorageDataSource.getSavedLocations();
    if (!current.any((l) => l.id == location.id)) {
      final updated = List<LocationModel>.from(current)
        ..add(LocationModel(
          id: location.id,
          name: location.name,
          country: location.country,
          admin1: location.admin1,
          latitude: location.latitude,
          longitude: location.longitude,
          currentTemp: location.currentTemp,
          tempMax: location.tempMax,
          tempMin: location.tempMin,
          conditionText: location.conditionText,
          localTime: location.localTime,
          isSaved: true,
        ));
      await localStorageDataSource.saveLocations(updated);
    }
  }

  @override
  Future<void> removeSavedLocation(int locationId) async {
    final current = await localStorageDataSource.getSavedLocations();
    final updated = current.where((l) => l.id != locationId).toList();
    await localStorageDataSource.saveLocations(updated);
  }
}
