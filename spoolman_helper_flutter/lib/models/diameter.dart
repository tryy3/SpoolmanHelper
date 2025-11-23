import 'package:flutter/foundation.dart';

/// Diameter model representing a diameter
///
/// Data structure based on TigerTag's material database:
/// https://raw.githubusercontent.com/TigerTag-Project/TigerTag-RFID-Guide/refs/heads/main/database/id_diameter.json
@immutable
class Diameter {
  /// Unique diameter ID
  final int id;

  /// Diameter label (e.g., "1.75", "2.85")
  final String label;

  const Diameter({
    required this.id,
    required this.label,
  });

  /// Create a Material instance from JSON
  factory Diameter.fromJson(Map<String, dynamic> json) {
    return Diameter(
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
  String toString() => 'Diameter(id: $id, label: $label)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Diameter && other.id == id && other.label == label;
  }

  @override
  int get hashCode => Object.hash(id, label);
}
