import '../../domain/entities/weather_entity.dart';
import '../../domain/entities/hourly_forecast_entity.dart';
import '../../domain/entities/daily_forecast_entity.dart';
import '../../domain/entities/location_entity.dart';
import '../../core/utils/unit_converter.dart';

enum WeatherStatus { initial, loading, success, error }

class WeatherState {
  final WeatherStatus status;
  final WeatherEntity? currentWeather;
  final List<HourlyForecastEntity> hourlyForecast;
  final List<DailyForecastEntity> dailyForecast;
  final List<LocationEntity> searchResults;
  final List<LocationEntity> savedLocations;
  final LocationEntity currentLocation;
  final TemperatureUnit temperatureUnit;
  final String? errorMessage;
  final bool isSearching;
  final bool isGpsLoading;

  const WeatherState({
    this.status = WeatherStatus.initial,
    this.currentWeather,
    this.hourlyForecast = const [],
    this.dailyForecast = const [],
    this.searchResults = const [],
    this.savedLocations = const [],
    required this.currentLocation,
    this.temperatureUnit = TemperatureUnit.fahrenheit,
    this.errorMessage,
    this.isSearching = false,
    this.isGpsLoading = false,
  });

  WeatherState copyWith({
    WeatherStatus? status,
    WeatherEntity? currentWeather,
    List<HourlyForecastEntity>? hourlyForecast,
    List<DailyForecastEntity>? dailyForecast,
    List<LocationEntity>? searchResults,
    List<LocationEntity>? savedLocations,
    LocationEntity? currentLocation,
    TemperatureUnit? temperatureUnit,
    String? errorMessage,
    bool? isSearching,
    bool? isGpsLoading,
  }) {
    return WeatherState(
      status: status ?? this.status,
      currentWeather: currentWeather ?? this.currentWeather,
      hourlyForecast: hourlyForecast ?? this.hourlyForecast,
      dailyForecast: dailyForecast ?? this.dailyForecast,
      searchResults: searchResults ?? this.searchResults,
      savedLocations: savedLocations ?? this.savedLocations,
      currentLocation: currentLocation ?? this.currentLocation,
      temperatureUnit: temperatureUnit ?? this.temperatureUnit,
      errorMessage: errorMessage ?? this.errorMessage,
      isSearching: isSearching ?? this.isSearching,
      isGpsLoading: isGpsLoading ?? this.isGpsLoading,
    );
  }
}
