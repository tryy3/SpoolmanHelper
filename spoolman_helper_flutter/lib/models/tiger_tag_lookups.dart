/// Lookup tables for TigerTag data
///
/// These maps convert TigerTag IDs to human-readable names
/// based on the TigerTag specification

/// Material type lookup
const Map<int, String> materialLookup = {
  0: 'PLA',
  1: 'ABS',
  2: 'PETG',
  3: 'TPU',
  4: 'PA', // Nylon
  5: 'ASA',
  6: 'PC', // Polycarbonate
  7: 'PVA',
  8: 'HIPS',
  9: 'PP', // Polypropylene
  10: 'Flexible',
  11: 'PET',
  12: 'BVOH',
  13: 'PA-CF', // Carbon Fiber Nylon
  14: 'PLA-CF', // Carbon Fiber PLA
  15: 'PETG-CF', // Carbon Fiber PETG
  16: 'PLA+',
  // Add more as needed
};

/// Brand/manufacturer lookup has been moved to BrandLookupService
/// See lib/services/brand_lookup_service.dart for dynamic brand lookups

/// Diameter lookup (in mm)
const Map<int, String> diameterLookup = {
  0: '1.75 mm',
  1: '2.85 mm',
  2: '3.00 mm',
  // Add more as needed
};

/// Visual aspect/finish lookup
const Map<int, String> aspectLookup = {
  0: 'Basic / None',
  1: 'Matte',
  2: 'Glossy',
  3: 'Metallic',
  4: 'Silk',
  5: 'Sparkle',
  6: 'Marble',
  7: 'Glow',
  8: 'Transparent',
  9: 'Translucent',
  10: 'Wood Fill',
  11: 'Metal Fill',
  12: 'Carbon Fiber',
  13: 'Temperature Change',
  14: 'UV Reactive',
  // Add more as needed
};

/// Unit/measurement type lookup
const Map<int, String> measurementUnitLookup = {
  0: 'g', // grams
  1: 'kg', // kilograms
  2: 'm', // meters
  3: 'ft', // feet
  // Add more as needed
};

/// ID Type lookup (what the ID represents)
const Map<int, String> idTypeLookup = {
  0: 'Filament',
  1: 'Resin',
  2: 'Powder',
  3: 'Other',
  // Add more as needed
};

/// Get material name from ID
String getMaterialName(int id) {
  return materialLookup[id] ?? 'Unknown Material ($id)';
}

/// Get brand name from ID
/// Note: Brand lookup is now handled dynamically by BrandLookupService
/// Use ref.read(brandSyncProvider.notifier).getBrandName(id) instead

/// Get diameter from ID
String getDiameter(int id) {
  return diameterLookup[id] ?? 'Unknown ($id)';
}

/// Get aspect/finish from ID
String getAspect(int id) {
  return aspectLookup[id] ?? 'Unknown ($id)';
}

/// Get measurement unit from ID
String getMeasurementUnit(int id) {
  return measurementUnitLookup[id] ?? 'Unknown Unit ($id)';
}

/// Get ID type from ID
String getIdType(int id) {
  return idTypeLookup[id] ?? 'Unknown ($id)';
}

/// Combine multiple aspects into a readable string
String getCombinedAspects(int first, int second) {
  if (first == 0 && second == 0) {
    return 'Basic / None';
  }

  final aspects = <String>[];
  if (first != 0) aspects.add(getAspect(first));
  if (second != 0) aspects.add(getAspect(second));

  return aspects.isEmpty ? 'Basic / None' : aspects.join(' / ');
}
