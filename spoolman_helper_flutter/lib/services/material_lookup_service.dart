import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../models/material.dart';

/// Service for managing TigerTag brand lookups
///
/// Downloads material data from TigerTag's GitHub repository,
/// stores it locally, and provides lookup functionality.
class MaterialLookupService {
  static const String _materialsUrl =
      'https://raw.githubusercontent.com/TigerTag-Project/TigerTag-RFID-Guide/refs/heads/main/database/id_material.json';
  static const String _localFileName = 'tiger_tag_materials.json';

  // Singleton pattern
  static final MaterialLookupService _instance =
      MaterialLookupService._internal();
  factory MaterialLookupService() => _instance;
  MaterialLookupService._internal();

  /// In-memory cache of materials
  Map<int, Material> _materialCache = {};
  bool _isInitialized = false;

  /// Get all materials
  List<Material> get materials => _materialCache.values.toList();

  /// Check if service is initialized
  bool get isInitialized => _isInitialized;

  /// Get the local file path
  Future<String> get _localFilePath async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$_localFileName';
  }

  /// Download materials from TigerTag's GitHub repository
  Future<void> downloadAndSaveMaterials() async {
    try {
      debugPrint('Downloading materials from TigerTag database...');

      final response = await http.get(Uri.parse(_materialsUrl));

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to download brands: HTTP ${response.statusCode}');
      }

      // Parse JSON to validate it
      final List<dynamic> jsonData = json.decode(response.body);
      final materials =
          jsonData.map((json) => Material.fromJson(json)).toList();

      debugPrint('Downloaded ${materials.length} materials');

      // Save to local file
      final filePath = await _localFilePath;
      final file = File(filePath);
      await file.writeAsString(response.body);

      debugPrint('Saved materials to $filePath');

      // Update cache
      _materialCache = {for (var material in materials) material.id: material};
      _isInitialized = true;
    } catch (e) {
      debugPrint('Error downloading materials: $e');
      rethrow;
    }
  }

  /// Load materials from local file, download if file doesn't exist
  Future<void> loadMaterials() async {
    try {
      final filePath = await _localFilePath;
      final file = File(filePath);

      if (!await file.exists()) {
        debugPrint('Local materials file not found, downloading...');
        await downloadAndSaveMaterials();
        return;
      }

      debugPrint('Loading materials from local file: $filePath');

      final jsonString = await file.readAsString();
      final List<dynamic> jsonData = json.decode(jsonString);
      final materials =
          jsonData.map((json) => Material.fromJson(json)).toList();

      debugPrint('Loaded ${materials.length} materials from local file');

      // Update cache
      _materialCache = {for (var material in materials) material.id: material};
      _isInitialized = true;
    } catch (e) {
      debugPrint('Error loading materials: $e');
      // If loading fails, try to download
      try {
        debugPrint('Attempting to download materials after load failure...');
        await downloadAndSaveMaterials();
      } catch (downloadError) {
        debugPrint('Download also failed: $downloadError');
        rethrow;
      }
    }
  }

  /// Get material name by ID
  /// Returns "Unknown Material (id)" if material is not found
  String getMaterialLabel(int id) {
    final material = _materialCache[id];
    if (material != null) {
      return material.label;
    }
    return 'Unknown Material ($id)';
  }

  /// Get brand by ID
  /// Returns null if brand is not found
  Material? getMaterial(int id) {
    return _materialCache[id];
  }

  /// Check if a material exists
  bool hasMaterial(int id) {
    return _materialCache.containsKey(id);
  }

  /// Get the number of cached materials
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
        debugPrint('Deleted local materials file');
      }
    } catch (e) {
      debugPrint('Error deleting local materials file: $e');
    }
  }
}
