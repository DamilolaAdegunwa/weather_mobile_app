import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../domain/repositories/weather_repository.dart';
import '../../domain/entities/location_entity.dart';
import '../../core/utils/unit_converter.dart';
import '../../core/constants/api_constants.dart';
import 'weather_state.dart';

class WeatherNotifier extends ChangeNotifier {
  final WeatherRepository repository;
  WeatherState _state;
  Timer? _searchDebounceTimer;

  WeatherNotifier({required this.repository})
      : _state = const WeatherState(
          currentLocation: LocationEntity(
            id: 1,
            name: ApiConstants.defaultCityName,
            country: ApiConstants.defaultCountryName,
            latitude: ApiConstants.defaultLatitude,
            longitude: ApiConstants.defaultLongitude,
            isSaved: true,
          ),
        ) {
    loadInitialData();
  }

  WeatherState get state => _state;

  Future<void> loadInitialData() async {
    _state = _state.copyWith(status: WeatherStatus.loading);
    notifyListeners();

    try {
      final saved = await repository.getSavedLocations();
      final currentLoc = _state.currentLocation;

      final weather = await repository.getCurrentWeather(
        latitude: currentLoc.latitude,
        longitude: currentLoc.longitude,
        cityName: currentLoc.name,
        country: currentLoc.country,
      );

      final hourly = await repository.getHourlyForecast(
        latitude: currentLoc.latitude,
        longitude: currentLoc.longitude,
      );

      final daily = await repository.getDailyForecast(
        latitude: currentLoc.latitude,
        longitude: currentLoc.longitude,
      );

      _state = _state.copyWith(
        status: WeatherStatus.success,
        currentWeather: weather,
        hourlyForecast: hourly,
        dailyForecast: daily,
        savedLocations: saved,
      );
    } catch (e) {
      _state = _state.copyWith(
        status: WeatherStatus.error,
        errorMessage: 'Unable to load atmospheric telemetry: $e',
      );
    }
    notifyListeners();
  }

  Future<void> refresh() async {
    final currentLoc = _state.currentLocation;
    try {
      final weather = await repository.getCurrentWeather(
        latitude: currentLoc.latitude,
        longitude: currentLoc.longitude,
        cityName: currentLoc.name,
        country: currentLoc.country,
      );

      final hourly = await repository.getHourlyForecast(
        latitude: currentLoc.latitude,
        longitude: currentLoc.longitude,
      );

      final daily = await repository.getDailyForecast(
        latitude: currentLoc.latitude,
        longitude: currentLoc.longitude,
      );

      _state = _state.copyWith(
        status: WeatherStatus.success,
        currentWeather: weather,
        hourlyForecast: hourly,
        dailyForecast: daily,
      );
    } catch (e) {
      // Keep existing data on refresh failure
    }
    notifyListeners();
  }

  Future<void> selectLocation(LocationEntity location) async {
    _state = _state.copyWith(
      status: WeatherStatus.loading,
      currentLocation: location,
      searchResults: [],
    );
    notifyListeners();

    try {
      final weather = await repository.getCurrentWeather(
        latitude: location.latitude,
        longitude: location.longitude,
        cityName: location.name,
        country: location.country,
      );

      final hourly = await repository.getHourlyForecast(
        latitude: location.latitude,
        longitude: location.longitude,
      );

      final daily = await repository.getDailyForecast(
        latitude: location.latitude,
        longitude: location.longitude,
      );

      _state = _state.copyWith(
        status: WeatherStatus.success,
        currentWeather: weather,
        hourlyForecast: hourly,
        dailyForecast: daily,
      );
    } catch (e) {
      _state = _state.copyWith(
        status: WeatherStatus.error,
        errorMessage: 'Failed to fetch weather for ${location.name}: $e',
      );
    }
    notifyListeners();
  }

  Future<void> fetchGpsLocation() async {
    _state = _state.copyWith(isGpsLoading: true);
    notifyListeners();

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied.');
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 8),
      );

      final gpsLocation = LocationEntity(
        id: DateTime.now().millisecondsSinceEpoch,
        name: 'Current Location',
        country: 'GPS Detected',
        latitude: position.latitude,
        longitude: position.longitude,
      );

      _state = _state.copyWith(isGpsLoading: false);
      await selectLocation(gpsLocation);
    } catch (e) {
      _state = _state.copyWith(
        isGpsLoading: false,
        errorMessage: 'GPS detection: $e. Using default location.',
      );
      notifyListeners();
    }
  }

  void onSearchQueryChanged(String query) {
    _searchDebounceTimer?.cancel();
    if (query.trim().isEmpty) {
      _state = _state.copyWith(searchResults: [], isSearching: false);
      notifyListeners();
      return;
    }

    _state = _state.copyWith(isSearching: true);
    notifyListeners();

    _searchDebounceTimer = Timer(const Duration(milliseconds: 400), () async {
      try {
        final results = await repository.searchLocations(query);
        _state = _state.copyWith(
          searchResults: results,
          isSearching: false,
        );
      } catch (e) {
        _state = _state.copyWith(isSearching: false);
      }
      notifyListeners();
    });
  }

  void setTemperatureUnit(TemperatureUnit unit) {
    _state = _state.copyWith(temperatureUnit: unit);
    notifyListeners();
  }

  Future<void> removeSavedLocation(int locationId) async {
    await repository.removeSavedLocation(locationId);
    final updatedList = _state.savedLocations.where((l) => l.id != locationId).toList();
    _state = _state.copyWith(savedLocations: updatedList);
    notifyListeners();
  }

  Future<void> addSavedLocation(LocationEntity location) async {
    await repository.saveLocation(location);
    final saved = await repository.getSavedLocations();
    _state = _state.copyWith(savedLocations: saved);
    notifyListeners();
  }

  @override
  void dispose() {
    _searchDebounceTimer?.cancel();
    super.dispose();
  }
}
