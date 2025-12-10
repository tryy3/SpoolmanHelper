import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spoolman_helper_flutter/services/measurement_unit_lookup_service.dart';

part 'measurement_unit_lookup_provider.g.dart';

/// State for measurementUnit sync operations
enum MeasurementUnitSyncStatus {
  idle,
  syncing,
  success,
  error,
}

/// State class for brand sync
@immutable
class MeasurementUnitSyncState {
  final MeasurementUnitSyncStatus status;
  final String? errorMessage;
  final DateTime? lastSyncTime;

  const MeasurementUnitSyncState({
    this.status = MeasurementUnitSyncStatus.idle,
    this.errorMessage,
    this.lastSyncTime,
  });

  MeasurementUnitSyncState copyWith({
    MeasurementUnitSyncStatus? status,
    String? errorMessage,
    DateTime? lastSyncTime,
  }) {
    return MeasurementUnitSyncState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
    );
  }
}

/// Provider for the MeasurementUnitLookupService singleton
@riverpod
MeasurementUnitLookupService measurementUnitLookupService(Ref ref) {
  return MeasurementUnitLookupService();
}

/// Provider for initializing brand data on app startup
@riverpod
Future<void> initializeMeasurementUnits(Ref ref) async {
  final service = ref.watch(measurementUnitLookupServiceProvider);
  if (!service.isInitialized) {
    await service.loadMeasurementUnits();
  }
}

/// Notifier for managing measurementUnit sync state
@riverpod
class MeasurementUnitSync extends _$MeasurementUnitSync {
  @override
  MeasurementUnitSyncState build() {
    return const MeasurementUnitSyncState();
  }

  /// Trigger a manual sync of measurementUnit data
  Future<void> syncMeasurementUnits() async {
    if (state.status == MeasurementUnitSyncStatus.syncing) {
      debugPrint('Sync already in progress');
      return;
    }

    if (!ref.mounted) return;
    state = state.copyWith(
      status: MeasurementUnitSyncStatus.syncing,
      errorMessage: null,
    );

    try {
      final service = ref.read(measurementUnitLookupServiceProvider);
      await service.downloadAndSaveMeasurementUnits();

      state = state.copyWith(
        status: MeasurementUnitSyncStatus.success,
        lastSyncTime: DateTime.now(),
      );

      debugPrint('MeasurementUnit sync completed successfully');
    } catch (e) {
      if (!ref.mounted) return;
      debugPrint('MeasurementUnit sync failed: $e');
      state = state.copyWith(
        status: MeasurementUnitSyncStatus.error,
        errorMessage: 'Failed to sync measurementUnits: ${e.toString()}',
      );
    }
  }

  /// Reset the sync state to idle
  void resetState() {
    state = state.copyWith(status: MeasurementUnitSyncStatus.idle);
  }

  /// Get measurementUnit name by ID
  String getMeasurementUnitName(int id) {
    final service = ref.read(measurementUnitLookupServiceProvider);
    return service.getMeasurementUnitLabel(id);
  }
}
