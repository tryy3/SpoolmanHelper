import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../models/brand.dart';

/// Service for managing TigerTag brand lookups
/// 
/// Downloads brand data from TigerTag's GitHub repository,
/// stores it locally, and provides lookup functionality.
class BrandLookupService {
  static const String _brandsUrl =
      'https://raw.githubusercontent.com/TigerTag-Project/TigerTag-RFID-Guide/refs/heads/main/database/id_brand.json';
  static const String _localFileName = 'tiger_tag_brands.json';

  // Singleton pattern
  static final BrandLookupService _instance = BrandLookupService._internal();
  factory BrandLookupService() => _instance;
  BrandLookupService._internal();

  /// In-memory cache of brands
  Map<int, Brand> _brandCache = {};
  bool _isInitialized = false;

  /// Get all brands
  List<Brand> get brands => _brandCache.values.toList();

  /// Check if service is initialized
  bool get isInitialized => _isInitialized;

  /// Get the local file path
  Future<String> get _localFilePath async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$_localFileName';
  }

  /// Download brands from TigerTag's GitHub repository
  Future<void> downloadAndSaveBrands() async {
    try {
      debugPrint('Downloading brands from TigerTag database...');
      
      final response = await http.get(Uri.parse(_brandsUrl));
      
      if (response.statusCode != 200) {
        throw Exception(
            'Failed to download brands: HTTP ${response.statusCode}');
      }

      // Parse JSON to validate it
      final List<dynamic> jsonData = json.decode(response.body);
      final brands = jsonData.map((json) => Brand.fromJson(json)).toList();
      
      debugPrint('Downloaded ${brands.length} brands');

      // Save to local file
      final filePath = await _localFilePath;
      final file = File(filePath);
      await file.writeAsString(response.body);
      
      debugPrint('Saved brands to $filePath');

      // Update cache
      _brandCache = {for (var brand in brands) brand.id: brand};
      _isInitialized = true;
    } catch (e) {
      debugPrint('Error downloading brands: $e');
      rethrow;
    }
  }

  /// Load brands from local file, download if file doesn't exist
  Future<void> loadBrands() async {
    try {
      final filePath = await _localFilePath;
      final file = File(filePath);

      if (!await file.exists()) {
        debugPrint('Local brands file not found, downloading...');
        await downloadAndSaveBrands();
        return;
      }

      debugPrint('Loading brands from local file: $filePath');
      
      final jsonString = await file.readAsString();
      final List<dynamic> jsonData = json.decode(jsonString);
      final brands = jsonData.map((json) => Brand.fromJson(json)).toList();
      
      debugPrint('Loaded ${brands.length} brands from local file');

      // Update cache
      _brandCache = {for (var brand in brands) brand.id: brand};
      _isInitialized = true;
    } catch (e) {
      debugPrint('Error loading brands: $e');
      // If loading fails, try to download
      try {
        debugPrint('Attempting to download brands after load failure...');
        await downloadAndSaveBrands();
      } catch (downloadError) {
        debugPrint('Download also failed: $downloadError');
        rethrow;
      }
    }
  }

  /// Get brand name by ID
  /// Returns "Unknown Brand (id)" if brand is not found
  String getBrandName(int id) {
    final brand = _brandCache[id];
    if (brand != null) {
      return brand.name;
    }
    return 'Unknown Brand ($id)';
  }

  /// Get brand by ID
  /// Returns null if brand is not found
  Brand? getBrand(int id) {
    return _brandCache[id];
  }

  /// Check if a brand exists
  bool hasBrand(int id) {
    return _brandCache.containsKey(id);
  }

  /// Get the number of cached brands
  int get brandCount => _brandCache.length;

  /// Clear the cache (useful for testing)
  void clearCache() {
    _brandCache.clear();
    _isInitialized = false;
  }

  /// Delete the local brands file
  Future<void> deleteLocalFile() async {
    try {
      final filePath = await _localFilePath;
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        debugPrint('Deleted local brands file');
      }
    } catch (e) {
      debugPrint('Error deleting local brands file: $e');
    }
  }
}

