enum TemperatureUnit { celsius, fahrenheit }

class UnitConverter {
  UnitConverter._();

  static double celsiusToFahrenheit(double celsius) {
    return (celsius * 9 / 5) + 32;
  }

  static double fahrenheitToCelsius(double fahrenheit) {
    return (fahrenheit - 32) * 5 / 9;
  }

  static String formatTemperature(double tempInCelsius, TemperatureUnit unit) {
    final value = unit == TemperatureUnit.fahrenheit
        ? celsiusToFahrenheit(tempInCelsius)
        : tempInCelsius;
    return '${value.round()}°';
  }

  static int getTemperatureValue(double tempInCelsius, TemperatureUnit unit) {
    final value = unit == TemperatureUnit.fahrenheit
        ? celsiusToFahrenheit(tempInCelsius)
        : tempInCelsius;
    return value.round();
  }
}
