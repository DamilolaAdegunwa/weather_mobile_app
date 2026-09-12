import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app.dart';
import 'data/repositories/weather_repository_impl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Enforce edge-to-edge transparent system overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Initialize clean architecture repository
  final weatherRepository = WeatherRepositoryImpl();

  runApp(AetherWeatherApp(weatherRepository: weatherRepository));
}
