import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spoolman_helper_flutter/services/id_type_lookup_service.dart';

part 'id_type_lookup_provider.g.dart';

/// State for idType sync operations
enum IdTypeSyncStatus {
  idle,
  syncing,
  success,
  error,
}

/// State class for brand sync
@immutable
class IdTypeSyncState {
  final IdTypeSyncStatus status;
  final String? errorMessage;
  final DateTime? lastSyncTime;

  const IdTypeSyncState({
    this.status = IdTypeSyncStatus.idle,
    this.errorMessage,
    this.lastSyncTime,
  });

  IdTypeSyncState copyWith({
    IdTypeSyncStatus? status,
    String? errorMessage,
    DateTime? lastSyncTime,
  }) {
    return IdTypeSyncState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
    );
  }
}

/// Provider for the IdTypeLookupService singleton
@riverpod
IdTypeLookupService idTypeLookupService(Ref ref) {
  return IdTypeLookupService();
}

/// Provider for initializing brand data on app startup
@riverpod
Future<void> initializeIdTypes(Ref ref) async {
  final service = ref.watch(idTypeLookupServiceProvider);
  if (!service.isInitialized) {
    await service.loadIdTypes();
  }
}

/// Notifier for managing idType sync state
@riverpod
class IdTypeSync extends _$IdTypeSync {
  @override
  IdTypeSyncState build() {
    return const IdTypeSyncState();
  }

  /// Trigger a manual sync of idType data
  Future<void> syncIdTypes() async {
    if (state.status == IdTypeSyncStatus.syncing) {
      debugPrint('Sync already in progress');
      return;
    }

    if (!ref.mounted) return;
    state = state.copyWith(
      status: IdTypeSyncStatus.syncing,
      errorMessage: null,
    );

    try {
      final service = ref.read(idTypeLookupServiceProvider);
      await service.downloadAndSaveIdTypes();

      state = state.copyWith(
        status: IdTypeSyncStatus.success,
        lastSyncTime: DateTime.now(),
      );

      debugPrint('IdType sync completed successfully');
    } catch (e) {
      if (!ref.mounted) return;
      debugPrint('IdType sync failed: $e');

      state = state.copyWith(
        status: IdTypeSyncStatus.error,
        errorMessage: 'Failed to sync idTypes: ${e.toString()}',
      );
    }
  }

  /// Reset the sync state to idle
  void resetState() {
    state = state.copyWith(status: IdTypeSyncStatus.idle);
  }

  /// Get idType name by ID
  String getIdTypeString(int id) {
    final service = ref.read(idTypeLookupServiceProvider);
    return service.getIdTypeLabel(id);
  }
}
