// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'material_lookup_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for the MaterialLookupService singleton

@ProviderFor(materialLookupService)
const materialLookupServiceProvider = MaterialLookupServiceProvider._();

/// Provider for the MaterialLookupService singleton

final class MaterialLookupServiceProvider extends $FunctionalProvider<
    MaterialLookupService,
    MaterialLookupService,
    MaterialLookupService> with $Provider<MaterialLookupService> {
  /// Provider for the MaterialLookupService singleton
  const MaterialLookupServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'materialLookupServiceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$materialLookupServiceHash();

  @$internal
  @override
  $ProviderElement<MaterialLookupService> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MaterialLookupService create(Ref ref) {
    return materialLookupService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MaterialLookupService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MaterialLookupService>(value),
    );
  }
}

String _$materialLookupServiceHash() =>
    r'6a4efb60ed2988a5f608485ab836342d7d704087';

/// Provider for initializing brand data on app startup

@ProviderFor(initializeMaterials)
const initializeMaterialsProvider = InitializeMaterialsProvider._();

/// Provider for initializing brand data on app startup

final class InitializeMaterialsProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Provider for initializing brand data on app startup
  const InitializeMaterialsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'initializeMaterialsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$initializeMaterialsHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return initializeMaterials(ref);
  }
}

String _$initializeMaterialsHash() =>
    r'd08f0d45e95b9f4c29d08926f1c029eb2a791920';

/// Notifier for managing material sync state

@ProviderFor(MaterialSync)
const materialSyncProvider = MaterialSyncProvider._();

/// Notifier for managing material sync state
final class MaterialSyncProvider
    extends $NotifierProvider<MaterialSync, MaterialSyncState> {
  /// Notifier for managing material sync state
  const MaterialSyncProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'materialSyncProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$materialSyncHash();

  @$internal
  @override
  MaterialSync create() => MaterialSync();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MaterialSyncState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MaterialSyncState>(value),
    );
  }
}

String _$materialSyncHash() => r'1b045bfcc66097228dcbaf879364b1046680aca2';

/// Notifier for managing material sync state

abstract class _$MaterialSync extends $Notifier<MaterialSyncState> {
  MaterialSyncState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<MaterialSyncState, MaterialSyncState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<MaterialSyncState, MaterialSyncState>,
        MaterialSyncState,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
