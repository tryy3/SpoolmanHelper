// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_initialization_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Combined provider for initializing all app data on startup
///
/// This orchestrates the initialization of all lookup services
/// (brands, materials, etc.) in parallel for optimal performance.

@ProviderFor(initializeApp)
const initializeAppProvider = InitializeAppProvider._();

/// Combined provider for initializing all app data on startup
///
/// This orchestrates the initialization of all lookup services
/// (brands, materials, etc.) in parallel for optimal performance.

final class InitializeAppProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Combined provider for initializing all app data on startup
  ///
  /// This orchestrates the initialization of all lookup services
  /// (brands, materials, etc.) in parallel for optimal performance.
  const InitializeAppProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'initializeAppProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$initializeAppHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return initializeApp(ref);
  }
}

String _$initializeAppHash() => r'ff9b4ee3120e03b3cd1078cf404ba1fd96d68efd';
