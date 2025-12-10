import 'package:flutter/foundation.dart';

/// Material model representing a material
///
/// Data structure based on TigerTag's material database:
/// https://raw.githubusercontent.com/TigerTag-Project/TigerTag-RFID-Guide/refs/heads/main/database/id_material.json
@immutable
class Material {
  /// Unique material ID
  final int id;

  /// Material label (e.g., "PLA", "ABS", "PETG")
  final String label;

  /// Material density (g/cm³)
  final double? density;

  /// Whether the material is filled (true/false)
  final bool filled;

  /// Product type ID
  final int productTypeID;

  const Material({
    required this.id,
    required this.label,
    required this.density,
    required this.filled,
    required this.productTypeID,
  });

  /// Create a Material instance from JSON
  factory Material.fromJson(Map<String, dynamic> json) {
    return Material(
      id: json['id'] as int,
      label: json['label'] as String,
      density: (json['density'] as num?)?.toDouble(),
      filled: json['filled'] as bool,
      productTypeID: json['product_type_id'] as int,
    );
  }

  /// Convert Material instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'density': density,
      'filled': filled,
      'product_type_id': productTypeID,
    };
  }

  @override
  String toString() =>
      'Material(id: $id, label: $label, density: $density, filled: $filled, product_type_id: $productTypeID)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Material &&
        other.id == id &&
        other.label == label &&
        other.density == density &&
        other.filled == filled &&
        other.productTypeID == productTypeID;
  }

  @override
  int get hashCode => Object.hash(id, label, density, filled, productTypeID);
}
