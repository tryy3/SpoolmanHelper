# Riverpod Providers

This directory contains all the Riverpod providers for state management in the app.

## Setup

The app is configured with:
- `flutter_riverpod` - Main Riverpod package
- `riverpod_annotation` - Code generation annotations
- `riverpod_generator` - Code generator for providers
- `riverpod_lint` - Linting rules for Riverpod best practices

## Provider Patterns

### 1. Simple Provider (Keep Alive)

Used for singletons like the Serverpod client:

```dart
@Riverpod(keepAlive: true)
Client client(ClientRef ref) {
  final client = Client(url);
  ref.onDispose(() => client.close());
  return client;
}
```

### 2. Async Provider (Auto-Dispose)

Used for simple async data fetching:

```dart
@riverpod
Future<Data> fetchData(FetchDataRef ref, String id) async {
  final client = ref.watch(clientProvider);
  return await client.endpoint.getData(id);
}

// Usage in widget:
final dataAsync = ref.watch(fetchDataProvider('123'));
dataAsync.when(
  data: (data) => Text(data.toString()),
  loading: () => CircularProgressIndicator(),
  error: (err, stack) => Text('Error: $err'),
);
```

### 3. Notifier Provider (Complex State)

Used for complex state management with multiple actions:

```dart
@riverpod
class MyState extends _$MyState {
  @override
  AsyncValue<Data?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> fetchData() async {
    state = const AsyncValue.loading();
    try {
      final result = await someAsyncOperation();
      state = AsyncValue.data(result);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

// Usage in widget:
final myState = ref.watch(myStateProvider);
// Call actions:
ref.read(myStateProvider.notifier).fetchData();
```

## Code Generation

After creating or modifying providers, run:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Or watch for changes:

```bash
dart run build_runner watch --delete-conflicting-outputs
```

## Widget Types

### ConsumerWidget
For stateless widgets that need to read providers:

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(myProvider);
    return Text(value);
  }
}
```

### ConsumerStatefulWidget
For stateful widgets that need to read providers:

```dart
class MyWidget extends ConsumerStatefulWidget {
  @override
  ConsumerState<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends ConsumerState<MyWidget> {
  @override
  Widget build(BuildContext context) {
    final value = ref.watch(myProvider);
    return Text(value);
  }
}
```

### Consumer
For reading providers in a specific part of the widget tree:

```dart
Consumer(
  builder: (context, ref, child) {
    final value = ref.watch(myProvider);
    return Text(value);
  },
)
```

## Best Practices

1. **Use `ref.watch`** when you want to rebuild the widget when the provider changes
2. **Use `ref.read`** when you want to read a value once (e.g., in event handlers)
3. **Use `ref.listen`** when you want to perform side effects when a provider changes
4. **Keep providers small and focused** - Each provider should have a single responsibility
5. **Use code generation** - It's the recommended approach and provides better type safety
6. **Clean up resources** - Use `ref.onDispose()` for cleanup

## Examples

See:
- `client_provider.dart` - Example of a singleton provider with cleanup
- `greeting_provider.dart` - Examples of async provider and notifier patterns
- `lib/pages/greeting_page_riverpod_example.dart` - Example usage in widgets

