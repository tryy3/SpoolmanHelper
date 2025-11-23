// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rfid_scanner_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for checking NFC availability

@ProviderFor(nfcAvailability)
const nfcAvailabilityProvider = NfcAvailabilityProvider._();

/// Provider for checking NFC availability

final class NfcAvailabilityProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Provider for checking NFC availability
  const NfcAvailabilityProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'nfcAvailabilityProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$nfcAvailabilityHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return nfcAvailability(ref);
  }
}

String _$nfcAvailabilityHash() => r'00227a66a8f94649d0beccdf29d594f850bbc873';

/// RFID Scanner Notifier for managing scanning state and operations

@ProviderFor(RfidScanner)
const rfidScannerProvider = RfidScannerProvider._();

/// RFID Scanner Notifier for managing scanning state and operations
final class RfidScannerProvider
    extends $NotifierProvider<RfidScanner, RfidScannerState> {
  /// RFID Scanner Notifier for managing scanning state and operations
  const RfidScannerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'rfidScannerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$rfidScannerHash();

  @$internal
  @override
  RfidScanner create() => RfidScanner();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RfidScannerState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RfidScannerState>(value),
    );
  }
}

String _$rfidScannerHash() => r'86eb5aafc685399bf60b882505cd4cc68015d489';

/// RFID Scanner Notifier for managing scanning state and operations

abstract class _$RfidScanner extends $Notifier<RfidScannerState> {
  RfidScannerState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<RfidScannerState, RfidScannerState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<RfidScannerState, RfidScannerState>,
        RfidScannerState,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
