import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/widgets/glass_container.dart';
import '../../core/utils/unit_converter.dart';
import '../../domain/entities/location_entity.dart';
import '../../data/datasources/mock_weather_data_source.dart';
import '../state/weather_notifier.dart';
import '../state/weather_state.dart';
import '../widgets/saved_city_card.dart';

class LocationSearchScreen extends StatefulWidget {
  final VoidCallback onLocationSelected;

  const LocationSearchScreen({super.key, required this.onLocationSelected});

  @override
  State<LocationSearchScreen> createState() => _LocationSearchScreenState();
}

class _LocationSearchScreenState extends State<LocationSearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final weatherNotifier = context.watch<WeatherNotifier>();
    final state = weatherNotifier.state;
    final trendingCities = MockWeatherDataSource.getTrendingCities();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
      children: [
        // 1. Search Bar with Clear & Voice buttons
        _buildSearchBar(weatherNotifier),

        const SizedBox(height: 16),

        // 2. Quick Toolstrip: Current Location GPS, °C/°F Toggle, Ambiance Button
        _buildQuickToolstrip(weatherNotifier, state),

        const SizedBox(height: 24),

        // 3. Search Results Overlay or Default Saved Cities & Trending
        if (state.isSearching) ...[
          const Center(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: CircularProgressIndicator(color: AppColors.secondary),
            ),
          ),
        ] else if (state.searchResults.isNotEmpty) ...[
          _buildSearchResults(weatherNotifier, state.searchResults),
        ] else ...[
          // Popular & Trending Horizontal Carousel
          _buildTrendingCarousel(weatherNotifier, trendingCities, state.temperatureUnit),

          const SizedBox(height: 24),

          // Saved Locations Header
          _buildSavedHeader(state.savedLocations.length),

          const SizedBox(height: 12),

          // Saved Cities Stack (Dismissible)
          if (state.savedLocations.isEmpty)
            _buildEmptySavedState()
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.savedLocations.length,
              itemBuilder: (context, index) {
                final location = state.savedLocations[index];
                return SavedCityCard(
                  location: location,
                  unit: state.temperatureUnit,
                  onTap: () {
                    weatherNotifier.selectLocation(location);
                    widget.onLocationSelected();
                  },
                  onDismissed: () {
                    weatherNotifier.removeSavedLocation(location.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${location.name} removed from saved places.'),
                        duration: const Duration(seconds: 2),
                        backgroundColor: AppColors.surfaceContainerHigh,
                      ),
                    );
                  },
                );
              },
            ),

          const SizedBox(height: 20),

          // Discovery Card Anchor
          _buildDiscoveryCard(),
        ],
      ],
    );
  }

  Widget _buildSearchBar(WeatherNotifier notifier) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(999),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        style: AppTypography.bodyMd.copyWith(color: AppColors.onSurface),
        decoration: InputDecoration(
          hintText: 'Search city or airport...',
          hintStyle: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
          prefixIcon: const Icon(Icons.search, color: AppColors.primary, size: 22),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_searchController.text.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.cancel, color: AppColors.onSurfaceVariant, size: 18),
                  onPressed: () {
                    _searchController.clear();
                    notifier.onSearchQueryChanged('');
                    setState(() {});
                  },
                ),
              const Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Icon(Icons.mic, color: AppColors.primary, size: 20),
              ),
            ],
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        ),
        onChanged: (val) {
          notifier.onSearchQueryChanged(val);
          setState(() {});
        },
      ),
    );
  }

  Widget _buildQuickToolstrip(WeatherNotifier notifier, WeatherState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Current Location GPS Button
        ElevatedButton.icon(
          onPressed: state.isGpsLoading ? null : () => notifier.fetchGpsLocation(),
          icon: state.isGpsLoading
              ? const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                )
              : const Icon(Icons.near_me, size: 16, color: AppColors.primary),
          label: Text(
            state.isGpsLoading ? 'Detecting...' : 'Current Location',
            style: AppTypography.labelMd.copyWith(color: AppColors.primary),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.surfaceContainer,
            elevation: 0,
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          ),
        ),

        Row(
          children: [
            // Temperature Unit Segmented Switcher (°C / °F)
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => notifier.setTemperatureUnit(TemperatureUnit.celsius),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: state.temperatureUnit == TemperatureUnit.celsius
                            ? AppColors.primary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '°C',
                        style: AppTypography.labelMd.copyWith(
                          color: state.temperatureUnit == TemperatureUnit.celsius
                              ? AppColors.onPrimary
                              : AppColors.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => notifier.setTemperatureUnit(TemperatureUnit.fahrenheit),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: state.temperatureUnit == TemperatureUnit.fahrenheit
                            ? AppColors.primary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '°F',
                        style: AppTypography.labelMd.copyWith(
                          color: state.temperatureUnit == TemperatureUnit.fahrenheit
                              ? AppColors.onPrimary
                              : AppColors.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Ambiance preview icon
            Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                color: AppColors.surfaceContainer,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.brightness_medium, size: 18, color: AppColors.onSurfaceVariant),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTrendingCarousel(WeatherNotifier notifier, List<LocationEntity> cities, TemperatureUnit unit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('TRENDING CITIES', style: AppTypography.labelSm.copyWith(color: AppColors.onSurfaceVariant, letterSpacing: 1.0)),
            const Icon(Icons.auto_awesome, color: AppColors.primary, size: 16),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 38,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: cities.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final city = cities[index];
              return InkWell(
                onTap: () {
                  notifier.selectLocation(city);
                  widget.onLocationSelected();
                },
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: AppColors.glassBorderLight, width: 0.6),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: index == 0 ? AppColors.secondary : AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(city.name, style: AppTypography.labelMd.copyWith(color: AppColors.onSurface)),
                      const SizedBox(width: 6),
                      Text(
                        UnitConverter.formatTemperature(city.currentTemp ?? 20.0, unit),
                        style: AppTypography.labelSm.copyWith(color: AppColors.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSavedHeader(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text('Saved Locations', style: AppTypography.headlineSm),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text('$count', style: AppTypography.labelSm.copyWith(color: AppColors.onSurfaceVariant)),
            ),
          ],
        ),
        Row(
          children: [
            const Icon(Icons.swipe, color: AppColors.onSurfaceVariant, size: 14),
            const SizedBox(width: 4),
            Text('Swipe to manage', style: AppTypography.labelSm.copyWith(color: AppColors.onSurfaceVariant)),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchResults(WeatherNotifier notifier, List<LocationEntity> results) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('SEARCH RESULTS', style: AppTypography.labelSm.copyWith(color: AppColors.secondary, letterSpacing: 1.0)),
        const SizedBox(height: 8),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: results.length,
          separatorBuilder: (_, __) => const Divider(color: Color(0x14FFFFFF), height: 1),
          itemBuilder: (context, index) {
            final loc = results[index];
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              leading: const Icon(Icons.location_on_outlined, color: AppColors.primary),
              title: Text(loc.name, style: AppTypography.bodyMd.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.w600)),
              subtitle: Text(
                '${loc.admin1 != null ? "${loc.admin1}, " : ""}${loc.country}',
                style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.bookmark_add_outlined, color: AppColors.secondary),
                onPressed: () {
                  notifier.addSavedLocation(loc);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${loc.name} added to saved places.'),
                      duration: const Duration(seconds: 2),
                      backgroundColor: AppColors.surfaceContainerHigh,
                    ),
                  );
                },
              ),
              onTap: () {
                notifier.selectLocation(loc);
                widget.onLocationSelected();
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildEmptySavedState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Center(
        child: Text(
          'No saved locations yet.\nSearch and bookmark cities above.',
          textAlign: TextAlign.center,
          style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
        ),
      ),
    );
  }

  Widget _buildDiscoveryCard() {
    return GlassContainer(
      padding: const EdgeInsets.all(20),
      borderRadius: BorderRadius.circular(24),
      backgroundColor: AppColors.surfaceContainer.withOpacity(0.4),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.explore, color: AppColors.primary, size: 24),
          ),
          const SizedBox(height: 10),
          Text('Discover More Places', style: AppTypography.headlineSm.copyWith(fontSize: 18)),
          const SizedBox(height: 6),
          Text(
            'Track up to 20 cities simultaneously with high-fidelity live radar and atmospheric telemetry.',
            textAlign: TextAlign.center,
            style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
