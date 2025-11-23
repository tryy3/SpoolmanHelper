import 'package:flutter/foundation.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/nfc_manager_android.dart';
import 'package:nfc_manager_ndef/nfc_manager_ndef.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/tiger_tag.dart';

part 'rfid_scanner_provider.g.dart';

/// Represents the current state of the RFID scanner
enum RfidScannerStatus {
  idle,
  initializing,
  scanning,
  error,
}

/// Data class for scanned RFID tag information
@immutable
class RfidTagData {
  final String uid;
  final String tagType;
  final List<int>? rawMemory; // Raw memory bytes from the tag
  final Map<String, dynamic> tagInfo; // Additional tag information
  final TigerTag? tigerTag; // Parsed TigerTag data (if applicable)
  final DateTime scannedAt;

  const RfidTagData({
    required this.uid,
    required this.tagType,
    this.rawMemory,
    this.tagInfo = const {},
    this.tigerTag,
    required this.scannedAt,
  });

  @override
  String toString() {
    return 'RfidTagData(uid: $uid, type: $tagType, memorySize: ${rawMemory?.length ?? 0} bytes, tigerTag: ${tigerTag?.tigerTagID ?? "none"}, scannedAt: $scannedAt)';
  }
}

/// State class for the RFID scanner
@immutable
class RfidScannerState {
  final RfidScannerStatus status;
  final bool isNfcAvailable;
  final RfidTagData? lastScannedTag;
  final String? errorMessage;
  final List<RfidTagData> scannedTags;

  const RfidScannerState({
    this.status = RfidScannerStatus.idle,
    this.isNfcAvailable = false,
    this.lastScannedTag,
    this.errorMessage,
    this.scannedTags = const [],
  });

  RfidScannerState copyWith({
    RfidScannerStatus? status,
    bool? isNfcAvailable,
    RfidTagData? lastScannedTag,
    String? errorMessage,
    List<RfidTagData>? scannedTags,
  }) {
    return RfidScannerState(
      status: status ?? this.status,
      isNfcAvailable: isNfcAvailable ?? this.isNfcAvailable,
      lastScannedTag: lastScannedTag ?? this.lastScannedTag,
      errorMessage: errorMessage ?? this.errorMessage,
      scannedTags: scannedTags ?? this.scannedTags,
    );
  }
}

/// Provider for checking NFC availability
@riverpod
Future<bool> nfcAvailability(Ref ref) async {
  try {
    final availability = await NfcManager.instance.checkAvailability();
    return availability == NfcAvailability.enabled;
  } catch (e) {
    debugPrint('Error checking NFC availability: $e');
    return false;
  }
}

/// RFID Scanner Notifier for managing scanning state and operations
@riverpod
class RfidScanner extends _$RfidScanner {
  @override
  RfidScannerState build() {
    // Check NFC availability on initialization
    _checkNfcAvailability();
    return const RfidScannerState();
  }

  /// Check if NFC is available on this device
  Future<void> _checkNfcAvailability() async {
    try {
      final isAvailable = await NfcManager.instance.checkAvailability();
      state = state.copyWith(
          isNfcAvailable: isAvailable == NfcAvailability.enabled);
    } catch (e) {
      debugPrint('Error checking NFC availability: $e');
      state = state.copyWith(
        isNfcAvailable: false,
        errorMessage: 'Failed to check NFC availability: $e',
      );
    }
  }

  /// Start scanning for RFID tags
  Future<void> startScanning() async {
    if (!state.isNfcAvailable) {
      state = state.copyWith(
        status: RfidScannerStatus.error,
        errorMessage: 'NFC is not available on this device',
      );
      return;
    }

    try {
      state = state.copyWith(
        status: RfidScannerStatus.initializing,
        errorMessage: null,
      );

      await NfcManager.instance.startSession(
        pollingOptions: {NfcPollingOption.iso14443},
        onDiscovered: (NfcTag tag) async {
          debugPrint("tag discovered: $tag");
          _handleTagDiscovered(tag);
          debugPrint("Foobar");
        },
      );

      state = state.copyWith(status: RfidScannerStatus.scanning);
    } catch (e) {
      debugPrint('Error starting NFC session: $e');
      state = state.copyWith(
        status: RfidScannerStatus.error,
        errorMessage: 'Failed to start scanning: $e',
      );
    }
  }

  /// Stop scanning for RFID tags
  Future<void> stopScanning() async {
    try {
      await NfcManager.instance.stopSession();
      state = state.copyWith(status: RfidScannerStatus.idle);
    } catch (e) {
      debugPrint('Error stopping NFC session: $e');
      state = state.copyWith(
        status: RfidScannerStatus.error,
        errorMessage: 'Failed to stop scanning: $e',
      );
    }
  }

  /// Handle discovered NFC tag - Focus on reading raw TigerTag data
  void _handleTagDiscovered(NfcTag tag) async {
    try {
      debugPrint('=== TigerTag Discovered ===');

      final mifareUltraLight = MifareUltralightAndroid.from(tag);
      if (mifareUltraLight == null) {
        throw Exception('No Mifare Ultra Light found');
      }

      // Read raw memory from MIFARE Ultralight tag
      final rawMemory = await _readMifareUltralightMemory(mifareUltraLight);
      if (rawMemory == null || rawMemory.isEmpty) {
        throw Exception('Failed to read MIFARE Ultralight memory');
      }

      debugPrint('Read ${rawMemory.length} bytes from MIFARE Ultralight');

      // Parse TigerTag from raw memory
      final tigerTag = TigerTag.parse(rawMemory);
      if (tigerTag == null) {
        throw Exception('Failed to parse TigerTag data');
      }

      debugPrint('TigerTag parsed successfully: ID=${tigerTag.tigerTagID}');

      // Get tag UID and basic info
      String uid = 'Unknown';
      final tagType = 'MIFARE Ultralight';
      final tagInfo = <String, dynamic>{
        'mifare_type': mifareUltraLight.type.toString(),
        'memory_size': rawMemory.length,
      };

      // Try to get UID from the tag data (first 4 pages usually contain UID)
      if (rawMemory.length >= 7) {
        // UID is typically in the first 7 bytes (pages 0-1)
        final uidBytes = rawMemory.sublist(0, 7);
        uid = _bytesToHex(uidBytes);
      }

      // Check for NDEF (optional, TigerTag might not use it)
      final ndef = Ndef.from(tag);
      if (ndef != null) {
        debugPrint(
            'NDEF support detected (but TigerTag uses proprietary format)');
        tagInfo['ndef_available'] = true;
      }

      debugPrint('==================');

      // Create tag data with all information
      final tagData = RfidTagData(
        uid: uid,
        tagType: tagType,
        rawMemory: rawMemory,
        tagInfo: tagInfo,
        tigerTag: tigerTag,
        scannedAt: DateTime.now(),
      );

      // Update state with the new tag
      final updatedTags = [...state.scannedTags, tagData];
      state = state.copyWith(
        lastScannedTag: tagData,
        scannedTags: updatedTags,
      );

      debugPrint(
          'TigerTag successfully processed: UID=$uid, ID=${tigerTag.tigerTagID}');
      debugPrint("Foo");
      stopScanning();
    } catch (e, stackTrace) {
      debugPrint('Error handling tag: $e');
      debugPrint('Stack trace: $stackTrace');
      state = state.copyWith(
        status: RfidScannerStatus.error,
        errorMessage: 'Failed to read TigerTag: $e',
      );
    }
  }

  Future<List<int>?> _readMifareUltralightMemory(
      MifareUltralightAndroid mifareUltraLight) async {
    try {
      List<int> memory = [];
      for (int page = 0; page < 40; page += 4) {
        final data = await mifareUltraLight.readPages(pageOffset: page);
        if (data.isEmpty) break;

        memory.addAll(data);
        if (data.length < 16) break;
      }
      return memory.isNotEmpty ? memory : null;
    } catch (e) {
      debugPrint('Error reading Mifare Ultra Light memory: $e');
      return null;
    }
  }

  /// Convert bytes to hex string (for UID display)
  String _bytesToHex(List<int> bytes) {
    if (bytes.isEmpty) return '';
    return bytes
        .map((b) => b.toRadixString(16).padLeft(2, '0'))
        .join(':')
        .toUpperCase();
  }

  /// Clear all scanned tags
  void clearScannedTags() {
    state = state.copyWith(
      scannedTags: [],
      lastScannedTag: null,
    );
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
