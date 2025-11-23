// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diameter_lookup_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for the DiameterLookupService singleton

@ProviderFor(diameterLookupService)
const diameterLookupServiceProvider = DiameterLookupServiceProvider._();

/// Provider for the DiameterLookupService singleton

final class DiameterLookupServiceProvider extends $FunctionalProvider<
    DiameterLookupService,
    DiameterLookupService,
    DiameterLookupService> with $Provider<DiameterLookupService> {
  /// Provider for the DiameterLookupService singleton
  const DiameterLookupServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'diameterLookupServiceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$diameterLookupServiceHash();

  @$internal
  @override
  $ProviderElement<DiameterLookupService> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DiameterLookupService create(Ref ref) {
    return diameterLookupService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DiameterLookupService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DiameterLookupService>(value),
    );
  }
}

String _$diameterLookupServiceHash() =>
    r'b931e9a8cbc431f62e4bb6f84beac4cdf121f344';

/// Provider for initializing brand data on app startup

@ProviderFor(initializeDiameters)
const initializeDiametersProvider = InitializeDiametersProvider._();

/// Provider for initializing brand data on app startup

final class InitializeDiametersProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Provider for initializing brand data on app startup
  const InitializeDiametersProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'initializeDiametersProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$initializeDiametersHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return initializeDiameters(ref);
  }
}

String _$initializeDiametersHash() =>
    r'4f53a681e42373bbc97858347a0e6b7f1f7877c9';

/// Notifier for managing diameter sync state

@ProviderFor(DiameterSync)
const diameterSyncProvider = DiameterSyncProvider._();

/// Notifier for managing diameter sync state
final class DiameterSyncProvider
    extends $NotifierProvider<DiameterSync, DiameterSyncState> {
  /// Notifier for managing diameter sync state
  const DiameterSyncProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'diameterSyncProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$diameterSyncHash();

  @$internal
  @override
  DiameterSync create() => DiameterSync();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DiameterSyncState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DiameterSyncState>(value),
    );
  }
}

String _$diameterSyncHash() => r'14d21ad140b45c9549d1ea8491b803bd9a475568';

/// Notifier for managing diameter sync state

abstract class _$DiameterSync extends $Notifier<DiameterSyncState> {
  DiameterSyncState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<DiameterSyncState, DiameterSyncState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<DiameterSyncState, DiameterSyncState>,
        DiameterSyncState,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
