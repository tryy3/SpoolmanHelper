import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:spoolman_helper_flutter/models/diameter.dart';

/// Service for managing TigerTag diameter lookups
///
/// Downloads diameter data from TigerTag's GitHub repository,
/// stores it locally, and provides lookup functionality.
class DiameterLookupService {
  static const String _diameterUrl =
      'https://raw.githubusercontent.com/TigerTag-Project/TigerTag-RFID-Guide/refs/heads/main/database/id_diameter.json';
  static const String _localFileName = 'tiger_tag_diameters.json';

  // Singleton pattern
  static final DiameterLookupService _instance =
      DiameterLookupService._internal();
  factory DiameterLookupService() => _instance;
  DiameterLookupService._internal();

  /// In-memory cache of diameters
  Map<int, Diameter> _cache = {};
  bool _isInitialized = false;

  /// Get all diameters
  List<Diameter> get diameters => _cache.values.toList();

  /// Check if service is initialized
  bool get isInitialized => _isInitialized;

  /// Get the local file path
  Future<String> get _localFilePath async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$_localFileName';
  }

  /// Download measurementUnit from TigerTag's GitHub repository
  Future<void> downloadAndSaveDiameters() async {
    try {
      debugPrint('Downloading diameters from TigerTag database...');

      final response = await http.get(Uri.parse(_diameterUrl));

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to download brands: HTTP ${response.statusCode}');
      }

      // Parse JSON to validate it
      final List<dynamic> jsonData = json.decode(response.body);
      final diameters =
          jsonData.map((json) => Diameter.fromJson(json)).toList();

      debugPrint('Downloaded ${diameters.length} diameters');

      // Save to local file
      final filePath = await _localFilePath;
      final file = File(filePath);
      await file.writeAsString(response.body);

      debugPrint('Saved diameters to $filePath');

      // Update cache
      _cache = {for (var diameter in diameters) diameter.id: diameter};
      _isInitialized = true;
    } catch (e) {
      debugPrint('Error downloading diameters: $e');
      rethrow;
    }
  }

  /// Load diameters from local file, download if file doesn't exist
  Future<void> loadDiameters() async {
    try {
      final filePath = await _localFilePath;
      final file = File(filePath);

      if (!await file.exists()) {
        debugPrint('Local diameters file not found, downloading...');
        await downloadAndSaveDiameters();
        return;
      }

      debugPrint('Loading diameters from local file: $filePath');

      final jsonString = await file.readAsString();
      final List<dynamic> jsonData = json.decode(jsonString);
      final diameters =
          jsonData.map((json) => Diameter.fromJson(json)).toList();

      debugPrint('Loaded ${diameters.length} diameters from local file');

      // Update cache
      _cache = {for (var diameter in diameters) diameter.id: diameter};
      _isInitialized = true;
    } catch (e) {
      debugPrint('Error loading diameters: $e');
      // If loading fails, try to download
      try {
        debugPrint('Attempting to download diameters after load failure...');
        await downloadAndSaveDiameters();
      } catch (downloadError) {
        debugPrint('Download also failed: $downloadError');
        rethrow;
      }
    }
  }

  /// Get diameter name by ID
  /// Returns "Unknown Diameter (id)" if diameter is not found
  String getDiameterLabel(int id) {
    final diameter = _cache[id];
    if (diameter != null) {
      return diameter.label;
    }
    return 'Unknown Diameter ($id)';
  }

  /// Get diameter by ID
  /// Returns null if diameter is not found
  Diameter? getDiameter(int id) {
    return _cache[id];
  }

  /// Check if a diameter exists
  bool hasDiameter(int id) {
    return _cache.containsKey(id);
  }

  /// Get the number of cached diameters
  int get diameterCount => _cache.length;

  /// Clear the cache (useful for testing)
  void clearCache() {
    _cache.clear();
    _isInitialized = false;
  }

  /// Delete the local diameters file
  Future<void> deleteLocalFile() async {
    try {
      final filePath = await _localFilePath;
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        debugPrint('Deleted local diameters file');
      }
    } catch (e) {
      debugPrint('Error deleting local diameters file: $e');
    }
  }
}
