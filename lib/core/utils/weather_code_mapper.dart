import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class WeatherConditionInfo {
  final String description;
  final IconData icon;
  final Color accentColor;
  final String microTag;

  const WeatherConditionInfo({
    required this.description,
    required this.icon,
    required this.accentColor,
    required this.microTag,
  });
}

class WeatherCodeMapper {
  WeatherCodeMapper._();

  static WeatherConditionInfo map(int? code, {bool isDay = true}) {
    if (code == null) {
      return WeatherConditionInfo(
        description: 'Clear',
        icon: isDay ? Icons.wb_sunny_rounded : Icons.nights_stay_rounded,
        accentColor: AppColors.secondary,
        microTag: 'Crisp atmospheric conditions',
      );
    }

    switch (code) {
      case 0:
        return WeatherConditionInfo(
          description: isDay ? 'Sunny' : 'Clear Night',
          icon: isDay ? Icons.wb_sunny_rounded : Icons.nights_stay_rounded,
          accentColor: isDay ? const Color(0xFFFBBF24) : AppColors.tertiary,
          microTag: isDay ? 'Radiant sky with optimal visibility' : 'Clear celestial sky and calm air',
        );
      case 1:
      case 2:
        return WeatherConditionInfo(
          description: 'Partly Cloudy',
          icon: isDay ? Icons.cloud_queue_rounded : Icons.nights_stay_outlined,
          accentColor: AppColors.secondary,
          microTag: 'Crisp coastal breeze with intermittent sun',
        );
      case 3:
        return WeatherConditionInfo(
          description: 'Overcast',
          icon: Icons.cloud_rounded,
          accentColor: AppColors.onSurfaceVariant,
          microTag: 'Dense cloud ceiling across the area',
        );
      case 45:
      case 48:
        return WeatherConditionInfo(
          description: 'Foggy',
          icon: Icons.blur_on_rounded,
          accentColor: AppColors.primary,
          microTag: 'Thick low-altitude fog layer',
        );
      case 51:
      case 53:
      case 55:
        return WeatherConditionInfo(
          description: 'Drizzle',
          icon: Icons.grain_rounded,
          accentColor: AppColors.secondary,
          microTag: 'Gentle mist and ambient drizzle',
        );
      case 61:
      case 63:
        return WeatherConditionInfo(
          description: 'Scattered Showers',
          icon: Icons.water_drop_rounded,
          accentColor: AppColors.secondary,
          microTag: 'Intermittent precipitation cells',
        );
      case 65:
        return WeatherConditionInfo(
          description: 'Heavy Rain',
          icon: Icons.umbrella_rounded,
          accentColor: AppColors.primaryContainer,
          microTag: 'Substantial downpour and wet roads',
        );
      case 71:
      case 73:
      case 75:
        return WeatherConditionInfo(
          description: 'Snowfall',
          icon: Icons.ac_unit_rounded,
          accentColor: AppColors.primary,
          microTag: 'Crisp snowfall with freezing surface temps',
        );
      case 80:
      case 81:
      case 82:
        return WeatherConditionInfo(
          description: 'Passing Showers',
          icon: Icons.shower_rounded,
          accentColor: AppColors.secondary,
          microTag: 'Showers sweeping through the region',
        );
      case 95:
      case 96:
      case 99:
        return WeatherConditionInfo(
          description: 'Thunderstorm',
          icon: Icons.thunderstorm_rounded,
          accentColor: AppColors.tertiaryContainer,
          microTag: 'Active lightning activity and localized gusts',
        );
      default:
        return WeatherConditionInfo(
          description: 'Fair',
          icon: Icons.wb_cloudy_rounded,
          accentColor: AppColors.secondary,
          microTag: 'Balanced tropospheric readings',
        );
    }
  }
}
