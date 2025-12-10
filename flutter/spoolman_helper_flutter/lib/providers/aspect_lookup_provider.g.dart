// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'aspect_lookup_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for the AspectLookupService singleton

@ProviderFor(aspectLookupService)
const aspectLookupServiceProvider = AspectLookupServiceProvider._();

/// Provider for the AspectLookupService singleton

final class AspectLookupServiceProvider extends $FunctionalProvider<
    AspectLookupService,
    AspectLookupService,
    AspectLookupService> with $Provider<AspectLookupService> {
  /// Provider for the AspectLookupService singleton
  const AspectLookupServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'aspectLookupServiceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$aspectLookupServiceHash();

  @$internal
  @override
  $ProviderElement<AspectLookupService> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AspectLookupService create(Ref ref) {
    return aspectLookupService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AspectLookupService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AspectLookupService>(value),
    );
  }
}

String _$aspectLookupServiceHash() =>
    r'04744ace3dfeabf404e1f5dbccce28fc9e6e1d8d';

/// Provider for initializing brand data on app startup

@ProviderFor(initializeAspects)
const initializeAspectsProvider = InitializeAspectsProvider._();

/// Provider for initializing brand data on app startup

final class InitializeAspectsProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Provider for initializing brand data on app startup
  const InitializeAspectsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'initializeAspectsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$initializeAspectsHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return initializeAspects(ref);
  }
}

String _$initializeAspectsHash() => r'b6c531dea4e05b27b5265414a280ed6a4b89f01a';

/// Notifier for managing aspect sync state

@ProviderFor(AspectSync)
const aspectSyncProvider = AspectSyncProvider._();

/// Notifier for managing aspect sync state
final class AspectSyncProvider
    extends $NotifierProvider<AspectSync, AspectSyncState> {
  /// Notifier for managing aspect sync state
  const AspectSyncProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'aspectSyncProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$aspectSyncHash();

  @$internal
  @override
  AspectSync create() => AspectSync();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AspectSyncState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AspectSyncState>(value),
    );
  }
}

String _$aspectSyncHash() => r'c850e981e54fe90fa66c9e58d12a09d0e35b016c';

/// Notifier for managing aspect sync state

abstract class _$AspectSync extends $Notifier<AspectSyncState> {
  AspectSyncState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AspectSyncState, AspectSyncState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AspectSyncState, AspectSyncState>,
        AspectSyncState,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
