import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/greeting_provider.dart';

/// Example page demonstrating Riverpod state management patterns
/// This shows how to use both the simple async provider and the notifier pattern
class GreetingPageRiverpodExample extends ConsumerStatefulWidget {
  const GreetingPageRiverpodExample({super.key});

  @override
  ConsumerState<GreetingPageRiverpodExample> createState() =>
      _GreetingPageRiverpodExampleState();
}

class _GreetingPageRiverpodExampleState
    extends ConsumerState<GreetingPageRiverpodExample> {
  final _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch the greeting state from the notifier
    final greetingState = ref.watch(greetingStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riverpod Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _textEditingController,
              decoration: const InputDecoration(
                hintText: 'Enter your name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_textEditingController.text.isNotEmpty) {
                  // Call the notifier to fetch the greeting
                  ref
                      .read(greetingStateProvider.notifier)
                      .fetchGreeting(_textEditingController.text);
                }
              },
              child: const Text('Send to Server'),
            ),
            const SizedBox(height: 16),
            // Use pattern matching to handle different states
            greetingState.when(
              data: (message) {
                if (message == null) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.grey[300],
                    child: const Text('No server response yet.'),
                  );
                }
                return Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.green[300],
                  child: Text(message),
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (error, stack) => Container(
                padding: const EdgeInsets.all(16),
                color: Colors.red[300],
                child: Text('Error: $error'),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                ref.read(greetingStateProvider.notifier).clear();
                _textEditingController.clear();
              },
              child: const Text('Clear'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Example using the simple async provider with Consumer
/// This is a simpler pattern for one-off fetches
class SimpleGreetingExample extends ConsumerWidget {
  const SimpleGreetingExample({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the greeting provider with the name parameter
    // This will automatically refetch when the name changes
    final greetingAsync = ref.watch(greetingProvider(name));

    return greetingAsync.when(
      data: (response) => Text(response?.message ?? 'No message'),
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}

