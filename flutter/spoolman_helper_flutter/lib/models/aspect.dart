import 'package:flutter/foundation.dart';

/// Aspect model representing a aspect
///
/// Data structure based on TigerTag's material database:
/// https://raw.githubusercontent.com/TigerTag-Project/TigerTag-RFID-Guide/refs/heads/main/database/id_aspect.json
@immutable
class Aspect {
  /// Unique aspect ID
  final int id;

  /// Aspect label (e.g., "Matte", "Glossy", "Metallic")
  final String label;

  const Aspect({
    required this.id,
    required this.label,
  });

  /// Create a Material instance from JSON
  factory Aspect.fromJson(Map<String, dynamic> json) {
    return Aspect(
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
  String toString() => 'Aspect(id: $id, label: $label)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Aspect && other.id == id && other.label == label;
  }

  @override
  int get hashCode => Object.hash(id, label);
}
