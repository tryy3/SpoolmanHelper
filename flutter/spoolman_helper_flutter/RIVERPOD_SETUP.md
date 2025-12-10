# Riverpod Setup Guide

This document explains the Riverpod state management setup in the Flutter client application.

## What Was Set Up

### 1. Dependencies Added

In `pubspec.yaml`:
- **flutter_riverpod** (^2.6.1) - Core Riverpod package
- **riverpod_annotation** (^2.6.1) - Annotations for code generation
- **build_runner** (^2.4.13) - Code generation tool
- **riverpod_generator** (^2.6.1) - Generates provider code
- **custom_lint** (^0.7.0) - Custom linting support
- **riverpod_lint** (^2.6.1) - Riverpod-specific linting rules

### 2. Main App Wrapped with ProviderScope

In `lib/main.dart`, the entire app is now wrapped with `ProviderScope`:

```dart
void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
```

This enables Riverpod throughout your entire application.

### 3. Serverpod Client Provider

Created `lib/providers/client_provider.dart` which provides:
- **serverUrlProvider** - Manages the server URL configuration
- **clientProvider** - Provides the Serverpod client with proper lifecycle management

The client provider replaces the old global `client` variable with a properly managed provider that:
- Automatically cleans up when disposed
- Can be easily tested with overrides
- Follows dependency injection best practices

### 4. Example Providers

Created `lib/providers/greeting_provider.dart` with two patterns:

#### Simple Async Provider
```dart
@riverpod
Future<Greeting> greeting(GreetingRef ref, String userName) async {
  final client = ref.watch(clientProvider);
  return await client.greeting.hello(userName);
}
```

#### Notifier Pattern (for complex state)
```dart
@riverpod
class GreetingState extends _$GreetingState {
  @override
  AsyncValue<String?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> fetchGreeting(String name) async {
    state = const AsyncValue.loading();
    try {
      final client = ref.read(clientProvider);
      final result = await client.greeting.hello(name);
      state = AsyncValue.data(result.message);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
```

### 5. Example Pages

Created `lib/pages/greeting_page_riverpod_example.dart` demonstrating:
- How to use ConsumerStatefulWidget
- How to watch and read providers
- How to handle AsyncValue states with `.when()`
- Pattern matching for loading, data, and error states

### 6. Analysis Options Updated

Added custom_lint support in `analysis_options.yaml` to enable Riverpod-specific linting rules.

## How to Use Riverpod in Your App

### Reading Providers in Widgets

There are three main ways to read providers:

#### 1. ConsumerWidget (for stateless widgets)

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final client = ref.watch(clientProvider);
    return Text('Connected to server');
  }
}
```

#### 2. ConsumerStatefulWidget (for stateful widgets)

```dart
class MyWidget extends ConsumerStatefulWidget {
  @override
  ConsumerState<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends ConsumerState<MyWidget> {
  @override
  Widget build(BuildContext context) {
    final value = ref.watch(someProvider);
    return Text(value);
  }
}
```

#### 3. Consumer (for specific parts of the tree)

```dart
Consumer(
  builder: (context, ref, child) {
    final value = ref.watch(someProvider);
    return Text(value);
  },
)
```

### ref.watch vs ref.read vs ref.listen

- **ref.watch(provider)** - Rebuilds the widget when provider changes. Use in `build()` method.
- **ref.read(provider)** - Reads the value once without listening. Use in event handlers, initState, etc.
- **ref.listen(provider, callback)** - Executes a callback when provider changes. Use for side effects like showing snackbars.

### Handling Async Data

When working with `AsyncValue`:

```dart
final dataAsync = ref.watch(someAsyncProvider);

// Pattern 1: Using .when()
dataAsync.when(
  data: (data) => Text('Data: $data'),
  loading: () => CircularProgressIndicator(),
  error: (err, stack) => Text('Error: $err'),
);

// Pattern 2: Using pattern matching
switch (dataAsync) {
  case AsyncData(:final value):
    return Text('Data: $value');
  case AsyncLoading():
    return CircularProgressIndicator();
  case AsyncError(:final error):
    return Text('Error: $error');
}

// Pattern 3: Accessing properties directly
if (dataAsync.isLoading) {
  return CircularProgressIndicator();
}
if (dataAsync.hasError) {
  return Text('Error: ${dataAsync.error}');
}
if (dataAsync.hasValue) {
  return Text('Data: ${dataAsync.value}');
}
```

## Creating New Providers

### Step 1: Create the Provider File

Create a new file in `lib/providers/`, for example `my_provider.dart`:

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'client_provider.dart';

part 'my_provider.g.dart';

@riverpod
Future<MyData> myData(MyDataRef ref) async {
  final client = ref.watch(clientProvider);
  return await client.myEndpoint.getData();
}
```

### Step 2: Run Code Generation

```bash
cd spoolman_helper_flutter
dart run build_runner build --delete-conflicting-outputs
```

Or for continuous watching:

```bash
dart run build_runner watch --delete-conflicting-outputs
```

### Step 3: Use the Provider

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myDataAsync = ref.watch(myDataProvider);
    
    return myDataAsync.when(
      data: (data) => Text(data.toString()),
      loading: () => CircularProgressIndicator(),
      error: (err, stack) => Text('Error: $err'),
    );
  }
}
```

## Provider Types

### Simple Provider (Singleton)

```dart
@Riverpod(keepAlive: true)
MyService myService(MyServiceRef ref) {
  return MyService();
}
```

### Auto-Dispose Provider (Default)

```dart
@riverpod
Future<Data> fetchData(FetchDataRef ref) async {
  // Automatically disposed when no longer used
  return await someAsyncOperation();
}
```

### Family Provider (with parameters)

```dart
@riverpod
Future<User> user(UserRef ref, String userId) async {
  final client = ref.watch(clientProvider);
  return await client.users.getUser(userId);
}

// Usage:
final userAsync = ref.watch(userProvider('123'));
```

### Notifier (for mutable state)

```dart
@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;

  void increment() => state++;
  void decrement() => state--;
}

// Usage:
final count = ref.watch(counterProvider);
ref.read(counterProvider.notifier).increment();
```

## Best Practices

1. **Keep providers small and focused** - Each provider should have a single responsibility
2. **Use code generation** - It provides better type safety and less boilerplate
3. **Avoid side effects in build()** - Use ref.listen() for side effects
4. **Clean up resources** - Use ref.onDispose() when needed
5. **Prefer AsyncNotifier for complex async state** - It handles loading and error states better
6. **Use family providers for parameterized data** - Instead of creating multiple similar providers
7. **Test with provider overrides** - Riverpod makes testing easy with ProviderScope overrides

## Testing with Riverpod

```dart
testWidgets('Test widget with provider', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        clientProvider.overrideWithValue(mockClient),
      ],
      child: MyApp(),
    ),
  );
  
  // Your test assertions
});
```

## Migration Path

The old example code has been converted from:
- StatefulWidget → ConsumerStatefulWidget
- Global `client` variable → `clientProvider`
- setState for state management → Riverpod providers

You can follow the same pattern for your other widgets.

## Additional Resources

- [Riverpod Documentation](https://riverpod.dev)
- [Code Generation](https://riverpod.dev/docs/concepts/about_code_generation)
- [Async Providers](https://riverpod.dev/docs/providers/future_provider)
- [Testing](https://riverpod.dev/docs/cookbooks/testing)

## Troubleshooting

### Generated files not found?
Run: `dart run build_runner build --delete-conflicting-outputs`

### Linting errors?
Make sure `analysis_options.yaml` includes the custom_lint plugin.

### Provider not updating?
- Check if you're using `ref.watch()` (not `ref.read()`) in build method
- Ensure the provider is not accidentally kept alive when it should auto-dispose

### Getting "ProviderScope not found"?
Make sure your app is wrapped with `ProviderScope` in main.dart.

