import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spoolman_helper_client/spoolman_helper_client.dart';
import 'client_provider.dart';

part 'greeting_provider.g.dart';

/// Example async provider that demonstrates how to fetch data from the server
/// This provider will automatically handle loading, error, and data states
@riverpod
Future<Greeting> greeting(
  Ref ref,
  String userName,
) async {
  // Get the client from the client provider
  final client = ref.watch(clientProvider);

  // Call the server endpoint
  // Riverpod will automatically handle loading and error states
  return await client.greeting.hello(userName);
}

/// Example of a notifier for more complex state management
/// Use this pattern when you need to manage complex state with multiple actions
@riverpod
class GreetingState extends _$GreetingState {
  @override
  AsyncValue<String?> build() {
    // Initial state
    return const AsyncValue.data(null);
  }

  /// Call the server to get a greeting
  Future<void> fetchGreeting(String name) async {
    // Set loading state
    state = const AsyncValue.loading();

    try {
      final client = ref.read(clientProvider);
      final result = await client.greeting.hello(name);
      // Set success state
      state = AsyncValue.data(result.message);
    } catch (error, stackTrace) {
      // Set error state
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Clear the greeting message
  void clear() {
    state = const AsyncValue.data(null);
  }
}
