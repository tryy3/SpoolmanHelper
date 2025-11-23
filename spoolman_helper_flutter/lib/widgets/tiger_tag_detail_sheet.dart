import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spoolman_helper_flutter/providers/aspect_lookup_provider.dart';
import 'package:spoolman_helper_flutter/providers/diameter_lookup_provider.dart';
import 'package:spoolman_helper_flutter/providers/id_type_lookup_provider.dart';
import 'package:spoolman_helper_flutter/providers/material_lookup_provider.dart';
import 'package:spoolman_helper_flutter/providers/measurement_unit_lookup_provider.dart';
import '../models/tiger_tag.dart';
import '../models/tiger_tag_extensions.dart';
import '../providers/brand_lookup_provider.dart';

/// Show a modal bottom sheet displaying TigerTag details
Future<void> showTigerTagDetailSheet(
  BuildContext context,
  TigerTag tigerTag,
) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => TigerTagDetailSheet(tigerTag: tigerTag),
  );
}

/// Beautiful bottom sheet widget displaying TigerTag information
class TigerTagDetailSheet extends ConsumerWidget {
  final TigerTag tigerTag;

  const TigerTagDetailSheet({
    super.key,
    required this.tigerTag,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final brandName =
        ref.read(brandSyncProvider.notifier).getBrandName(tigerTag.idBrand);
    final materialName = ref
        .read(materialSyncProvider.notifier)
        .getMaterialName(tigerTag.materialID);
    final firstAspectName = ref
        .read(aspectSyncProvider.notifier)
        .getAspectName(tigerTag.firstVisualAspectID);
    final secondAspectName = ref
        .read(aspectSyncProvider.notifier)
        .getAspectName(tigerTag.secondVisualAspectID);
    final aspectName = '$firstAspectName / $secondAspectName';

    final measurementUnitName = ref
        .read(measurementUnitSyncProvider.notifier)
        .getMeasurementUnitName(tigerTag.measurementID);

    final diameterString = ref
        .read(diameterSyncProvider.notifier)
        .getDiameterString(tigerTag.diameterID);

    final idTypeString =
        ref.read(idTypeSyncProvider.notifier).getIdTypeString(tigerTag.idType);

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color:
                      theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                  children: [
                    // Header with connection status
                    _buildHeader(context, theme),
                    const SizedBox(height: 24),

                    // TigerTag Logo/Brand section
                    _buildLogoSection(context, theme),
                    const SizedBox(height: 16),

                    // Brand and Material Name
                    _buildTitle(context, theme, brandName, materialName),
                    const SizedBox(height: 24),

                    // Main info cards
                    _buildMainInfoCard(context, theme, materialName, aspectName,
                        measurementUnitName, diameterString),
                    const SizedBox(height: 16),

                    // Color display
                    _buildColorDisplay(context, theme),
                    const SizedBox(height: 24),

                    // Type label with arrows
                    _buildTypeLabel(context, theme, idTypeString),
                    const SizedBox(height: 8),

                    // ID display
                    // TODO: Change this to "custom message"
                    _buildIdDisplay(context, theme),
                    const SizedBox(height: 24),

                    // Temperature and Drying info
                    Row(
                      children: [
                        Expanded(
                          child: _buildNozzleTempCard(context, theme),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: _buildDryingCard(context, theme),
                        ),
                      ],
                    ),

                    // Bed temperature (if available)
                    if (tigerTag.hasBedTemperatureData) ...[
                      const SizedBox(height: 16),
                      _buildBedTempCard(context, theme),
                    ],

                    const SizedBox(height: 24),

                    // Action button
                    _buildActionButton(context, theme),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'TigerTag (Offline)',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Widget _buildLogoSection(BuildContext context, ThemeData theme) {
    return Center(
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Tiger head icon (placeholder for actual logo)
            Icon(
              Icons.pets,
              size: 48,
              color: Colors.white,
            ),
            const SizedBox(height: 8),
            Text(
              'TIGER TAG',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            Text(
              'RFID',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 10,
                letterSpacing: 2.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context, ThemeData theme, String brandName,
      String materialName) {
    return Center(
      child: Text(
        '$brandName - $materialName test',
        style: theme.textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildMainInfoCard(
      BuildContext context,
      ThemeData theme,
      String materialName,
      String aspectName,
      String measurementUnitName,
      String diameterString) {
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildInfoRow(
              'Material:',
              materialName,
              theme,
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              'Aspect:',
              aspectName,
              theme,
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              'Weight:',
              '${tigerTag.measurementValue} $measurementUnitName',
              theme,
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              'Diameter:',
              diameterString,
              theme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.titleMedium,
        ),
      ],
    );
  }

  Widget _buildColorDisplay(BuildContext context, ThemeData theme) {
    return Center(
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: tigerTag.primaryColor,
          shape: BoxShape.circle,
          border: Border.all(
            color: theme.colorScheme.outline,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: tigerTag.primaryColor.withValues(alpha: 0.3),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeLabel(
      BuildContext context, ThemeData theme, String idTypeString) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.chevron_right,
          size: 32,
          color: theme.colorScheme.onSurface,
        ),
        const SizedBox(width: 8),
        Text(
          idTypeString,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        Icon(
          Icons.chevron_left,
          size: 32,
          color: theme.colorScheme.onSurface,
        ),
      ],
    );
  }

  Widget _buildIdDisplay(BuildContext context, ThemeData theme) {
    return Center(
      child: Text(
        tigerTag.formattedId,
        style: theme.textTheme.displayMedium?.copyWith(
          fontWeight: FontWeight.bold,
          fontFamily: 'monospace',
        ),
      ),
    );
  }

  Widget _buildNozzleTempCard(BuildContext context, ThemeData theme) {
    return Card(
      elevation: 0,
      color: theme.colorScheme.errorContainer.withValues(alpha: 0.3),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.local_fire_department,
                  color: theme.colorScheme.error,
                  size: 24,
                ),
                const SizedBox(width: 4),
                Text(
                  'Nozzle',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      'Min',
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${tigerTag.nozzleTemperatureMin}°C',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Max',
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${tigerTag.nozzleTemperatureMax}°C',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDryingCard(BuildContext context, ThemeData theme) {
    return Card(
      elevation: 0,
      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.water_drop,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 4),
                Text(
                  'Drying',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      'Temp',
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tigerTag.dryingTemperature,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Time',
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tigerTag.dryingTime,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBedTempCard(BuildContext context, ThemeData theme) {
    return Card(
      elevation: 0,
      color: theme.colorScheme.tertiaryContainer.withValues(alpha: 0.3),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.bed,
                  color: theme.colorScheme.tertiary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Bed Temperature',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      'Min',
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${tigerTag.bedTemperatureMin}°C',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Max',
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${tigerTag.bedTemperatureMax}°C',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          // TODO: Implement reset functionality
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Reset functionality not yet implemented'),
            ),
          );
        },
        icon: const Icon(Icons.refresh, size: 24),
        label: const Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            'Reset TigerTag',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
