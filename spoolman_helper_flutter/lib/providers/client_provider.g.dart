// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for the server URL

@ProviderFor(serverUrl)
const serverUrlProvider = ServerUrlProvider._();

/// Provider for the server URL

final class ServerUrlProvider
    extends $FunctionalProvider<String, String, String> with $Provider<String> {
  /// Provider for the server URL
  const ServerUrlProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'serverUrlProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$serverUrlHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return serverUrl(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$serverUrlHash() => r'01d42cc3bd93c909a5eab25a0678a78333d2d019';

/// Provider for the Serverpod client
/// This replaces the global client variable with a properly managed provider

@ProviderFor(client)
const clientProvider = ClientProvider._();

/// Provider for the Serverpod client
/// This replaces the global client variable with a properly managed provider

final class ClientProvider extends $FunctionalProvider<Client, Client, Client>
    with $Provider<Client> {
  /// Provider for the Serverpod client
  /// This replaces the global client variable with a properly managed provider
  const ClientProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'clientProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$clientHash();

  @$internal
  @override
  $ProviderElement<Client> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Client create(Ref ref) {
    return client(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Client value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Client>(value),
    );
  }
}

String _$clientHash() => r'b8503c8b0b6cada1161fcfff97c271574674fdc3';
