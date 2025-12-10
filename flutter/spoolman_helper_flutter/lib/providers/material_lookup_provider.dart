import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/material_lookup_service.dart';

part 'material_lookup_provider.g.dart';

/// State for material sync operations
enum MaterialSyncStatus {
  idle,
  syncing,
  success,
  error,
}

/// State class for brand sync
@immutable
class MaterialSyncState {
  final MaterialSyncStatus status;
  final String? errorMessage;
  final DateTime? lastSyncTime;

  const MaterialSyncState({
    this.status = MaterialSyncStatus.idle,
    this.errorMessage,
    this.lastSyncTime,
  });

  MaterialSyncState copyWith({
    MaterialSyncStatus? status,
    String? errorMessage,
    DateTime? lastSyncTime,
  }) {
    return MaterialSyncState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
    );
  }
}

/// Provider for the MaterialLookupService singleton
@riverpod
MaterialLookupService materialLookupService(Ref ref) {
  return MaterialLookupService();
}

/// Provider for initializing brand data on app startup
@riverpod
Future<void> initializeMaterials(Ref ref) async {
  final service = ref.watch(materialLookupServiceProvider);
  if (!service.isInitialized) {
    await service.loadMaterials();
  }
}

/// Notifier for managing material sync state
@riverpod
class MaterialSync extends _$MaterialSync {
  @override
  MaterialSyncState build() {
    return const MaterialSyncState();
  }

  /// Trigger a manual sync of material data
  Future<void> syncMaterials() async {
    if (state.status == MaterialSyncStatus.syncing) {
      debugPrint('Sync already in progress');
      return;
    }

    if (!ref.mounted) return;
    state = state.copyWith(
      status: MaterialSyncStatus.syncing,
      errorMessage: null,
    );

    try {
      final service = ref.read(materialLookupServiceProvider);
      await service.downloadAndSaveMaterials();

      state = state.copyWith(
        status: MaterialSyncStatus.success,
        lastSyncTime: DateTime.now(),
      );

      debugPrint('Material sync completed successfully');
    } catch (e) {
      if (!ref.mounted) return;
      debugPrint('Material sync failed: $e');
      state = state.copyWith(
        status: MaterialSyncStatus.error,
        errorMessage: 'Failed to sync materials: ${e.toString()}',
      );
    }
  }

  /// Reset the sync state to idle
  void resetState() {
    state = state.copyWith(status: MaterialSyncStatus.idle);
  }

  /// Get material name by ID
  String getMaterialName(int id) {
    final service = ref.read(materialLookupServiceProvider);
    return service.getMaterialLabel(id);
  }
}
