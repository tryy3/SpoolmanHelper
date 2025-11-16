/// TigerTag field definitions
///
/// This file defines the structure of TigerTag data.
/// Fields are defined with:
/// - name: Property name
/// - type: Data type (int, String, List<int>)
/// - page: Page number (1 page = 4 bytes, starting from page 0)
/// - startByte: Byte offset within the page (0-3)
/// - size: Number of bytes to read
///
/// The generator will convert page/startByte to actual byte positions.
///
/// Format: (name, type, page, startByte, size)
const List<TigerTagFieldDef> tigerTagFields = [
  // Page 4 (bytes 16-19)
  TigerTagFieldDef('tigerTagID', TigerTagFieldType.int, 4, 0, 4),

  // Page 5 (bytes 20-23)
  TigerTagFieldDef('productID', TigerTagFieldType.string, 5, 0, 4),

  // Page 6 (bytes 24-27)
  TigerTagFieldDef('materialID', TigerTagFieldType.int, 6, 0, 2),
  TigerTagFieldDef('firstVisualAspectID', TigerTagFieldType.int, 6, 2, 1),
  TigerTagFieldDef('secondVisualAspectID', TigerTagFieldType.int, 6, 3, 1),

  // Page 7 (bytes 28-31)
  TigerTagFieldDef('idType', TigerTagFieldType.int, 7, 0, 1),
  TigerTagFieldDef('diameterID', TigerTagFieldType.int, 7, 1, 1),
  TigerTagFieldDef('firstColour', TigerTagFieldType.listInt, 7, 2, 4),
  TigerTagFieldDef('idBrand', TigerTagFieldType.int, 7, 2, 2),
  TigerTagFieldDef('measurementID', TigerTagFieldType.int, 7, 3, 1),
];

/// Field type enum
enum TigerTagFieldType {
  int,
  string, // Hex string
  listInt, // List of integers (bytes)
}

/// Field definition class
class TigerTagFieldDef {
  final String name;
  final TigerTagFieldType type;
  final int page; // Page number (1 page = 4 bytes)
  final int startByte; // Byte offset within page (0-3)
  final int size; // Number of bytes

  const TigerTagFieldDef(
    this.name,
    this.type,
    this.page,
    this.startByte,
    this.size,
  );

  /// Calculate the actual byte position from page and startByte
  int get bytePosition => (page * 4) + startByte;

  /// Get the byte range [start, end)
  int get byteStart => bytePosition;
  int get byteEnd => bytePosition + size;
}
