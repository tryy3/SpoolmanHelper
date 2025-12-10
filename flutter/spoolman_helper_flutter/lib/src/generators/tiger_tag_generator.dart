import 'package:analyzer/dart/element/element2.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import '../../annotations/tiger_tag_annotations.dart';

/// Generator for TigerTag classes
class TigerTagGenerator extends GeneratorForAnnotation<TigerTagClass> {
  @override
  String generateForAnnotatedElement(
    Element2 element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element is! InterfaceElement2) {
      throw InvalidGenerationSourceError(
        'Generator cannot target `${element.displayName}`.',
        todo:
            'Remove the TigerTagClass annotation from `${element.displayName}`.',
        element: element,
      );
    }

    final className = element.name3 ?? element.displayName;
    final fields = <_FieldInfo>[];

    // Collect all fields with TigerTagField annotation
    for (final field in element.fields2) {
      final tigerTagFieldAnnotation =
          const TypeChecker.typeNamed(TigerTagField).firstAnnotationOf(field);

      if (tigerTagFieldAnnotation != null) {
        final reader = ConstantReader(tigerTagFieldAnnotation);
        final fieldType = field.type;
        final dartType = fieldType is InterfaceType
            ? (fieldType.element3.name3 ?? 'dynamic')
            : fieldType.getDisplayString();

        final fieldInfo = _FieldInfo(
          name: field.name3 ?? 'unknown',
          dartType: dartType,
          page: reader.read('page').intValue,
          startByte: reader.read('startByte').intValue,
          size: reader.read('size').intValue,
          type: _parseFieldType(
              reader.read('type').objectValue.getField('index')!.toIntValue()!),
        );
        fields.add(fieldInfo);
      }
    }

    if (fields.isEmpty) {
      throw InvalidGenerationSourceError(
        'No fields with @TigerTagField annotation found in `$className`.',
        todo: 'Add @TigerTagField annotations to fields in `$className`.',
        element: element,
      );
    }

    return _generateCode(className, fields);
  }

  TigerTagFieldType _parseFieldType(int index) {
    return TigerTagFieldType.values[index];
  }

  String _generateCode(String className, List<_FieldInfo> fields) {
    final buffer = StringBuffer();

    // Note: The 'part of' directive is added by source_gen:combining_builder

    // Calculate max byte position needed
    int maxByte = 0;
    for (final field in fields) {
      final byteEnd = (field.page * 4) + field.startByte + field.size;
      if (byteEnd > maxByte) maxByte = byteEnd;
    }

    // Generate parse method
    buffer.writeln('/// Generated parse method for $className');
    buffer.writeln('$className? _\$parse$className(List<int> memory) {');
    buffer.writeln('  try {');
    buffer.writeln('    if (memory.length < $maxByte) {');
    buffer.writeln('      debugPrint(');
    buffer.writeln(
        '          \'TigerTag: Memory too short (\${memory.length} bytes, need at least $maxByte)\');');
    buffer.writeln('      return null;');
    buffer.writeln('    }');
    buffer.writeln('');

    // Generate parsing code for each field
    for (final field in fields) {
      final byteStart = (field.page * 4) + field.startByte;
      final byteEnd = byteStart + field.size;

      buffer.writeln(
          '    // Parse ${field.name} from bytes $byteStart-${byteEnd - 1} (Page ${field.page}, byte ${field.startByte}, ${field.size} bytes)');

      switch (field.type) {
        case TigerTagFieldType.bigEndianInt:
          buffer.writeln(
              '    final ${field.name}Bytes = memory.sublist($byteStart, $byteEnd);');
          buffer.writeln(
              '    final ${field.name} = _bytesToInt(${field.name}Bytes, endian: Endian.big);');
          break;
        case TigerTagFieldType.littleEndianInt:
          buffer.writeln(
              '    final ${field.name}Bytes = memory.sublist($byteStart, $byteEnd);');
          buffer.writeln(
              '    final ${field.name} = _bytesToInt(${field.name}Bytes, endian: Endian.little);');
          break;
        case TigerTagFieldType.hexString:
          buffer.writeln(
              '    final ${field.name}Bytes = memory.sublist($byteStart, $byteEnd);');
          buffer.writeln(
              '    final ${field.name} = _bytesToHex(${field.name}Bytes);');
          break;
        case TigerTagFieldType.bytes:
          buffer.writeln(
              '    final ${field.name}Bytes = memory.sublist($byteStart, $byteEnd);');
          buffer.writeln(
              '    final ${field.name} = List<int>.unmodifiable(${field.name}Bytes);');
          break;
        case TigerTagFieldType.string:
          buffer.writeln(
              '    final ${field.name}Bytes = memory.sublist($byteStart, $byteEnd);');
          buffer.writeln(
              '    final ${field.name} = String.fromCharCodes(${field.name}Bytes);');
          break;
      }
      buffer.writeln('');
    }

    // Generate return statement
    buffer.writeln('    return $className(');
    for (final field in fields) {
      buffer.writeln('      ${field.name}: ${field.name},');
    }
    buffer.writeln('      rawMemory: List.unmodifiable(memory),');
    buffer.writeln('      parsedAt: DateTime.now(),');
    buffer.writeln('    );');
    buffer.writeln('  } catch (e, stackTrace) {');
    buffer.writeln('    debugPrint(\'TigerTag: Error parsing tag: \$e\');');
    buffer.writeln('    debugPrint(\'TigerTag: Stack trace: \$stackTrace\');');
    buffer.writeln('    return null;');
    buffer.writeln('  }');
    buffer.writeln('}');
    buffer.writeln('');

    // Generate helper methods
    buffer.writeln('/// Convert bytes to integer (binary format)');
    buffer.writeln(
        'int _bytesToInt(List<int> bytes, {Endian endian = Endian.little}) {');
    buffer.writeln('  if (bytes.isEmpty) return 0;');
    buffer.writeln('  try {');
    buffer.writeln('    if (endian == Endian.little) {');
    buffer.writeln(
        '      // Little endian: LSB first, calculate from left to right');
    buffer.writeln('      int value = 0;');
    buffer.writeln('      for (int i = 0; i < bytes.length; i++) {');
    buffer.writeln('        value += bytes[i] * (1 << (i * 8));');
    buffer.writeln('      }');
    buffer.writeln('      return value;');
    buffer.writeln('    } else {');
    buffer.writeln(
        '      // Big endian: MSB first, calculate from right to left');
    buffer.writeln('      int value = 0;');
    buffer.writeln('      for (int i = 0; i < bytes.length; i++) {');
    buffer.writeln('        value = (value << 8) + bytes[i];');
    buffer.writeln('      }');
    buffer.writeln('      return value;');
    buffer.writeln('    }');
    buffer.writeln('  } catch (e) {');
    buffer.writeln(
        '    debugPrint(\'TigerTag: Error converting bytes to int: \$e\');');
    buffer.writeln('    return 0;');
    buffer.writeln('  }');
    buffer.writeln('}');
    buffer.writeln('');

    buffer.writeln('/// Convert bytes to hex string');
    buffer.writeln('String _bytesToHex(List<int> bytes) {');
    buffer.writeln('  if (bytes.isEmpty) return \'\';');
    buffer.writeln('  return bytes');
    buffer.writeln('      .map((b) => b.toRadixString(16).padLeft(2, \'0\'))');
    buffer.writeln('      .join(\':\')');
    buffer.writeln('      .toUpperCase();');
    buffer.writeln('}');

    return buffer.toString();
  }
}

class _FieldInfo {
  final String name;
  final String dartType;
  final int page;
  final int startByte;
  final int size;
  final TigerTagFieldType type;

  _FieldInfo({
    required this.name,
    required this.dartType,
    required this.page,
    required this.startByte,
    required this.size,
    required this.type,
  });
}

/// Builder factory for build_runner
Builder tigerTagGeneratorFactory(BuilderOptions options) =>
    SharedPartBuilder([TigerTagGenerator()], 'tiger_tag',
        allowSyntaxErrors: false);
