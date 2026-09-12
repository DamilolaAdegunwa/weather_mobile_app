import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/widgets/atmospheric_background.dart';
import '../../core/widgets/app_bar_header.dart';
import '../state/weather_notifier.dart';
import 'today_forecast_screen.dart';
import 'seven_day_forecast_screen.dart';
import 'location_search_screen.dart';
import 'radar_screen.dart';

class HomeShellScreen extends StatefulWidget {
  const HomeShellScreen({super.key});

  @override
  State<HomeShellScreen> createState() => _HomeShellScreenState();
}

class _HomeShellScreenState extends State<HomeShellScreen> {
  int _currentIndex = 0;

  String _getSubtitle() {
    switch (_currentIndex) {
      case 0:
        return 'Today Forecast';
      case 1:
        return 'Doppler Radar';
      case 2:
        return 'Seven Day Outlook';
      case 3:
        return 'Saved Locations';
      default:
        return 'Weather';
    }
  }

  @override
  Widget build(BuildContext context) {
    final weatherState = context.watch<WeatherNotifier>().state;
    final cityName = weatherState.currentWeather?.cityName ?? 'San Francisco';

    final screens = [
      TodayForecastScreen(
        onOpenRadar: () {
          setState(() {
            _currentIndex = 1;
          });
        },
      ),
      const RadarScreen(),
      const SevenDayForecastScreen(),
      LocationSearchScreen(
        onLocationSelected: () {
          setState(() {
            _currentIndex = 0;
          });
        },
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: AtmosphericBackground(
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              // Screen Content
              Column(
                children: [
                  // App Bar Header (Only when not on search tab or can remain sticky)
                  AppBarHeader(
                    subtitle: _getSubtitle(),
                    currentCity: cityName,
                    onLocationTap: () {
                      setState(() {
                        _currentIndex = 3;
                      });
                    },
                  ),
                  Expanded(
                    child: IndexedStack(
                      index: _currentIndex,
                      children: screens,
                    ),
                  ),
                ],
              ),

              // Glassmorphic Fixed Bottom Navigation Bar
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildBottomNavigationBar(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest.withOpacity(0.85),
            border: const Border(
              top: BorderSide(color: Color(0x14FFFFFF), width: 1.0),
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 24,
                offset: Offset(0, -4),
              ),
            ],
          ),
          padding: EdgeInsets.only(
            top: 10,
            bottom: MediaQuery.of(context).padding.bottom + 8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.wb_sunny_rounded, 'Today'),
              _buildNavItem(1, Icons.radar_rounded, 'Radar'),
              _buildNavItem(2, Icons.calendar_view_week_rounded, '7-Day'),
              _buildNavItem(3, Icons.bookmark_border_rounded, 'Saved'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isActive = _currentIndex == index;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: isActive ? AppColors.primary : AppColors.onSurfaceVariant,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTypography.labelSm.copyWith(
                fontSize: 11,
                color: isActive ? AppColors.primary : AppColors.onSurfaceVariant,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
