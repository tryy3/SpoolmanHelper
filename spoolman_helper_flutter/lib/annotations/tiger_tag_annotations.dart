/// Annotations for TigerTag code generation
library;

/// Marks a class as a TigerTag that should have parsing code generated
class TigerTagClass {
  const TigerTagClass();
}

/// Marks a field for TigerTag parsing
///
/// [page] - Page number in the tag (1 page = 4 bytes)
/// [startByte] - Byte offset within the page (0-3)
/// [size] - Number of bytes to read
/// [type] - Type of data to parse
class TigerTagField {
  /// Page number (1 page = 4 bytes, starting from page 0)
  final int page;

  /// Byte offset within the page (0-3)
  final int startByte;

  /// Number of bytes to read
  final int size;

  /// Type of data to parse
  final TigerTagFieldType type;

  const TigerTagField({
    required this.page,
    required this.startByte,
    required this.size,
    required this.type,
  });

  /// Calculate the actual byte position from page and startByte
  int get bytePosition => (page * 4) + startByte;

  /// Get the byte range [start, end)
  int get byteStart => bytePosition;
  int get byteEnd => bytePosition + size;
}

/// Types of data that can be parsed from TigerTag fields
enum TigerTagFieldType {
  /// Integer value (big-endian)
  bigEndianInt,

  /// Little-endian integer value
  littleEndianInt,

  /// Hex string representation
  hexString,

  /// Raw bytes as List\<int\>
  bytes,
}
