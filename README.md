# Aether - Atmospheric Glass Weather Forecast App 🌦️

A production-quality Flutter mobile application implementing the **Stitch Atmospheric Glass Weather** design system, powered by the **Open-Meteo API** (with GPS location detection and geocoding search), Clean Architecture, and responsive Flutter widgets.

---

## 📱 Features

- **Atmospheric Glassmorphism Design**: Frosted glass panels (`BackdropFilter` 20px blur), deep midnight gradients (`#0B1326` to `#0A0F1D`), ambient cyan/indigo backlighting, and pill-shaped capsule ergonomics.
- **Living Hero Backdrop**: Dynamic atmospheric gradient aura with active location chip, hero temperature display (with lightweight degree symbol), high/low/feels-like temperatures, and ambient condition badges.
- **24-Hour Scrollable Outlook**: Horizontal capsule stream featuring current active hour glow, weather icons, hourly temperatures, and precipitation probability badges.
- **Environmental Telemetry (2x2 Bento Matrix)**:
  - **Wind**: Live speed (mph), wind direction label, interactive tactile compass dial needle, and peak gusts readout.
  - **Humidity**: Relative humidity percentage, dew point calculation, and dual-tone gradient progress rail.
  - **UV Index**: Live UV index, qualitative category (Low/Moderate/High/Very High), and multi-spectrum gradient rail with position pin marker.
  - **Air Quality**: AQI reading, category status (Good/Moderate/Unhealthy), and glowing status pulse.
- **Solar Horizon Arc**: Parabolic solar trajectory custom painter with dashed baseline horizon, traveled solar segment gradient, sunrise/sunset times, and animated celestial marker.
- **7-Day Forecast View**:
  - Outlook summary and weekly average banner.
  - Expandable daily cards with day labels, condition descriptions, precipitation probability, and horizontal gradient temperature range bars with current-temperature pip indicator.
- **Weekly Precipitation Probability Bar Chart**:
  - 7 animated daily rainfall bars with percentages, total rainfall summation, and glowing high-probability indicators.
- **Doppler Radar Map**:
  - Interactive simulated Doppler radar view with radar station telemetry, composite sweep scanner, time scrubber, and precipitation severity legend.
- **Location Search & Management**:
  - Live search with Open-Meteo Geocoding API.
  - One-tap GPS Auto-Detect via `geolocator`.
  - Dynamic temperature unit switcher (°C / °F) with instant conversion across all views.
  - Trending cities carousel (Paris, Reykjavik, Sydney, Dubai, Vancouver).
  - Saved locations with Dismissible swipe-to-delete cards and red delete triggers.
- **Offline & Mock Resilience**:
  - Complete mock fallback data matching the Stitch design specifications when offline or in airplane mode.

---

## 🏛️ Clean Architecture Structure

```
lib/
├── core/
│   ├── constants/       # AppColors, AppTypography, ApiConstants
│   ├── theme/           # AppTheme, dark atmospheric styling
│   ├── utils/           # WeatherCodeMapper, UnitConverter, DateFormatter
│   └── widgets/         # GlassContainer, AtmosphericBackground, SolarHorizonPainter, AppBarHeader
├── data/
│   ├── datasources/     # OpenMeteoRemoteDataSource, MockWeatherDataSource, LocalStorageDataSource
│   ├── models/          # WeatherModel, HourlyForecastModel, DailyForecastModel, LocationModel
│   └── repositories/    # WeatherRepositoryImpl
├── domain/
│   ├── entities/        # WeatherEntity, HourlyForecastEntity, DailyForecastEntity, LocationEntity
│   └── repositories/    # WeatherRepository interface
└── presentation/
    ├── screens/         # HomeShellScreen, TodayForecastScreen, SevenDayForecastScreen, LocationSearchScreen, RadarScreen
    ├── state/           # WeatherNotifier, WeatherState (Provider / ChangeNotifier)
    └── widgets/         # BentoTelemetryGrid, HourlyForecastList, SolarHorizonCard, PrecipitationBarChart, TemperatureRangeBar, SavedCityCard
```

---

## 🚀 Getting Started & Running the App

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (version >= 3.10.0)
- Xcode (for iOS) / Android Studio & Android SDK (for Android)

### Installation
1. Clone this repository:
   ```bash
   git clone https://github.com/DamilolaAdegunwa/weather_mobile_app.git
   cd weather_mobile_app
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run unit and widget tests:
   ```bash
   flutter test
   ```
4. Run the app on your connected device or simulator:
   ```bash
   flutter run
   ```

---

## 📦 Google Play Store Publishing Guide

To publish Aether Weather to the Google Play Store:

### 1. Create a Keystore
Generate a private signing key:
```bash
keytool -genkey -v -keystore android/app/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload
```

### 2. Configure Gradle Signing
Add `android/key.properties`:
```properties
storePassword=<your-store-password>
keyPassword=<your-key-password>
keyAlias=upload
storeFile=upload-keystore.jks
```

### 3. Build App Bundle (.aab)
```bash
flutter build appbundle --release
```
The output file is located at `build/app/outputs/bundle/release/app-release.aab`.

### 4. Upload to Google Play Console
1. Open the [Google Play Console](https://play.google.com/console).
2. Create an App under your Developer Account.
3. Complete the Store Listing (app title, screenshots, icon).
4. Set up Privacy Policy and App Content declarations.
5. Create a release under **Testing > Internal testing** or **Production** and upload `app-release.aab`.
