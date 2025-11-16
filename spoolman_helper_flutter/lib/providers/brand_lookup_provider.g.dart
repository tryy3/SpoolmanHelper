// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_lookup_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for the BrandLookupService singleton

@ProviderFor(brandLookupService)
const brandLookupServiceProvider = BrandLookupServiceProvider._();

/// Provider for the BrandLookupService singleton

final class BrandLookupServiceProvider extends $FunctionalProvider<
    BrandLookupService,
    BrandLookupService,
    BrandLookupService> with $Provider<BrandLookupService> {
  /// Provider for the BrandLookupService singleton
  const BrandLookupServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'brandLookupServiceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$brandLookupServiceHash();

  @$internal
  @override
  $ProviderElement<BrandLookupService> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BrandLookupService create(Ref ref) {
    return brandLookupService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BrandLookupService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BrandLookupService>(value),
    );
  }
}

String _$brandLookupServiceHash() =>
    r'0a03056ea6c10249f5359eb4ded95b2f1b7df91b';

/// Provider for initializing brand data on app startup

@ProviderFor(initializeBrands)
const initializeBrandsProvider = InitializeBrandsProvider._();

/// Provider for initializing brand data on app startup

final class InitializeBrandsProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Provider for initializing brand data on app startup
  const InitializeBrandsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'initializeBrandsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$initializeBrandsHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return initializeBrands(ref);
  }
}

String _$initializeBrandsHash() => r'cdc5542706c2406fffdde83c86a2e27137e3d165';

/// Notifier for managing brand sync state

@ProviderFor(BrandSync)
const brandSyncProvider = BrandSyncProvider._();

/// Notifier for managing brand sync state
final class BrandSyncProvider
    extends $NotifierProvider<BrandSync, BrandSyncState> {
  /// Notifier for managing brand sync state
  const BrandSyncProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'brandSyncProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$brandSyncHash();

  @$internal
  @override
  BrandSync create() => BrandSync();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BrandSyncState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BrandSyncState>(value),
    );
  }
}

String _$brandSyncHash() => r'80f6a413131923f96d4b7cf6a25fbd4193a8bfd0';

/// Notifier for managing brand sync state

abstract class _$BrandSync extends $Notifier<BrandSyncState> {
  BrandSyncState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<BrandSyncState, BrandSyncState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<BrandSyncState, BrandSyncState>,
        BrandSyncState,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
