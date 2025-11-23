// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'id_type_lookup_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for the IdTypeLookupService singleton

@ProviderFor(idTypeLookupService)
const idTypeLookupServiceProvider = IdTypeLookupServiceProvider._();

/// Provider for the IdTypeLookupService singleton

final class IdTypeLookupServiceProvider extends $FunctionalProvider<
    IdTypeLookupService,
    IdTypeLookupService,
    IdTypeLookupService> with $Provider<IdTypeLookupService> {
  /// Provider for the IdTypeLookupService singleton
  const IdTypeLookupServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'idTypeLookupServiceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$idTypeLookupServiceHash();

  @$internal
  @override
  $ProviderElement<IdTypeLookupService> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  IdTypeLookupService create(Ref ref) {
    return idTypeLookupService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IdTypeLookupService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IdTypeLookupService>(value),
    );
  }
}

String _$idTypeLookupServiceHash() =>
    r'81c99d2951357b052c0d94781a9dc2a8d7320123';

/// Provider for initializing brand data on app startup

@ProviderFor(initializeIdTypes)
const initializeIdTypesProvider = InitializeIdTypesProvider._();

/// Provider for initializing brand data on app startup

final class InitializeIdTypesProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Provider for initializing brand data on app startup
  const InitializeIdTypesProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'initializeIdTypesProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$initializeIdTypesHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return initializeIdTypes(ref);
  }
}

String _$initializeIdTypesHash() => r'1d5f3963eb5210617ff0634d4afa665940055b87';

/// Notifier for managing idType sync state

@ProviderFor(IdTypeSync)
const idTypeSyncProvider = IdTypeSyncProvider._();

/// Notifier for managing idType sync state
final class IdTypeSyncProvider
    extends $NotifierProvider<IdTypeSync, IdTypeSyncState> {
  /// Notifier for managing idType sync state
  const IdTypeSyncProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'idTypeSyncProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$idTypeSyncHash();

  @$internal
  @override
  IdTypeSync create() => IdTypeSync();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IdTypeSyncState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IdTypeSyncState>(value),
    );
  }
}

String _$idTypeSyncHash() => r'1b2ee0b5e858f2f73231241493d0b8c98d5b08f0';

/// Notifier for managing idType sync state

abstract class _$IdTypeSync extends $Notifier<IdTypeSyncState> {
  IdTypeSyncState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<IdTypeSyncState, IdTypeSyncState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<IdTypeSyncState, IdTypeSyncState>,
        IdTypeSyncState,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
