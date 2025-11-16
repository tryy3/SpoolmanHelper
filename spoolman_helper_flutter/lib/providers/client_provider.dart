import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:spoolman_helper_client/spoolman_helper_client.dart';

part 'client_provider.g.dart';

/// Provider for the server URL
@Riverpod(keepAlive: true)
String serverUrl(Ref ref) {
  const serverUrlFromEnv = String.fromEnvironment('SERVER_URL');
  return serverUrlFromEnv.isEmpty
      ? 'http://$localhost:8080/'
      : serverUrlFromEnv;
}

/// Provider for the Serverpod client
/// This replaces the global client variable with a properly managed provider
@Riverpod(keepAlive: true)
Client client(Ref ref) {
  final url = ref.watch(serverUrlProvider);
  final client = Client(url)
    ..connectivityMonitor = FlutterConnectivityMonitor();

  // Clean up the client when the provider is disposed
  ref.onDispose(() {
    client.close();
  });

  return client;
}
