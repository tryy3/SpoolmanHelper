import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spoolman_helper_flutter/providers/aspect_lookup_provider.dart';
import 'package:spoolman_helper_flutter/providers/diameter_lookup_provider.dart';
import 'package:spoolman_helper_flutter/providers/id_type_lookup_provider.dart';
import 'package:spoolman_helper_flutter/providers/measurement_unit_lookup_provider.dart';
import 'brand_lookup_provider.dart';
import 'material_lookup_provider.dart';

part 'app_initialization_provider.g.dart';

/// Combined provider for initializing all app data on startup
///
/// This orchestrates the initialization of all lookup services
/// (brands, materials, etc.) in parallel for optimal performance.
@riverpod
Future<void> initializeApp(Ref ref) async {
  // Wait for all initializations in parallel
  await Future.wait([
    ref.watch(initializeBrandsProvider.future),
    ref.watch(initializeMaterialsProvider.future),
    ref.watch(initializeAspectsProvider.future),
    ref.watch(initializeMeasurementUnitsProvider.future),
    ref.watch(initializeDiametersProvider.future),
    ref.watch(initializeIdTypesProvider.future),
    // Add more lookup service initializations here as needed
  ]);
}
