import 'package:flutter/foundation.dart';

/// Temperature information for filament
@immutable
class TemperatureInfo {
  final int nozzle;
  final int bed;

  const TemperatureInfo({
    required this.nozzle,
    required this.bed,
  });

  Map<String, dynamic> toJson() => {
        'nozzle': nozzle,
        'bed': bed,
      };
}

/// Filament information for the transfer event
@immutable
class FilamentTagData {
  final String id;
  final String name;
  final String material;
  final String color;
  final TemperatureInfo temperature;
  final double diameter;
  final int weight;
  final int? spoolWeight;

  const FilamentTagData({
    required this.id,
    required this.name,
    required this.material,
    required this.color,
    required this.temperature,
    required this.diameter,
    required this.weight,
    this.spoolWeight,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'id': id,
      'name': name,
      'material': material,
      'color': color,
      'temperature': temperature.toJson(),
      'diameter': diameter,
      'weight': weight,
    };
    if (spoolWeight != null) {
      json['spoolWeight'] = spoolWeight;
    }
    return json;
  }
}

/// Filament transfer event sent to Kafka when a filament is moved to a new location
@immutable
class FilamentTransferEvent {
  final String spoolId;
  final String locationId;
  final DateTime timestamp;
  final FilamentTagData tagData;

  const FilamentTransferEvent({
    required this.spoolId,
    required this.locationId,
    required this.timestamp,
    required this.tagData,
  });

  Map<String, dynamic> toJson() => {
        'spoolId': spoolId,
        'locationId': locationId,
        'timestamp': timestamp.toUtc().toIso8601String(),
        'tagData': tagData.toJson(),
      };

  /// Wrap the event in Kafka bridge format
  Map<String, dynamic> toKafkaPayload() => {
        'records': [
          {'value': toJson()}
        ],
      };
}
