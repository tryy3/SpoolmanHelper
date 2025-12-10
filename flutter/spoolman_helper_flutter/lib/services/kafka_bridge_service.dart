import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/filament_transfer_event.dart';

/// Result of sending a Kafka event
class KafkaEventResult {
  final bool success;
  final String? errorMessage;

  const KafkaEventResult({
    required this.success,
    this.errorMessage,
  });

  factory KafkaEventResult.ok() => const KafkaEventResult(success: true);

  factory KafkaEventResult.error(String message) =>
      KafkaEventResult(success: false, errorMessage: message);
}

/// Service for sending events to the Kafka bridge
class KafkaBridgeService {
  static const String _baseUrl = 'https://kafka.tryy3.dev';
  static const String _filamentTransferTopic =
      '3dprinter-filament-transfer-initiated';

  // Singleton pattern
  static final KafkaBridgeService _instance = KafkaBridgeService._internal();
  factory KafkaBridgeService() => _instance;
  KafkaBridgeService._internal();

  /// Send a filament transfer event to Kafka
  ///
  /// Returns [KafkaEventResult] indicating success or failure
  Future<KafkaEventResult> sendFilamentTransferEvent(
      FilamentTransferEvent event) async {
    try {
      final url = Uri.parse('$_baseUrl/topics/$_filamentTransferTopic');
      final payload = json.encode(event.toKafkaPayload());

      debugPrint('Sending filament transfer event to Kafka: $url');
      debugPrint('Payload: $payload');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/vnd.kafka.json.v2+json',
        },
        body: payload,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        debugPrint('Kafka event sent successfully: ${response.statusCode}');
        return KafkaEventResult.ok();
      } else {
        final errorMsg =
            'Kafka bridge returned ${response.statusCode}: ${response.body}';
        debugPrint('Kafka event failed: $errorMsg');
        return KafkaEventResult.error(errorMsg);
      }
    } catch (e) {
      final errorMsg = 'Failed to send Kafka event: $e';
      debugPrint(errorMsg);
      return KafkaEventResult.error(errorMsg);
    }
  }
}
