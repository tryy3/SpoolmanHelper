import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

/// TigerTag model representing a parsed TigerTag RFID tag
///
/// TigerTag uses a proprietary format stored on MIFARE Ultralight tags.
/// This class parses the raw memory bytes into structured data.
@immutable
class TigerTag {
  // Propeties are documented like this:
  // <description/Property name> - <byte size> - <type> - <stored at bytes> - <page> - <start byte>
  // The page is based on TigerTag layout, 1 page = 4 bytes

  /// The TigerTagID - 4 bytes - Int - 16-19 - Page 4 - 0
  final int tigerTagID;

  /// The product ID - 4 bytes - Hex string - 20-23 - Page 5 - 0
  final String productID;

  /// The material ID - 2 bytes - Int - 24-25 - Page 6 - 0
  final int materialID;

  /// The First Visual Aspect ID - 1 byte - Int - 26-26 - Page 6 - 2
  final int firstVisualAspectID;

  /// The Second Visual Aspect ID - 1 byte - Int - 27-27 - Page 6 - 3
  final int secondVisualAspectID;

  /// The ID type - 1 byte - Int - 28-28 - Page 7 - 0
  final int idType;

  /// The diameter ID - 1 byte - Int - 29-29 - Page 7 - 1
  final int diameterID;

  /// First colour (RGBA) - 4 bytes - List<int> - 30-33 - Page 7 - 2
  final List<int> firstColour;

  /// The ID brand - 2 bytes - Int - 30-31 - Page 7 - 2
  final int idBrand;

  /// The Measurement ID (Unit ID) - 1 byte - Int - 32-32 - Page 7 - 3
  final int measurementID;

  /// Raw memory bytes from the tag (for debugging/reference)
  final List<int> rawMemory;

  /// Timestamp when the tag was parsed
  final DateTime parsedAt;

  const TigerTag({
    required this.tigerTagID,
    required this.productID,
    required this.materialID,
    required this.firstVisualAspectID,
    required this.secondVisualAspectID,
    required this.idType,
    required this.diameterID,
    required this.firstColour,
    required this.idBrand,
    required this.measurementID,
    required this.rawMemory,
    required this.parsedAt,
  });

  /// Parse raw memory bytes into a TigerTag instance
  ///
  /// [memory] - Raw memory bytes read from the MIFARE Ultralight tag
  /// Returns a TigerTag instance with parsed data, or null if parsing fails
  static TigerTag? parse(List<int> memory) {
    try {
      if (memory.length < 20) {
        debugPrint(
            'TigerTag: Memory too short (${memory.length} bytes, need at least 20)');
        return null;
      }

      // Parse TigerTag ID from bytes 16-19 (4 bytes, big-endian)
      final tigerTagIDBytes = memory.sublist(16, 20);
      final tigerTagID = _bytesToInt(tigerTagIDBytes, endian: Endian.big);

      // Prase the product ID from bytes (20-23) - Hex string
      final productIDBytes = memory.sublist(20, 24);
      final productID = _bytesToHex(productIDBytes);

      // Parse the material ID from bytes (24-25) - Int
      final materialIDBytes = memory.sublist(24, 26);
      final materialID = _bytesToInt(materialIDBytes, endian: Endian.big);

      // Parse the first visual aspect ID from bytes (26-26) - Int
      final firstVisualAspectIDBytes = memory.sublist(26, 27);
      final firstVisualAspectID =
          _bytesToInt(firstVisualAspectIDBytes, endian: Endian.big);

      // Parse the second visual aspect ID from bytes (27-27) - Int
      final secondVisualAspectIDBytes = memory.sublist(27, 28);
      final secondVisualAspectID =
          _bytesToInt(secondVisualAspectIDBytes, endian: Endian.big);

      // Parse the ID type from bytes (28-28) - Int
      final idTypeBytes = memory.sublist(28, 29);
      final idType = _bytesToInt(idTypeBytes, endian: Endian.big);

      // Parse the diameter ID from bytes (29-29) - Int
      final diameterIDBytes = memory.sublist(29, 30);
      final diameterID = _bytesToInt(diameterIDBytes, endian: Endian.big);

      // Parse the first colour from bytes (30-33) - List<int>
      final firstColourBytes = memory.sublist(30, 34);

      // Parse the ID brand from bytes (30-31) - Int
      final idBrandBytes = memory.sublist(30, 32);
      final idBrand = _bytesToInt(idBrandBytes, endian: Endian.big);

      // Parse the measurement ID from bytes (32-32) - Int
      final measurementIDBytes = memory.sublist(32, 33);
      final measurementID = _bytesToInt(measurementIDBytes, endian: Endian.big);

      // TODO: Add more field parsing here as you discover the format
      // Example:
      // final someField = _parseSomeField(memory);
      // final anotherField = _parseAnotherField(memory);

      return TigerTag(
        tigerTagID: tigerTagID,
        productID: productID,
        materialID: materialID,
        firstVisualAspectID: firstVisualAspectID,
        secondVisualAspectID: secondVisualAspectID,
        idType: idType,
        diameterID: diameterID,
        firstColour: firstColourBytes,
        idBrand: idBrand,
        measurementID: measurementID,
        rawMemory: List.unmodifiable(memory),
        parsedAt: DateTime.now(),
      );
    } catch (e, stackTrace) {
      debugPrint('TigerTag: Error parsing tag: $e');
      debugPrint('TigerTag: Stack trace: $stackTrace');
      return null;
    }
  }

  /// Convert bytes to integer (binary format)
  ///
  /// [bytes] - List of bytes to parse (typically 1-4 bytes for int32)
  /// [endian] - Byte order (Endian.little or Endian.big)
  static int _bytesToInt(List<int> bytes, {Endian endian = Endian.little}) {
    if (bytes.isEmpty) return 0;

    try {
      // Ensure we have at least 4 bytes for a 32-bit int
      final paddedBytes = List<int>.from(bytes);
      while (paddedBytes.length < 4) {
        paddedBytes.add(0);
      }

      // Take only the first 4 bytes for a 32-bit integer
      final byteData = ByteData.view(
        Uint8List.fromList(paddedBytes.sublist(0, 4)).buffer,
      );

      return byteData.getInt32(0, endian);
    } catch (e) {
      debugPrint('TigerTag: Error converting bytes to int: $e');
      return 0;
    }
  }

  /// Convert bytes to unsigned integer
  static int _bytesToUInt(List<int> bytes, {Endian endian = Endian.little}) {
    if (bytes.isEmpty) return 0;

    try {
      final paddedBytes = List<int>.from(bytes);
      while (paddedBytes.length < 4) {
        paddedBytes.add(0);
      }

      final byteData = ByteData.view(
        Uint8List.fromList(paddedBytes.sublist(0, 4)).buffer,
      );

      return byteData.getUint32(0, endian);
    } catch (e) {
      debugPrint('TigerTag: Error converting bytes to uint: $e');
      return 0;
    }
  }

  /// Convert bytes to hex string
  static String _bytesToHex(List<int> bytes) {
    if (bytes.isEmpty) return '';
    return bytes
        .map((b) => b.toRadixString(16).padLeft(2, '0'))
        .join(':')
        .toUpperCase();
  }

  /// Try to decode bytes as text (UTF-8)
  static String _tryDecodeAsText(List<int> bytes) {
    try {
      return utf8.decode(bytes, allowMalformed: true);
    } catch (e) {
      return '(binary data)';
    }
  }

  /// Get a formatted hex dump of the raw memory
  String getHexDump() {
    final buffer = StringBuffer();
    for (int i = 0; i < rawMemory.length; i += 16) {
      // Address
      buffer.write('${i.toRadixString(16).padLeft(4, '0')}:  ');

      // Hex values
      for (int j = 0; j < 16; j++) {
        if (i + j < rawMemory.length) {
          buffer
              .write('${rawMemory[i + j].toRadixString(16).padLeft(2, '0')} ');
        } else {
          buffer.write('   ');
        }
        if (j == 7) buffer.write(' '); // Extra space in the middle
      }

      // ASCII representation
      buffer.write(' |');
      for (int j = 0; j < 16 && i + j < rawMemory.length; j++) {
        final byte = rawMemory[i + j];
        if (byte >= 32 && byte <= 126) {
          buffer.write(String.fromCharCode(byte));
        } else {
          buffer.write('.');
        }
      }
      buffer.write('|\n');
    }
    return buffer.toString();
  }

  @override
  String toString() {
    return 'TigerTag(id: $tigerTagID, memorySize: ${rawMemory.length} bytes, parsedAt: $parsedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TigerTag && other.tigerTagID == tigerTagID;
  }

  @override
  int get hashCode => tigerTagID.hashCode;
}
