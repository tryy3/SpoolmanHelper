import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/aspect_lookup_service.dart';

part 'aspect_lookup_provider.g.dart';

/// State for aspect sync operations
enum AspectSyncStatus {
  idle,
  syncing,
  success,
  error,
}

/// State class for brand sync
@immutable
class AspectSyncState {
  final AspectSyncStatus status;
  final String? errorMessage;
  final DateTime? lastSyncTime;

  const AspectSyncState({
    this.status = AspectSyncStatus.idle,
    this.errorMessage,
    this.lastSyncTime,
  });

  AspectSyncState copyWith({
    AspectSyncStatus? status,
    String? errorMessage,
    DateTime? lastSyncTime,
  }) {
    return AspectSyncState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
    );
  }
}

/// Provider for the AspectLookupService singleton
@riverpod
AspectLookupService aspectLookupService(Ref ref) {
  return AspectLookupService();
}

/// Provider for initializing brand data on app startup
@riverpod
Future<void> initializeAspects(Ref ref) async {
  final service = ref.watch(aspectLookupServiceProvider);
  if (!service.isInitialized) {
    await service.loadAspects();
  }
}

/// Notifier for managing aspect sync state
@riverpod
class AspectSync extends _$AspectSync {
  @override
  AspectSyncState build() {
    return const AspectSyncState();
  }

  /// Trigger a manual sync of aspect data
  Future<void> syncAspects() async {
    if (state.status == AspectSyncStatus.syncing) {
      debugPrint('Sync already in progress');
      return;
    }

    if (!ref.mounted) return;
    state = state.copyWith(
      status: AspectSyncStatus.syncing,
      errorMessage: null,
    );

    try {
      final service = ref.read(aspectLookupServiceProvider);
      await service.downloadAndSaveAspects();

      state = state.copyWith(
        status: AspectSyncStatus.success,
        lastSyncTime: DateTime.now(),
      );

      debugPrint('Aspect sync completed successfully');
    } catch (e) {
      if (!ref.mounted) return;
      debugPrint('Aspect sync failed: $e');
      state = state.copyWith(
        status: AspectSyncStatus.error,
        errorMessage: 'Failed to sync aspects: ${e.toString()}',
      );
    }
  }

  /// Reset the sync state to idle
  void resetState() {
    state = state.copyWith(status: AspectSyncStatus.idle);
  }

  /// Get aspect name by ID
  String getAspectName(int id) {
    final service = ref.read(aspectLookupServiceProvider);
    return service.getAspectLabel(id);
  }
}
