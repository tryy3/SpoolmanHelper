#!/usr/bin/env dart

/// Code generator for TigerTag class
///
/// Run with: dart run tool/generate_tiger_tag.dart

import 'dart:io';

void main() {
  print('Generating TigerTag class...');

  final definitionsFile = File('lib/models/tiger_tag_fields.def.dart');
  final outputFile = File('lib/models/tiger_tag.g.dart');

  if (!definitionsFile.existsSync()) {
    print('Error: ${definitionsFile.path} not found');
    exit(1);
  }

  // Read the definitions file
  final definitionsContent = definitionsFile.readAsStringSync();

  // Parse field definitions (simple regex-based parsing)
  final fieldRegex = RegExp(
    r"TigerTagFieldDef\('([^']+)',\s*TigerTagFieldType\.(\w+),\s*(\d+),\s*(\d+),\s*(\d+)\)",
  );

  final fields = <Map<String, dynamic>>[];
  for (final match in fieldRegex.allMatches(definitionsContent)) {
    fields.add({
      'name': match.group(1)!,
      'type': match.group(2)!,
      'page': int.parse(match.group(3)!),
      'startByte': int.parse(match.group(4)!),
      'size': int.parse(match.group(5)!),
    });
  }

  // Generate the code
  final buffer = StringBuffer();
  buffer.writeln('// GENERATED CODE - DO NOT MODIFY BY HAND');
  buffer.writeln('// Run: dart run tool/generate_tiger_tag.dart');
  buffer.writeln(
      '// To modify fields, edit lib/models/tiger_tag_fields.def.dart');
  buffer.writeln('');
  buffer.writeln("import 'dart:convert';");
  buffer.writeln("import 'dart:typed_data';");
  buffer.writeln("import 'package:flutter/foundation.dart';");
  buffer.writeln('');
  buffer.writeln("part of 'tiger_tag.dart';");
  buffer.writeln('');

  // Generate properties as part of the class
  buffer.writeln('// Properties are documented like this:');
  buffer.writeln(
      '// <description/Property name> - <byte size> - <type> - <stored at bytes> - <page> - <start byte>');
  buffer.writeln('// The page is based on TigerTag layout, 1 page = 4 bytes');
  buffer.writeln('');

  for (final field in fields) {
    final name = field['name'] as String;
    final type = field['type'] as String;
    final page = field['page'] as int;
    final startByte = field['startByte'] as int;
    final size = field['size'] as int;
    final byteStart = (page * 4) + startByte;
    final byteEnd = byteStart + size - 1;

    String dartType;
    switch (type) {
      case 'int':
        dartType = 'int';
        break;
      case 'string':
        dartType = 'String';
        break;
      case 'listInt':
        dartType = 'List<int>';
        break;
      default:
        dartType = 'dynamic';
    }

    buffer.writeln(
        '  /// $name - $size bytes - $dartType - bytes $byteStart-$byteEnd - Page $page - Byte $startByte');
    buffer.writeln('  final $dartType $name;');
    buffer.writeln('');
  }

  buffer
      .writeln('  /// Raw memory bytes from the tag (for debugging/reference)');
  buffer.writeln('  final List<int> rawMemory;');
  buffer.writeln('');
  buffer.writeln('  /// Timestamp when the tag was parsed');
  buffer.writeln('  final DateTime parsedAt;');
  buffer.writeln('');

  // Generate constructor
  buffer.writeln('  const TigerTag({');
  for (final field in fields) {
    buffer.writeln('    required this.${field['name']},');
  }
  buffer.writeln('    required this.rawMemory,');
  buffer.writeln('    required this.parsedAt,');
  buffer.writeln('  });');
  buffer.writeln('');

  // Generate parse method
  buffer.writeln('  /// Parse raw memory bytes into a TigerTag instance');
  buffer.writeln('  static TigerTag? parse(List<int> memory) {');
  buffer.writeln('    try {');

  // Calculate max byte position needed
  int maxByte = 0;
  for (final field in fields) {
    final page = field['page'] as int;
    final startByte = field['startByte'] as int;
    final size = field['size'] as int;
    final byteEnd = (page * 4) + startByte + size;
    if (byteEnd > maxByte) maxByte = byteEnd;
  }

  buffer.writeln('      if (memory.length < $maxByte) {');
  buffer.writeln('        debugPrint(');
  buffer.writeln(
      "            'TigerTag: Memory too short (\${memory.length} bytes, need at least $maxByte)');");
  buffer.writeln('        return null;');
  buffer.writeln('      }');
  buffer.writeln('');

  // Generate parsing code for each field
  for (final field in fields) {
    final name = field['name'] as String;
    final type = field['type'] as String;
    final page = field['page'] as int;
    final startByte = field['startByte'] as int;
    final size = field['size'] as int;
    final byteStart = (page * 4) + startByte;
    final byteEnd = byteStart + size;

    buffer.writeln(
        '      // Parse $name from bytes $byteStart-${byteEnd - 1} (Page $page, byte $startByte, $size bytes)');

    switch (type) {
      case 'int':
        buffer.writeln(
            '      final ${name}Bytes = memory.sublist($byteStart, $byteEnd);');
        buffer.writeln(
            '      final $name = _bytesToInt(${name}Bytes, endian: Endian.big);');
        break;
      case 'string':
        buffer.writeln(
            '      final ${name}Bytes = memory.sublist($byteStart, $byteEnd);');
        buffer.writeln('      final $name = _bytesToHex(${name}Bytes);');
        break;
      case 'listInt':
        buffer.writeln(
            '      final ${name}Bytes = memory.sublist($byteStart, $byteEnd);');
        buffer.writeln('      final $name = List.unmodifiable(${name}Bytes);');
        break;
    }
    buffer.writeln('');
  }

  // Generate return statement
  buffer.writeln('      return TigerTag(');
  for (final field in fields) {
    buffer.writeln('        ${field['name']}: ${field['name']},');
  }
  buffer.writeln('        rawMemory: List.unmodifiable(memory),');
  buffer.writeln('        parsedAt: DateTime.now(),');
  buffer.writeln('      );');
  buffer.writeln('    } catch (e, stackTrace) {');
  buffer.writeln("      debugPrint('TigerTag: Error parsing tag: \$e');");
  buffer.writeln("      debugPrint('TigerTag: Stack trace: \$stackTrace');");
  buffer.writeln('      return null;');
  buffer.writeln('    }');
  buffer.writeln('  }');
  buffer.writeln('');

  // Generate helper methods
  buffer.writeln('  /// Convert bytes to integer (binary format)');
  buffer.writeln(
      '  static int _bytesToInt(List<int> bytes, {Endian endian = Endian.little}) {');
  buffer.writeln('    if (bytes.isEmpty) return 0;');
  buffer.writeln('    try {');
  buffer.writeln('      final paddedBytes = List<int>.from(bytes);');
  buffer.writeln('      while (paddedBytes.length < 4) {');
  buffer.writeln('        paddedBytes.add(0);');
  buffer.writeln('      }');
  buffer.writeln('      final byteData = ByteData.view(');
  buffer
      .writeln('        Uint8List.fromList(paddedBytes.sublist(0, 4)).buffer,');
  buffer.writeln('      );');
  buffer.writeln('      return byteData.getInt32(0, endian);');
  buffer.writeln('    } catch (e) {');
  buffer.writeln(
      "      debugPrint('TigerTag: Error converting bytes to int: \$e');");
  buffer.writeln('      return 0;');
  buffer.writeln('    }');
  buffer.writeln('  }');
  buffer.writeln('');

  buffer.writeln('  /// Convert bytes to hex string');
  buffer.writeln('  static String _bytesToHex(List<int> bytes) {');
  buffer.writeln('    if (bytes.isEmpty) return \'\';');
  buffer.writeln('    return bytes');
  buffer.writeln("        .map((b) => b.toRadixString(16).padLeft(2, '0'))");
  buffer.writeln("        .join(':')");
  buffer.writeln('        .toUpperCase();');
  buffer.writeln('  }');
  buffer.writeln('');

  // Generate toString, ==, hashCode
  buffer.writeln('  @override');
  buffer.writeln('  String toString() {');
  buffer.writeln(
      '    return \'TigerTag(tigerTagID: \$tigerTagID, memorySize: \${rawMemory.length} bytes, parsedAt: \$parsedAt)\';');
  buffer.writeln('  }');
  buffer.writeln('');

  buffer.writeln('  @override');
  buffer.writeln('  bool operator ==(Object other) {');
  buffer.writeln('    if (identical(this, other)) return true;');
  buffer.writeln(
      '    return other is TigerTag && other.tigerTagID == tigerTagID;');
  buffer.writeln('  }');
  buffer.writeln('');

  buffer.writeln('  @override');
  buffer.writeln('  int get hashCode => tigerTagID.hashCode;');
  buffer.writeln('}');

  // Write the generated file
  outputFile.writeAsStringSync(buffer.toString());
  print('Generated: ${outputFile.path}');
  print('Generated ${fields.length} fields');
}
