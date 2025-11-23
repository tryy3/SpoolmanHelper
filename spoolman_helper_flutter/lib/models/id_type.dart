import 'package:flutter/foundation.dart';

/// Diameter model representing a diameter
///
/// Data structure based on TigerTag's material database:
/// https://raw.githubusercontent.com/TigerTag-Project/TigerTag-RFID-Guide/refs/heads/main/database/id_type.json
@immutable
class IdType {
  /// Unique diameter ID
  final int id;

  /// Diameter label (e.g., "Filament", "Resin")
  final String label;

  const IdType({
    required this.id,
    required this.label,
  });

  /// Create a Material instance from JSON
  factory IdType.fromJson(Map<String, dynamic> json) {
    return IdType(
      id: json['id'] as int,
      label: json['label'] as String,
    );
  }

  /// Convert Material instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
    };
  }

  @override
  String toString() => 'IdType(id: $id, label: $label)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is IdType && other.id == id && other.label == label;
  }

  @override
  int get hashCode => Object.hash(id, label);
}
