// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$serverUrlHash() => r'4b8d8b040caf7869184f21c27fd8fc19805965b9';

/// Provider for the server URL
///
/// Copied from [serverUrl].
@ProviderFor(serverUrl)
final serverUrlProvider = Provider<String>.internal(
  serverUrl,
  name: r'serverUrlProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$serverUrlHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ServerUrlRef = ProviderRef<String>;
String _$clientHash() => r'99996324ab41e9b14d9fcded4dd6a9ddb5a71287';

/// Provider for the Serverpod client
/// This replaces the global client variable with a properly managed provider
///
/// Copied from [client].
@ProviderFor(client)
final clientProvider = Provider<Client>.internal(
  client,
  name: r'clientProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$clientHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ClientRef = ProviderRef<Client>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
