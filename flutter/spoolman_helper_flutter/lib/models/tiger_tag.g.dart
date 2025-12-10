// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tiger_tag.dart';

// **************************************************************************
// TigerTagGenerator
// **************************************************************************

/// Generated parse method for TigerTag
TigerTag? _$parseTigerTag(List<int> memory) {
  try {
    if (memory.length < 96) {
      debugPrint(
          'TigerTag: Memory too short (${memory.length} bytes, need at least 96)');
      return null;
    }

    // Parse tigerTagID from bytes 16-19 (Page 4, byte 0, 4 bytes)
    final tigerTagIDBytes = memory.sublist(16, 20);
    final tigerTagID = _bytesToInt(tigerTagIDBytes, endian: Endian.big);

    // Parse productID from bytes 20-23 (Page 5, byte 0, 4 bytes)
    final productIDBytes = memory.sublist(20, 24);
    final productID = _bytesToHex(productIDBytes);

    // Parse materialID from bytes 24-25 (Page 6, byte 0, 2 bytes)
    final materialIDBytes = memory.sublist(24, 26);
    final materialID = _bytesToInt(materialIDBytes, endian: Endian.big);

    // Parse firstVisualAspectID from bytes 26-26 (Page 6, byte 2, 1 bytes)
    final firstVisualAspectIDBytes = memory.sublist(26, 27);
    final firstVisualAspectID =
        _bytesToInt(firstVisualAspectIDBytes, endian: Endian.big);

    // Parse secondVisualAspectID from bytes 27-27 (Page 6, byte 3, 1 bytes)
    final secondVisualAspectIDBytes = memory.sublist(27, 28);
    final secondVisualAspectID =
        _bytesToInt(secondVisualAspectIDBytes, endian: Endian.big);

    // Parse idType from bytes 28-28 (Page 7, byte 0, 1 bytes)
    final idTypeBytes = memory.sublist(28, 29);
    final idType = _bytesToInt(idTypeBytes, endian: Endian.big);

    // Parse diameterID from bytes 29-29 (Page 7, byte 1, 1 bytes)
    final diameterIDBytes = memory.sublist(29, 30);
    final diameterID = _bytesToInt(diameterIDBytes, endian: Endian.big);

    // Parse idBrand from bytes 30-31 (Page 7, byte 2, 2 bytes)
    final idBrandBytes = memory.sublist(30, 32);
    final idBrand = _bytesToInt(idBrandBytes, endian: Endian.big);

    // Parse firstColour from bytes 32-35 (Page 8, byte 0, 4 bytes)
    final firstColourBytes = memory.sublist(32, 36);
    final firstColour = List<int>.unmodifiable(firstColourBytes);

    // Parse measurementValue from bytes 36-38 (Page 9, byte 0, 3 bytes)
    final measurementValueBytes = memory.sublist(36, 39);
    final measurementValue =
        _bytesToInt(measurementValueBytes, endian: Endian.big);

    // Parse measurementID from bytes 39-39 (Page 9, byte 3, 1 bytes)
    final measurementIDBytes = memory.sublist(39, 40);
    final measurementID = _bytesToInt(measurementIDBytes, endian: Endian.big);

    // Parse nozzleTemperatureMin from bytes 40-41 (Page 10, byte 0, 2 bytes)
    final nozzleTemperatureMinBytes = memory.sublist(40, 42);
    final nozzleTemperatureMin =
        _bytesToInt(nozzleTemperatureMinBytes, endian: Endian.big);

    // Parse nozzleTemperatureMax from bytes 42-43 (Page 10, byte 2, 2 bytes)
    final nozzleTemperatureMaxBytes = memory.sublist(42, 44);
    final nozzleTemperatureMax =
        _bytesToInt(nozzleTemperatureMaxBytes, endian: Endian.big);

    // Parse dryTemp from bytes 44-44 (Page 11, byte 0, 1 bytes)
    final dryTempBytes = memory.sublist(44, 45);
    final dryTemp = _bytesToInt(dryTempBytes, endian: Endian.big);

    // Parse dryTime from bytes 45-45 (Page 11, byte 1, 1 bytes)
    final dryTimeBytes = memory.sublist(45, 46);
    final dryTime = _bytesToInt(dryTimeBytes, endian: Endian.big);

    // Parse bedTemperatureMin from bytes 46-46 (Page 11, byte 2, 1 bytes)
    final bedTemperatureMinBytes = memory.sublist(46, 47);
    final bedTemperatureMin =
        _bytesToInt(bedTemperatureMinBytes, endian: Endian.big);

    // Parse bedTemperatureMax from bytes 47-47 (Page 11, byte 3, 1 bytes)
    final bedTemperatureMaxBytes = memory.sublist(47, 48);
    final bedTemperatureMax =
        _bytesToInt(bedTemperatureMaxBytes, endian: Endian.big);

    // Parse twinTagTimestamp from bytes 48-51 (Page 12, byte 0, 4 bytes)
    final twinTagTimestampBytes = memory.sublist(48, 52);
    final twinTagTimestamp =
        _bytesToInt(twinTagTimestampBytes, endian: Endian.big);

    // Parse color2 from bytes 52-54 (Page 13, byte 0, 3 bytes)
    final color2Bytes = memory.sublist(52, 55);
    final color2 = List<int>.unmodifiable(color2Bytes);

    // Parse color3 from bytes 56-58 (Page 14, byte 0, 3 bytes)
    final color3Bytes = memory.sublist(56, 59);
    final color3 = List<int>.unmodifiable(color3Bytes);

    // Parse tdValue from bytes 60-61 (Page 15, byte 0, 2 bytes)
    final tdValueBytes = memory.sublist(60, 62);
    final tdValue = _bytesToInt(tdValueBytes, endian: Endian.big);

    // Parse metadata from bytes 64-95 (Page 16, byte 0, 32 bytes)
    final metadataBytes = memory.sublist(64, 96);
    final metadata = List<int>.unmodifiable(metadataBytes);

    return TigerTag(
      tigerTagID: tigerTagID,
      productID: productID,
      materialID: materialID,
      firstVisualAspectID: firstVisualAspectID,
      secondVisualAspectID: secondVisualAspectID,
      idType: idType,
      diameterID: diameterID,
      idBrand: idBrand,
      firstColour: firstColour,
      measurementValue: measurementValue,
      measurementID: measurementID,
      nozzleTemperatureMin: nozzleTemperatureMin,
      nozzleTemperatureMax: nozzleTemperatureMax,
      dryTemp: dryTemp,
      dryTime: dryTime,
      bedTemperatureMin: bedTemperatureMin,
      bedTemperatureMax: bedTemperatureMax,
      twinTagTimestamp: twinTagTimestamp,
      color2: color2,
      color3: color3,
      tdValue: tdValue,
      metadata: metadata,
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
int _bytesToInt(List<int> bytes, {Endian endian = Endian.little}) {
  if (bytes.isEmpty) return 0;
  try {
    if (endian == Endian.little) {
      // Little endian: LSB first, calculate from left to right
      int value = 0;
      for (int i = 0; i < bytes.length; i++) {
        value += bytes[i] * (1 << (i * 8));
      }
      return value;
    } else {
      // Big endian: MSB first, calculate from right to left
      int value = 0;
      for (int i = 0; i < bytes.length; i++) {
        value = (value << 8) + bytes[i];
      }
      return value;
    }
  } catch (e) {
    debugPrint('TigerTag: Error converting bytes to int: $e');
    return 0;
  }
}

/// Convert bytes to hex string
String _bytesToHex(List<int> bytes) {
  if (bytes.isEmpty) return '';
  return bytes
      .map((b) => b.toRadixString(16).padLeft(2, '0'))
      .join(':')
      .toUpperCase();
}
