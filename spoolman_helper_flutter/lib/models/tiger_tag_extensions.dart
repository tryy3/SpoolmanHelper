import 'package:flutter/material.dart';
import 'tiger_tag.dart';
import 'tiger_tag_lookups.dart';

/// Extension methods for TigerTag to provide human-readable data
extension TigerTagExtensions on TigerTag {
  /// Get the material name
  String get materialName => getMaterialName(materialID);

  /// Get the diameter as a string
  String get diameterString => getDiameter(diameterID);

  /// Get the combined aspect/finish
  String get aspectString =>
      getCombinedAspects(firstVisualAspectID, secondVisualAspectID);

  /// Get the ID type (Filament, Resin, etc.)
  String get idTypeString => getIdType(idType);

  /// Get the measurement unit
  String get measurementUnit => getMeasurementUnit(measurementID);

  /// Get the weight/measurement value with unit
  String get measurementValueWithUnit => '$measurementValue ${measurementUnit}';

  /// Get nozzle temperature range as string
  String get nozzleTemperatureRange =>
      '$nozzleTemperatureMin°C - $nozzleTemperatureMax°C';

  /// Get bed temperature range as string
  String get bedTemperatureRange =>
      '$bedTemperatureMin°C - $bedTemperatureMax°C';

  /// Get drying temperature as string
  String get dryingTemperature => '$dryTemp°C';

  /// Get drying time as string
  String get dryingTime => '$dryTime h';

  /// Get the primary color as a Flutter Color
  Color get primaryColor {
    if (firstColour.length >= 4) {
      // RGBA format
      return Color.fromARGB(
        firstColour[3], // Alpha
        firstColour[0], // Red
        firstColour[1], // Green
        firstColour[2], // Blue
      );
    } else if (firstColour.length >= 3) {
      // RGB format
      return Color.fromARGB(
        255, // Fully opaque
        firstColour[0], // Red
        firstColour[1], // Green
        firstColour[2], // Blue
      );
    }
    return Colors.grey; // Fallback
  }

  /// Get secondary color as a Flutter Color (if available)
  Color? get secondaryColor {
    if (color2.length >= 3) {
      return Color.fromARGB(
        255, // Fully opaque
        color2[0], // Red
        color2[1], // Green
        color2[2], // Blue
      );
    }
    return null;
  }

  /// Get tertiary color as a Flutter Color (if available)
  Color? get tertiaryColor {
    if (color3.length >= 3) {
      return Color.fromARGB(
        255, // Fully opaque
        color3[0], // Red
        color3[1], // Green
        color3[2], // Blue
      );
    }
    return null;
  }

  /// Get a display name combining brand and material
  /// Requires brand name to be passed in since brand lookup is dynamic
  String getDisplayName(String brandName) => '$brandName - $materialName';

  /// Check if the tag has valid temperature data
  bool get hasTemperatureData =>
      nozzleTemperatureMin > 0 && nozzleTemperatureMax > 0;

  /// Check if the tag has valid drying data
  bool get hasDryingData => dryTemp > 0 && dryTime > 0;

  /// Check if the tag has valid bed temperature data
  bool get hasBedTemperatureData =>
      bedTemperatureMin > 0 && bedTemperatureMax > 0;

  /// Get color hex string for display
  String get colorHex {
    final color = primaryColor;
    return '#${color.red.toRadixString(16).padLeft(2, '0')}'
        '${color.green.toRadixString(16).padLeft(2, '0')}'
        '${color.blue.toRadixString(16).padLeft(2, '0')}';
  }

  /// Format the TigerTag ID as a 3-digit string
  String get formattedId => tigerTagID.toString().padLeft(3, '0');
}
