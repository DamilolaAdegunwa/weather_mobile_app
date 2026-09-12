import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'domain/repositories/weather_repository.dart';
import 'presentation/state/weather_notifier.dart';
import 'presentation/screens/home_shell_screen.dart';

class AetherWeatherApp extends StatelessWidget {
  final WeatherRepository weatherRepository;

  const AetherWeatherApp({super.key, required this.weatherRepository});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WeatherNotifier(repository: weatherRepository),
      child: MaterialApp(
        title: 'Aether Weather',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const HomeShellScreen(),
      ),
    );
  }
}
