import 'package:flutter/foundation.dart';

/// Brand model representing a filament/resin manufacturer
/// 
/// Data structure based on TigerTag's brand database:
/// https://raw.githubusercontent.com/TigerTag-Project/TigerTag-RFID-Guide/refs/heads/main/database/id_brand.json
@immutable
class Brand {
  /// Unique brand ID
  final int id;
  
  /// Brand name (e.g., "Bambu Lab", "Polymaker")
  final String name;
  
  /// Type IDs this brand supports (e.g., [142] for filament, [173] for resin)
  /// 142 = Filament
  /// 173 = Resin
  final List<int> typeIds;

  const Brand({
    required this.id,
    required this.name,
    required this.typeIds,
  });

  /// Create a Brand instance from JSON
  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['id'] as int,
      name: json['name'] as String,
      typeIds: (json['type_ids'] as List<dynamic>)
          .map((e) => e as int)
          .toList(),
    );
  }

  /// Convert Brand instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type_ids': typeIds,
    };
  }

  @override
  String toString() => 'Brand(id: $id, name: $name, typeIds: $typeIds)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Brand && 
           other.id == id &&
           other.name == name &&
           listEquals(other.typeIds, typeIds);
  }

  @override
  int get hashCode => Object.hash(id, name, Object.hashAll(typeIds));

  /// Check if this brand supports filament (type ID 142)
  bool get supportsFilament => typeIds.contains(142);

  /// Check if this brand supports resin (type ID 173)
  bool get supportsResin => typeIds.contains(173);
}

