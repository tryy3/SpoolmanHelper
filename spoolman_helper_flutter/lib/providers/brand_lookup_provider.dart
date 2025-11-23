import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/brand_lookup_service.dart';

part 'brand_lookup_provider.g.dart';

/// State for brand sync operations
enum BrandSyncStatus {
  idle,
  syncing,
  success,
  error,
}

/// State class for brand sync
@immutable
class BrandSyncState {
  final BrandSyncStatus status;
  final String? errorMessage;
  final DateTime? lastSyncTime;

  const BrandSyncState({
    this.status = BrandSyncStatus.idle,
    this.errorMessage,
    this.lastSyncTime,
  });

  BrandSyncState copyWith({
    BrandSyncStatus? status,
    String? errorMessage,
    DateTime? lastSyncTime,
  }) {
    return BrandSyncState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
    );
  }
}

/// Provider for the BrandLookupService singleton
@riverpod
BrandLookupService brandLookupService(Ref ref) {
  return BrandLookupService();
}

/// Provider for initializing brand data on app startup
@riverpod
Future<void> initializeBrands(Ref ref) async {
  final service = ref.watch(brandLookupServiceProvider);
  if (!service.isInitialized) {
    await service.loadBrands();
  }
}

/// Notifier for managing brand sync state
@riverpod
class BrandSync extends _$BrandSync {
  @override
  BrandSyncState build() {
    return const BrandSyncState();
  }

  /// Trigger a manual sync of brand data
  Future<void> syncBrands() async {
    if (state.status == BrandSyncStatus.syncing) {
      debugPrint('Sync already in progress');
      return;
    }

    if (!ref.mounted) return;
    state = state.copyWith(
      status: BrandSyncStatus.syncing,
      errorMessage: null,
    );

    try {
      final service = ref.read(brandLookupServiceProvider);
      await service.downloadAndSaveBrands();

      state = state.copyWith(
        status: BrandSyncStatus.success,
        lastSyncTime: DateTime.now(),
      );

      debugPrint('Brand sync completed successfully');
    } catch (e) {
      if (!ref.mounted) return;
      debugPrint('Brand sync failed: $e');
      state = state.copyWith(
        status: BrandSyncStatus.error,
        errorMessage: 'Failed to sync brands: ${e.toString()}',
      );
    }
  }

  /// Reset the sync state to idle
  void resetState() {
    state = state.copyWith(status: BrandSyncStatus.idle);
  }

  /// Get brand name by ID
  String getBrandName(int id) {
    final service = ref.read(brandLookupServiceProvider);
    return service.getBrandName(id);
  }
}
