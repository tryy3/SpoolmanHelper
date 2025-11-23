import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:spoolman_helper_flutter/models/id_type.dart';

/// Service for managing TigerTag idType lookups
///
/// Downloads idType data from TigerTag's GitHub repository,
/// stores it locally, and provides lookup functionality.
class IdTypeLookupService {
  static const String _idTypeUrl =
      'https://raw.githubusercontent.com/TigerTag-Project/TigerTag-RFID-Guide/refs/heads/main/database/id_type.json';
  static const String _localFileName = 'tiger_tag_id_types.json';

  // Singleton pattern
  static final IdTypeLookupService _instance = IdTypeLookupService._internal();
  factory IdTypeLookupService() => _instance;
  IdTypeLookupService._internal();

  /// In-memory cache of idTypes
  Map<int, IdType> _cache = {};
  bool _isInitialized = false;

  /// Get all idTypes
  List<IdType> get idTypes => _cache.values.toList();

  /// Check if service is initialized
  bool get isInitialized => _isInitialized;

  /// Get the local file path
  Future<String> get _localFilePath async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$_localFileName';
  }

  /// Download measurementUnit from TigerTag's GitHub repository
  Future<void> downloadAndSaveIdTypes() async {
    try {
      debugPrint('Downloading idTypes from TigerTag database...');

      final response = await http.get(Uri.parse(_idTypeUrl));

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to download brands: HTTP ${response.statusCode}');
      }

      // Parse JSON to validate it
      final List<dynamic> jsonData = json.decode(response.body);
      final idTypes = jsonData.map((json) => IdType.fromJson(json)).toList();

      debugPrint('Downloaded ${idTypes.length} idTypes');

      // Save to local file
      final filePath = await _localFilePath;
      final file = File(filePath);
      await file.writeAsString(response.body);

      debugPrint('Saved idTypes to $filePath');

      // Update cache
      _cache = {for (var idType in idTypes) idType.id: idType};
      _isInitialized = true;
    } catch (e) {
      debugPrint('Error downloading idTypes: $e');
      rethrow;
    }
  }

  /// Load idTypes from local file, download if file doesn't exist
  Future<void> loadIdTypes() async {
    try {
      final filePath = await _localFilePath;
      final file = File(filePath);

      if (!await file.exists()) {
        debugPrint('Local idTypes file not found, downloading...');
        await downloadAndSaveIdTypes();
        return;
      }

      debugPrint('Loading idTypes from local file: $filePath');

      final jsonString = await file.readAsString();
      final List<dynamic> jsonData = json.decode(jsonString);
      final idTypes = jsonData.map((json) => IdType.fromJson(json)).toList();

      debugPrint('Loaded ${idTypes.length} idTypes from local file');

      // Update cache
      _cache = {for (var idType in idTypes) idType.id: idType};
      _isInitialized = true;
    } catch (e) {
      debugPrint('Error loading idTypes: $e');
      // If loading fails, try to download
      try {
        debugPrint('Attempting to download idTypes after load failure...');
        await downloadAndSaveIdTypes();
      } catch (downloadError) {
        debugPrint('Download also failed: $downloadError');
        rethrow;
      }
    }
  }

  /// Get idType name by ID
  /// Returns "Unknown idType (id)" if idType is not found
  String getIdTypeLabel(int id) {
    final idType = _cache[id];
    if (idType != null) {
      return idType.label;
    }
    return 'Unknown idType ($id)';
  }

  /// Get idType by ID
  /// Returns null if idType is not found
  IdType? getIdType(int id) {
    return _cache[id];
  }

  /// Check if a idType exists
  bool hasIdType(int id) {
    return _cache.containsKey(id);
  }

  /// Get the number of cached idTypes
  int get idTypeCount => _cache.length;

  /// Clear the cache (useful for testing)
  void clearCache() {
    _cache.clear();
    _isInitialized = false;
  }

  /// Delete the local idTypes file
  Future<void> deleteLocalFile() async {
    try {
      final filePath = await _localFilePath;
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        debugPrint('Deleted local idTypes file');
      }
    } catch (e) {
      debugPrint('Error deleting local idTypes file: $e');
    }
  }
}
