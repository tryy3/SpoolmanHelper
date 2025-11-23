// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'measurement_unit_lookup_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for the MeasurementUnitLookupService singleton

@ProviderFor(measurementUnitLookupService)
const measurementUnitLookupServiceProvider =
    MeasurementUnitLookupServiceProvider._();

/// Provider for the MeasurementUnitLookupService singleton

final class MeasurementUnitLookupServiceProvider extends $FunctionalProvider<
    MeasurementUnitLookupService,
    MeasurementUnitLookupService,
    MeasurementUnitLookupService> with $Provider<MeasurementUnitLookupService> {
  /// Provider for the MeasurementUnitLookupService singleton
  const MeasurementUnitLookupServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'measurementUnitLookupServiceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$measurementUnitLookupServiceHash();

  @$internal
  @override
  $ProviderElement<MeasurementUnitLookupService> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MeasurementUnitLookupService create(Ref ref) {
    return measurementUnitLookupService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MeasurementUnitLookupService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MeasurementUnitLookupService>(value),
    );
  }
}

String _$measurementUnitLookupServiceHash() =>
    r'253ec5ec8f4dc862e4a6ed6484a2f25a35757ee1';

/// Provider for initializing brand data on app startup

@ProviderFor(initializeMeasurementUnits)
const initializeMeasurementUnitsProvider =
    InitializeMeasurementUnitsProvider._();

/// Provider for initializing brand data on app startup

final class InitializeMeasurementUnitsProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Provider for initializing brand data on app startup
  const InitializeMeasurementUnitsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'initializeMeasurementUnitsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$initializeMeasurementUnitsHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return initializeMeasurementUnits(ref);
  }
}

String _$initializeMeasurementUnitsHash() =>
    r'932b50841a2b16897af780b4fbf89f9903ed098f';

/// Notifier for managing measurementUnit sync state

@ProviderFor(MeasurementUnitSync)
const measurementUnitSyncProvider = MeasurementUnitSyncProvider._();

/// Notifier for managing measurementUnit sync state
final class MeasurementUnitSyncProvider
    extends $NotifierProvider<MeasurementUnitSync, MeasurementUnitSyncState> {
  /// Notifier for managing measurementUnit sync state
  const MeasurementUnitSyncProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'measurementUnitSyncProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$measurementUnitSyncHash();

  @$internal
  @override
  MeasurementUnitSync create() => MeasurementUnitSync();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MeasurementUnitSyncState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MeasurementUnitSyncState>(value),
    );
  }
}

String _$measurementUnitSyncHash() =>
    r'c26ffb65bf724fa8a35e86f47f15b2420345da9b';

/// Notifier for managing measurementUnit sync state

abstract class _$MeasurementUnitSync
    extends $Notifier<MeasurementUnitSyncState> {
  MeasurementUnitSyncState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<MeasurementUnitSyncState, MeasurementUnitSyncState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<MeasurementUnitSyncState, MeasurementUnitSyncState>,
        MeasurementUnitSyncState,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
