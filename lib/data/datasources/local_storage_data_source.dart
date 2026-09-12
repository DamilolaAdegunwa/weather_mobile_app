import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/location_model.dart';
import '../../core/utils/unit_converter.dart';

class LocalStorageDataSource {
  static const String _savedLocationsKey = 'aether_saved_locations';
  static const String _tempUnitKey = 'aether_temperature_unit';

  Future<List<LocationModel>> getSavedLocations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final listJson = prefs.getStringList(_savedLocationsKey);
      if (listJson == null || listJson.isEmpty) return [];

      return listJson
          .map((item) => LocationModel.fromJson(jsonDecode(item) as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveLocations(List<LocationModel> locations) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final listJson = locations.map((loc) => jsonEncode(loc.toJson())).toList();
      await prefs.setStringList(_savedLocationsKey, listJson);
    } catch (_) {}
  }

  Future<TemperatureUnit> getTemperatureUnit() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final unitStr = prefs.getString(_tempUnitKey);
      if (unitStr == 'celsius') return TemperatureUnit.celsius;
      return TemperatureUnit.fahrenheit; // Default F as in Stitch designs
    } catch (_) {
      return TemperatureUnit.fahrenheit;
    }
  }

  Future<void> saveTemperatureUnit(TemperatureUnit unit) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tempUnitKey, unit == TemperatureUnit.celsius ? 'celsius' : 'fahrenheit');
    } catch (_) {}
  }
}
