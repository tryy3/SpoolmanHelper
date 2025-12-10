import 'package:flutter/foundation.dart';

/// Measurement unit model representing a measurement unit
///
/// Data structure based on TigerTag's material database:
/// https://raw.githubusercontent.com/TigerTag-Project/TigerTag-RFID-Guide/refs/heads/main/database/id_measure_unit.json
@immutable
class MeasurementUnit {
  /// Unique measurement unit ID
  final int id;

  /// Measurement unit label (e.g., "g", "kg", "m", "ft")
  final String label;

  /// Measurement type (e.g. "weight", "volume", "area")
  final String measurementType;

  const MeasurementUnit({
    required this.id,
    required this.label,
    required this.measurementType,
  });

  /// Create a Material instance from JSON
  factory MeasurementUnit.fromJson(Map<String, dynamic> json) {
    return MeasurementUnit(
      id: json['id'] as int,
      label: json['label'] as String,
      measurementType: json['type'] as String,
    );
  }

  /// Convert Material instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'type': measurementType,
    };
  }

  @override
  String toString() =>
      'MeasurementUnit(id: $id, label: $label, measurementType: $measurementType)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MeasurementUnit &&
        other.id == id &&
        other.label == label &&
        other.measurementType == measurementType;
  }

  @override
  int get hashCode => Object.hash(id, label, measurementType);
}
