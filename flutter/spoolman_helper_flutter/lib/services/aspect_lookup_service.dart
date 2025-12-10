import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../models/aspect.dart';

/// Service for managing TigerTag brand lookups
///
/// Downloads aspect data from TigerTag's GitHub repository,
/// stores it locally, and provides lookup functionality.
class AspectLookupService {
  static const String _aspectsUrl =
      'https://raw.githubusercontent.com/TigerTag-Project/TigerTag-RFID-Guide/refs/heads/main/database/id_aspect.json';
  static const String _localFileName = 'tiger_tag_aspects.json';

  // Singleton pattern
  static final AspectLookupService _instance = AspectLookupService._internal();
  factory AspectLookupService() => _instance;
  AspectLookupService._internal();

  /// In-memory cache of aspects
  Map<int, Aspect> _aspectCache = {};
  bool _isInitialized = false;

  /// Get all aspects
  List<Aspect> get aspects => _aspectCache.values.toList();

  /// Check if service is initialized
  bool get isInitialized => _isInitialized;

  /// Get the local file path
  Future<String> get _localFilePath async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$_localFileName';
  }

  /// Download aspects from TigerTag's GitHub repository
  Future<void> downloadAndSaveAspects() async {
    try {
      debugPrint('Downloading aspects from TigerTag database...');

      final response = await http.get(Uri.parse(_aspectsUrl));

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to download brands: HTTP ${response.statusCode}');
      }

      // Parse JSON to validate it
      final List<dynamic> jsonData = json.decode(response.body);
      final aspects = jsonData.map((json) => Aspect.fromJson(json)).toList();

      debugPrint('Downloaded ${aspects.length} aspects');

      // Save to local file
      final filePath = await _localFilePath;
      final file = File(filePath);
      await file.writeAsString(response.body);

      debugPrint('Saved aspects to $filePath');

      // Update cache
      _aspectCache = {for (var aspect in aspects) aspect.id: aspect};
      _isInitialized = true;
    } catch (e) {
      debugPrint('Error downloading aspects: $e');
      rethrow;
    }
  }

  /// Load aspects from local file, download if file doesn't exist
  Future<void> loadAspects() async {
    try {
      final filePath = await _localFilePath;
      final file = File(filePath);

      if (!await file.exists()) {
        debugPrint('Local aspects file not found, downloading...');
        await downloadAndSaveAspects();
        return;
      }

      debugPrint('Loading aspects from local file: $filePath');

      final jsonString = await file.readAsString();
      final List<dynamic> jsonData = json.decode(jsonString);
      final aspects = jsonData.map((json) => Aspect.fromJson(json)).toList();

      debugPrint('Loaded ${aspects.length} aspects from local file');

      // Update cache
      _aspectCache = {for (var aspect in aspects) aspect.id: aspect};
      _isInitialized = true;
    } catch (e) {
      debugPrint('Error loading aspects: $e');
      // If loading fails, try to download
      try {
        debugPrint('Attempting to download aspects after load failure...');
        await downloadAndSaveAspects();
      } catch (downloadError) {
        debugPrint('Download also failed: $downloadError');
        rethrow;
      }
    }
  }

  /// Get aspect name by ID
  /// Returns "Unknown Aspect (id)" if aspect is not found
  String getAspectLabel(int id) {
    final aspect = _aspectCache[id];
    if (aspect != null) {
      return aspect.label;
    }
    return 'Unknown Aspect ($id)';
  }

  /// Get brand by ID
  /// Returns null if brand is not found
  Aspect? getAspect(int id) {
    return _aspectCache[id];
  }

  /// Check if a aspect exists
  bool hasAspect(int id) {
    return _aspectCache.containsKey(id);
  }

  /// Get the number of cached aspects
  int get aspectCount => _aspectCache.length;

  /// Clear the cache (useful for testing)
  void clearCache() {
    _aspectCache.clear();
    _isInitialized = false;
  }

  /// Delete the local brands file
  Future<void> deleteLocalFile() async {
    try {
      final filePath = await _localFilePath;
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        debugPrint('Deleted local aspects file');
      }
    } catch (e) {
      debugPrint('Error deleting local aspects file: $e');
    }
  }
}
