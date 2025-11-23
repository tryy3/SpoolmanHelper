import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spoolman_helper_flutter/services/diameter_lookup_service.dart';

part 'diameter_lookup_provider.g.dart';

/// State for diameter sync operations
enum DiameterSyncStatus {
  idle,
  syncing,
  success,
  error,
}

/// State class for brand sync
@immutable
class DiameterSyncState {
  final DiameterSyncStatus status;
  final String? errorMessage;
  final DateTime? lastSyncTime;

  const DiameterSyncState({
    this.status = DiameterSyncStatus.idle,
    this.errorMessage,
    this.lastSyncTime,
  });

  DiameterSyncState copyWith({
    DiameterSyncStatus? status,
    String? errorMessage,
    DateTime? lastSyncTime,
  }) {
    return DiameterSyncState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
    );
  }
}

/// Provider for the DiameterLookupService singleton
@riverpod
DiameterLookupService diameterLookupService(Ref ref) {
  return DiameterLookupService();
}

/// Provider for initializing brand data on app startup
@riverpod
Future<void> initializeDiameters(Ref ref) async {
  final service = ref.watch(diameterLookupServiceProvider);
  if (!service.isInitialized) {
    await service.loadDiameters();
  }
}

/// Notifier for managing diameter sync state
@riverpod
class DiameterSync extends _$DiameterSync {
  @override
  DiameterSyncState build() {
    return const DiameterSyncState();
  }

  /// Trigger a manual sync of diameter data
  Future<void> syncDiameters() async {
    if (state.status == DiameterSyncStatus.syncing) {
      debugPrint('Sync already in progress');
      return;
    }

    if (!ref.mounted) return;
    state = state.copyWith(
      status: DiameterSyncStatus.syncing,
      errorMessage: null,
    );

    try {
      final service = ref.read(diameterLookupServiceProvider);
      await service.downloadAndSaveDiameters();

      state = state.copyWith(
        status: DiameterSyncStatus.success,
        lastSyncTime: DateTime.now(),
      );

      debugPrint('Diameter sync completed successfully');
    } catch (e) {
      if (!ref.mounted) return;
      debugPrint('Diameter sync failed: $e');

      state = state.copyWith(
        status: DiameterSyncStatus.error,
        errorMessage: 'Failed to sync diameters: ${e.toString()}',
      );
    }
  }

  /// Reset the sync state to idle
  void resetState() {
    state = state.copyWith(status: DiameterSyncStatus.idle);
  }

  /// Get diameter name by ID
  String getDiameterString(int id) {
    final service = ref.read(diameterLookupServiceProvider);
    return service.getDiameterLabel(id);
  }
}
