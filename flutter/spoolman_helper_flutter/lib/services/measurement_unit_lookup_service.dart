import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:spoolman_helper_flutter/models/measurement_unit.dart';

/// Service for managing TigerTag brand lookups
///
/// Downloads material data from TigerTag's GitHub repository,
/// stores it locally, and provides lookup functionality.
class MeasurementUnitLookupService {
  static const String _measurementUnitUrl =
      'https://raw.githubusercontent.com/TigerTag-Project/TigerTag-RFID-Guide/refs/heads/main/database/id_measure_unit.json';
  static const String _localFileName = 'tiger_tag_measurement_units.json';

  // Singleton pattern
  static final MeasurementUnitLookupService _instance =
      MeasurementUnitLookupService._internal();
  factory MeasurementUnitLookupService() => _instance;
  MeasurementUnitLookupService._internal();

  /// In-memory cache of measurementUnit
  Map<int, MeasurementUnit> _materialCache = {};
  bool _isInitialized = false;

  /// Get all measurementUnit
  List<MeasurementUnit> get measurementUnit => _materialCache.values.toList();

  /// Check if service is initialized
  bool get isInitialized => _isInitialized;

  /// Get the local file path
  Future<String> get _localFilePath async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$_localFileName';
  }

  /// Download measurementUnit from TigerTag's GitHub repository
  Future<void> downloadAndSaveMeasurementUnits() async {
    try {
      debugPrint('Downloading measurementUnit from TigerTag database...');

      final response = await http.get(Uri.parse(_measurementUnitUrl));

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to download brands: HTTP ${response.statusCode}');
      }

      // Parse JSON to validate it
      final List<dynamic> jsonData = json.decode(response.body);
      final measurementUnit =
          jsonData.map((json) => MeasurementUnit.fromJson(json)).toList();

      debugPrint('Downloaded ${measurementUnit.length} measurementUnit');

      // Save to local file
      final filePath = await _localFilePath;
      final file = File(filePath);
      await file.writeAsString(response.body);

      debugPrint('Saved measurementUnit to $filePath');

      // Update cache
      _materialCache = {
        for (var material in measurementUnit) material.id: material
      };
      _isInitialized = true;
    } catch (e) {
      debugPrint('Error downloading measurementUnit: $e');
      rethrow;
    }
  }

  /// Load measurementUnit from local file, download if file doesn't exist
  Future<void> loadMeasurementUnits() async {
    try {
      final filePath = await _localFilePath;
      final file = File(filePath);

      if (!await file.exists()) {
        debugPrint('Local measurementUnit file not found, downloading...');
        await downloadAndSaveMeasurementUnits();
        return;
      }

      debugPrint('Loading measurementUnit from local file: $filePath');

      final jsonString = await file.readAsString();
      final List<dynamic> jsonData = json.decode(jsonString);
      final measurementUnit =
          jsonData.map((json) => MeasurementUnit.fromJson(json)).toList();

      debugPrint(
          'Loaded ${measurementUnit.length} measurementUnit from local file');

      // Update cache
      _materialCache = {
        for (var material in measurementUnit) material.id: material
      };
      _isInitialized = true;
    } catch (e) {
      debugPrint('Error loading measurementUnit: $e');
      // If loading fails, try to download
      try {
        debugPrint(
            'Attempting to download measurementUnit after load failure...');
        await downloadAndSaveMeasurementUnits();
      } catch (downloadError) {
        debugPrint('Download also failed: $downloadError');
        rethrow;
      }
    }
  }

  /// Get material name by ID
  /// Returns "Unknown MeasurementUnit (id)" if material is not found
  String getMeasurementUnitLabel(int id) {
    final material = _materialCache[id];
    if (material != null) {
      return material.label;
    }
    return 'Unknown MeasurementUnit ($id)';
  }

  /// Get brand by ID
  /// Returns null if brand is not found
  MeasurementUnit? getMeasurementUnit(int id) {
    return _materialCache[id];
  }

  /// Check if a material exists
  bool hasMeasurementUnit(int id) {
    return _materialCache.containsKey(id);
  }

  /// Get the number of cached measurementUnit
  int get materialCount => _materialCache.length;

  /// Clear the cache (useful for testing)
  void clearCache() {
    _materialCache.clear();
    _isInitialized = false;
  }

  /// Delete the local brands file
  Future<void> deleteLocalFile() async {
    try {
      final filePath = await _localFilePath;
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        debugPrint('Deleted local measurementUnit file');
      }
    } catch (e) {
      debugPrint('Error deleting local measurementUnit file: $e');
    }
  }
}
