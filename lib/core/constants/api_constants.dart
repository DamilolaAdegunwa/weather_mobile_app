class ApiConstants {
  ApiConstants._();

  static const String openMeteoForecastBaseUrl = 'https://api.open-meteo.com/v1/forecast';
  static const String openMeteoGeocodingBaseUrl = 'https://geocoding-api.open-meteo.com/v1/search';
  static const String openMeteoAirQualityBaseUrl = 'https://air-quality-api.open-meteo.com/v1/air-quality';

  // Default fallback coordinates (San Francisco, CA as featured in design)
  static const double defaultLatitude = 37.7749;
  static const double defaultLongitude = -122.4194;
  static const String defaultCityName = 'San Francisco';
  static const String defaultCountryName = 'United States';
}
