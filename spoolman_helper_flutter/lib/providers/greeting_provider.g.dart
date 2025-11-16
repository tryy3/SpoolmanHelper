// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'greeting_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$greetingHash() => r'dc1c41b4d67216cfaa6565b7264f1513db535e1b';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Example async provider that demonstrates how to fetch data from the server
/// This provider will automatically handle loading, error, and data states
///
/// Copied from [greeting].
@ProviderFor(greeting)
const greetingProvider = GreetingFamily();

/// Example async provider that demonstrates how to fetch data from the server
/// This provider will automatically handle loading, error, and data states
///
/// Copied from [greeting].
class GreetingFamily extends Family<AsyncValue<Greeting>> {
  /// Example async provider that demonstrates how to fetch data from the server
  /// This provider will automatically handle loading, error, and data states
  ///
  /// Copied from [greeting].
  const GreetingFamily();

  /// Example async provider that demonstrates how to fetch data from the server
  /// This provider will automatically handle loading, error, and data states
  ///
  /// Copied from [greeting].
  GreetingProvider call(
    String name,
  ) {
    return GreetingProvider(
      name,
    );
  }

  @override
  GreetingProvider getProviderOverride(
    covariant GreetingProvider provider,
  ) {
    return call(
      provider.name,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'greetingProvider';
}

/// Example async provider that demonstrates how to fetch data from the server
/// This provider will automatically handle loading, error, and data states
///
/// Copied from [greeting].
class GreetingProvider extends AutoDisposeFutureProvider<Greeting> {
  /// Example async provider that demonstrates how to fetch data from the server
  /// This provider will automatically handle loading, error, and data states
  ///
  /// Copied from [greeting].
  GreetingProvider(
    String name,
  ) : this._internal(
          (ref) => greeting(
            ref as GreetingRef,
            name,
          ),
          from: greetingProvider,
          name: r'greetingProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$greetingHash,
          dependencies: GreetingFamily._dependencies,
          allTransitiveDependencies: GreetingFamily._allTransitiveDependencies,
          name: name,
        );

  GreetingProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.name,
  }) : super.internal();

  final String name;

  @override
  Override overrideWith(
    FutureOr<Greeting> Function(GreetingRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GreetingProvider._internal(
        (ref) => create(ref as GreetingRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        name: name,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Greeting> createElement() {
    return _GreetingProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GreetingProvider && other.name == name;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, name.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GreetingRef on AutoDisposeFutureProviderRef<Greeting> {
  /// The parameter `name` of this provider.
  String get name;
}

class _GreetingProviderElement
    extends AutoDisposeFutureProviderElement<Greeting> with GreetingRef {
  _GreetingProviderElement(super.provider);

  @override
  String get name => (origin as GreetingProvider).name;
}

String _$greetingStateHash() => r'66453f19c1effac614ec5072738465b9a7343958';

/// Example of a notifier for more complex state management
/// Use this pattern when you need to manage complex state with multiple actions
///
/// Copied from [GreetingState].
@ProviderFor(GreetingState)
final greetingStateProvider =
    AutoDisposeNotifierProvider<GreetingState, AsyncValue<String?>>.internal(
  GreetingState.new,
  name: r'greetingStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$greetingStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$GreetingState = AutoDisposeNotifier<AsyncValue<String?>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
