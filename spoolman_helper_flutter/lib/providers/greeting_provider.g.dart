// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'greeting_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Example async provider that demonstrates how to fetch data from the server
/// This provider will automatically handle loading, error, and data states

@ProviderFor(greeting)
const greetingProvider = GreetingFamily._();

/// Example async provider that demonstrates how to fetch data from the server
/// This provider will automatically handle loading, error, and data states

final class GreetingProvider extends $FunctionalProvider<AsyncValue<Greeting>,
        Greeting, FutureOr<Greeting>>
    with $FutureModifier<Greeting>, $FutureProvider<Greeting> {
  /// Example async provider that demonstrates how to fetch data from the server
  /// This provider will automatically handle loading, error, and data states
  const GreetingProvider._(
      {required GreetingFamily super.from, required String super.argument})
      : super(
          retry: null,
          name: r'greetingProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$greetingHash();

  @override
  String toString() {
    return r'greetingProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Greeting> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Greeting> create(Ref ref) {
    final argument = this.argument as String;
    return greeting(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GreetingProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$greetingHash() => r'094835304774d1579394e193b34f479a6276e22d';

/// Example async provider that demonstrates how to fetch data from the server
/// This provider will automatically handle loading, error, and data states

final class GreetingFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Greeting>, String> {
  const GreetingFamily._()
      : super(
          retry: null,
          name: r'greetingProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Example async provider that demonstrates how to fetch data from the server
  /// This provider will automatically handle loading, error, and data states

  GreetingProvider call(
    String userName,
  ) =>
      GreetingProvider._(argument: userName, from: this);

  @override
  String toString() => r'greetingProvider';
}

/// Example of a notifier for more complex state management
/// Use this pattern when you need to manage complex state with multiple actions

@ProviderFor(GreetingState)
const greetingStateProvider = GreetingStateProvider._();

/// Example of a notifier for more complex state management
/// Use this pattern when you need to manage complex state with multiple actions
final class GreetingStateProvider
    extends $NotifierProvider<GreetingState, AsyncValue<String?>> {
  /// Example of a notifier for more complex state management
  /// Use this pattern when you need to manage complex state with multiple actions
  const GreetingStateProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'greetingStateProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$greetingStateHash();

  @$internal
  @override
  GreetingState create() => GreetingState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<String?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<String?>>(value),
    );
  }
}

String _$greetingStateHash() => r'66453f19c1effac614ec5072738465b9a7343958';

/// Example of a notifier for more complex state management
/// Use this pattern when you need to manage complex state with multiple actions

abstract class _$GreetingState extends $Notifier<AsyncValue<String?>> {
  AsyncValue<String?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<String?>, AsyncValue<String?>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<String?>, AsyncValue<String?>>,
        AsyncValue<String?>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
