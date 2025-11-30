import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spoolman_helper_flutter/providers/aspect_lookup_provider.dart';
import 'package:spoolman_helper_flutter/providers/diameter_lookup_provider.dart';
import 'package:spoolman_helper_flutter/providers/id_type_lookup_provider.dart';
import 'package:spoolman_helper_flutter/providers/material_lookup_provider.dart';
import 'package:spoolman_helper_flutter/providers/measurement_unit_lookup_provider.dart';
import 'package:spoolman_helper_flutter/providers/rfid_scanner_provider.dart';
import '../models/filament_transfer_event.dart';
import '../models/tiger_tag.dart';
import '../models/tiger_tag_extensions.dart';
import '../providers/brand_lookup_provider.dart';
import '../services/kafka_bridge_service.dart';

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
                    _buildMetadataDisplay(context, theme),
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

                    // Action buttons
                    _buildActionButtons(context, theme, ref),
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

  Widget _buildMetadataDisplay(BuildContext context, ThemeData theme) {
    return Center(
      child: Text(
        tigerTag.metadataString,
        style: theme.textTheme.displayMedium?.copyWith(
          fontWeight: FontWeight.bold,
          fontFamily: 'monospace',
        ),
        textAlign: TextAlign.center,
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

  Widget _buildActionButtons(
      BuildContext context, ThemeData theme, WidgetRef ref) {
    return Column(
      children: [
        // Move Filament Location button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _showLocationScanOverlay(context, ref),
            icon: const Icon(Icons.location_on, size: 24),
            label: const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Move Filament Location',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Reset TigerTag button
        SizedBox(
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
        ),
      ],
    );
  }

  /// Show the location scanning overlay dialog
  Future<void> _showLocationScanOverlay(
      BuildContext context, WidgetRef ref) async {
    // Show the scanning dialog
    final result = await showDialog<LocationScanResult>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => _LocationScanDialog(ref: ref),
    );

    if (!context.mounted) return;

    // Handle the result
    if (result != null && result.isSuccess) {
      // Send filament transfer event to Kafka
      final kafkaResult = await _sendFilamentTransferEvent(
        ref,
        tigerTag,
        result.locationId!,
      );

      if (!context.mounted) return;

      if (kafkaResult.success) {
        await _showResultDialog(
          context,
          isSuccess: true,
          title: 'Transfer Successful',
          message:
              'Filament moved to location ${result.locationId}\n\nTransfer event sent to server.',
        );
      } else {
        await _showResultDialog(
          context,
          isSuccess: false,
          title: 'Transfer Failed',
          message:
              'Location scanned: ${result.locationId}\n\nFailed to send event:\n${kafkaResult.errorMessage}',
        );
      }
    } else if (result != null && result.isError) {
      await _showResultDialog(
        context,
        isSuccess: false,
        title: 'Scan Error',
        message: result.errorMessage ?? 'Unknown error occurred',
      );
    }
    // If cancelled, do nothing - just return to the sheet
  }

  /// Show a result dialog for success or error
  Future<void> _showResultDialog(
    BuildContext context, {
    required bool isSuccess,
    required String title,
    required String message,
  }) async {
    final theme = Theme.of(context);

    await showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: Icon(
          isSuccess ? Icons.check_circle : Icons.error,
          size: 48,
          color: isSuccess ? Colors.green : Colors.red,
        ),
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium,
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: isSuccess ? Colors.green : Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('OK'),
            ),
          ),
        ],
      ),
    );
  }

  /// Build and send filament transfer event to Kafka
  Future<KafkaEventResult> _sendFilamentTransferEvent(
    WidgetRef ref,
    TigerTag tigerTag,
    String locationId,
  ) async {
    // Get lookup data from providers
    final brandName =
        ref.read(brandSyncProvider.notifier).getBrandName(tigerTag.idBrand);
    final materialName = ref
        .read(materialSyncProvider.notifier)
        .getMaterialName(tigerTag.materialID);
    final diameterString = ref
        .read(diameterSyncProvider.notifier)
        .getDiameterString(tigerTag.diameterID);

    // Parse spoolId from metadata
    final spoolId = tigerTag.spoolId;
    if (spoolId == null) {
      return KafkaEventResult.error(
        'No spoolId found in TigerTag metadata (expected #S-<id> format)',
      );
    }

    // Parse diameter value from string (e.g., "1.75 mm" -> 1.75)
    final diameterMatch = RegExp(r'(\d+\.?\d*)').firstMatch(diameterString);
    final diameter = diameterMatch != null
        ? double.tryParse(diameterMatch.group(1)!) ?? 1.75
        : 1.75;

    // Build the filament transfer event
    final event = FilamentTransferEvent(
      spoolId: spoolId,
      locationId: locationId,
      timestamp: DateTime.now(),
      tagData: FilamentTagData(
        id: tigerTag.tigerTagID.toString(),
        name: '$brandName - $materialName',
        material: materialName,
        color: tigerTag.colorHex,
        temperature: TemperatureInfo(
          nozzle: tigerTag.nozzleTemperatureMax,
          bed: tigerTag.bedTemperatureMax,
        ),
        diameter: diameter,
        weight: tigerTag.measurementValue,
      ),
    );

    // Send to Kafka
    return KafkaBridgeService().sendFilamentTransferEvent(event);
  }
}

/// Dialog widget for location tag scanning
class _LocationScanDialog extends ConsumerStatefulWidget {
  final WidgetRef ref;

  const _LocationScanDialog({required this.ref});

  @override
  ConsumerState<_LocationScanDialog> createState() =>
      _LocationScanDialogState();
}

class _LocationScanDialogState extends ConsumerState<_LocationScanDialog> {
  bool _isScanning = false;
  String? _statusMessage;

  @override
  void initState() {
    super.initState();
    _startScanning();
  }

  Future<void> _startScanning() async {
    setState(() {
      _isScanning = true;
      _statusMessage = 'Hold your phone near the location tag...';
    });

    final result =
        await widget.ref.read(rfidScannerProvider.notifier).scanLocationTag();

    if (!mounted) return;

    // Return the result to the parent
    Navigator.of(context).pop(result);
  }

  Future<void> _cancelScanning() async {
    await widget.ref.read(rfidScannerProvider.notifier).cancelLocationScan();
    if (!mounted) return;
    Navigator.of(context).pop(LocationScanResult.cancelled());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Row(
        children: [
          Icon(
            Icons.nfc,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 12),
          const Text('Scan Location Tag'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isScanning) ...[
            const SizedBox(height: 16),
            const CircularProgressIndicator(),
            const SizedBox(height: 24),
          ],
          Text(
            _statusMessage ?? 'Preparing scanner...',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Make sure to scan a location tag, not a filament tag.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _cancelScanning,
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
