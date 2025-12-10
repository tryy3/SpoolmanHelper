import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spoolman_helper_flutter/providers/aspect_lookup_provider.dart';
import 'package:spoolman_helper_flutter/providers/diameter_lookup_provider.dart';
import 'package:spoolman_helper_flutter/providers/id_type_lookup_provider.dart';
import 'package:spoolman_helper_flutter/providers/material_lookup_provider.dart';
import 'package:spoolman_helper_flutter/providers/measurement_unit_lookup_provider.dart';
import '../providers/rfid_scanner_provider.dart';
import '../providers/brand_lookup_provider.dart';
import '../widgets/tiger_tag_detail_sheet.dart';
import '../models/tiger_tag_extensions.dart';

/// Main RFID Scanner Page
class RfidScannerPage extends ConsumerStatefulWidget {
  const RfidScannerPage({super.key});

  @override
  ConsumerState<RfidScannerPage> createState() => _RfidScannerPageState();
}

class _RfidScannerPageState extends ConsumerState<RfidScannerPage> {
  @override
  Widget build(BuildContext context) {
    // Listen for newly scanned TigerTags and show the detail sheet
    ref.listen<RfidScannerState>(
      rfidScannerProvider,
      (previous, next) {
        // Check if a new tag with TigerTag data was scanned
        if (next.lastScannedTag != null &&
            next.lastScannedTag!.tigerTag != null &&
            (previous?.lastScannedTag != next.lastScannedTag)) {
          // Show the bottom sheet for the new TigerTag
          showTigerTagDetailSheet(
            context,
            next.lastScannedTag!.tigerTag!,
          );
        }
      },
    );

    final scannerState = ref.watch(rfidScannerProvider);
    final theme = Theme.of(context);

    final syncState = ref.watch(brandSyncProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Spoolman Helper'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
      floatingActionButton: _buildSyncFab(ref, syncState, theme),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Greeting Section
              _buildGreetingSection(theme),
              const SizedBox(height: 32),

              // NFC Availability Status
              _buildNfcStatusCard(scannerState, theme),
              const SizedBox(height: 24),

              // Scanner Status
              _buildScannerStatus(scannerState, theme),
              const SizedBox(height: 24),

              // Action Button
              _buildActionButton(context, ref, scannerState, theme),
              const SizedBox(height: 24),

              // Error Message
              if (scannerState.errorMessage != null)
                _buildErrorMessage(ref, scannerState, theme),

              // Scanned Tags List
              if (scannerState.scannedTags.isNotEmpty) ...[
                const SizedBox(height: 24),
                _buildScannedTagsList(ref, scannerState, theme),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGreetingSection(ThemeData theme) {
    return Column(
      children: [
        Icon(
          Icons.nfc,
          size: 64,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 16),
        Text(
          'Welcome to Spoolman Helper',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Scan TigerTag RFID spools to manage your filament inventory',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildNfcStatusCard(RfidScannerState state, ThemeData theme) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              state.isNfcAvailable ? Icons.check_circle : Icons.error,
              color: state.isNfcAvailable ? Colors.green : Colors.orange,
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'NFC Status',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    state.isNfcAvailable
                        ? 'NFC is available and ready'
                        : 'NFC is not available on this device',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScannerStatus(RfidScannerState state, ThemeData theme) {
    String statusText;
    IconData statusIcon;
    Color statusColor;

    switch (state.status) {
      case RfidScannerStatus.idle:
        statusText = 'Ready to scan';
        statusIcon = Icons.radio_button_unchecked;
        statusColor = theme.colorScheme.onSurface.withValues(alpha: 0.6);
        break;
      case RfidScannerStatus.initializing:
        statusText = 'Initializing scanner...';
        statusIcon = Icons.refresh;
        statusColor = Colors.orange;
        break;
      case RfidScannerStatus.scanning:
        statusText = 'Scanning for RFID tags...';
        statusIcon = Icons.nfc;
        statusColor = Colors.blue;
        break;
      case RfidScannerStatus.error:
        statusText = 'Error occurred';
        statusIcon = Icons.error_outline;
        statusColor = Colors.red;
        break;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(statusIcon, color: statusColor),
        const SizedBox(width: 12),
        Text(
          statusText,
          style: theme.textTheme.titleMedium?.copyWith(
            color: statusColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (state.status == RfidScannerStatus.scanning) ...[
          const SizedBox(width: 12),
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(statusColor),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    WidgetRef ref,
    RfidScannerState state,
    ThemeData theme,
  ) {
    final isScanning = state.status == RfidScannerStatus.scanning;
    final isInitializing = state.status == RfidScannerStatus.initializing;
    final isDisabled = !state.isNfcAvailable || isInitializing;

    return ElevatedButton.icon(
      onPressed: isDisabled
          ? null
          : () {
              if (isScanning) {
                ref.read(rfidScannerProvider.notifier).stopScanning();
              } else {
                ref.read(rfidScannerProvider.notifier).startScanning();
              }
            },
      icon: Icon(
        isScanning ? Icons.stop : Icons.nfc,
        size: 28,
      ),
      label: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Text(
          isScanning ? 'Stop Scanning' : 'Start RFID Scanner',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: isScanning ? Colors.red : theme.colorScheme.primary,
        foregroundColor: Colors.white,
        disabledBackgroundColor: theme.colorScheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildErrorMessage(
    WidgetRef ref,
    RfidScannerState state,
    ThemeData theme,
  ) {
    return Card(
      color: Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                state.errorMessage!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.red.shade900,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                ref.read(rfidScannerProvider.notifier).clearError();
              },
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScannedTagsList(
    WidgetRef ref,
    RfidScannerState state,
    ThemeData theme,
  ) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Scanned Tags (${state.scannedTags.length})',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  ref.read(rfidScannerProvider.notifier).clearScannedTags();
                },
                icon: const Icon(Icons.clear_all),
                label: const Text('Clear'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Card(
              child: ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: state.scannedTags.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final tag = state.scannedTags[
                      state.scannedTags.length - 1 - index]; // Reverse order

                  final brandName = ref
                      .read(brandSyncProvider.notifier)
                      .getBrandName(tag.tigerTag!.idBrand);
                  final materialName = ref
                      .read(materialSyncProvider.notifier)
                      .getMaterialName(tag.tigerTag!.materialID);
                  return ListTile(
                    leading: tag.tigerTag != null
                        ? CircleAvatar(
                            backgroundColor: tag.tigerTag!.primaryColor,
                            child: Icon(
                              Icons.fiber_manual_record,
                              color: Colors.white,
                            ),
                          )
                        : CircleAvatar(
                            backgroundColor: theme.colorScheme.primary,
                            child: Icon(
                              Icons.nfc,
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                    title: Text(
                      tag.tigerTag != null
                          ? '$brandName - $materialName'
                          : 'UID: ${tag.uid}',
                      style: TextStyle(
                        fontFamily: tag.tigerTag != null ? null : 'monospace',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        if (tag.tigerTag != null) ...[
                          Text(
                            '$brandName - ${tag.tigerTag!.measurementValueWithUnit}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: Colors.green.shade700,
                            ),
                          ),
                          const SizedBox(height: 2),
                        ] else
                          Text(
                            'Type: ${tag.tagType}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        const SizedBox(height: 4),
                        Text(
                          'Scanned: ${_formatDateTime(tag.scannedAt)}',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                    onTap: () {
                      // Show TigerTag detail sheet if available, otherwise show raw data dialog
                      if (tag.tigerTag != null) {
                        showTigerTagDetailSheet(context, tag.tigerTag!);
                      } else {
                        _showTagDetailsDialog(context, tag);
                      }
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}:'
        '${dateTime.second.toString().padLeft(2, '0')}';
  }

  void _showTagDetailsDialog(BuildContext context, RfidTagData tag) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('TigerTag Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('UID:', tag.uid),
              const SizedBox(height: 8),
              _buildDetailRow('Type:', tag.tagType),
              const SizedBox(height: 8),
              _buildDetailRow('Scanned:', tag.scannedAt.toString()),

              // Tag Info
              if (tag.tagInfo.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text(
                  'Tag Information:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: tag.tagInfo.entries
                        .where((e) => e.key != 'tigertag')
                        .map((e) => Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: Text(
                                '${e.key}: ${e.value}',
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 12,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ],

              // Raw Memory Hex Dump
              if (tag.rawMemory != null && tag.rawMemory!.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  'Raw Memory (${tag.rawMemory!.length} bytes):',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SelectableText(
                    _formatHexDump(tag.rawMemory!),
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      color: Colors.greenAccent,
                    ),
                  ),
                ),
              ],

              // TigerTag Parsed Data (when implemented)
              if (tag.tagInfo['tigertag'] != null) ...[
                const SizedBox(height: 16),
                const Text(
                  'TigerTag Data:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Text(
                    tag.tagInfo['tigertag'].toString(),
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  /// Format bytes as a hex dump with addresses
  String _formatHexDump(List<int> bytes) {
    final buffer = StringBuffer();
    for (int i = 0; i < bytes.length; i += 16) {
      // Address
      buffer.write('${i.toRadixString(16).padLeft(4, '0')}:  ');

      // Hex values
      for (int j = 0; j < 16; j++) {
        if (i + j < bytes.length) {
          buffer.write('${bytes[i + j].toRadixString(16).padLeft(2, '0')} ');
        } else {
          buffer.write('   ');
        }
        if (j == 7) buffer.write(' '); // Extra space in the middle
      }

      // ASCII representation
      buffer.write(' |');
      for (int j = 0; j < 16 && i + j < bytes.length; j++) {
        final byte = bytes[i + j];
        if (byte >= 32 && byte <= 126) {
          buffer.write(String.fromCharCode(byte));
        } else {
          buffer.write('.');
        }
      }
      buffer.write('|\n');
    }
    return buffer.toString();
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SelectableText(
            value,
            style: const TextStyle(fontFamily: 'monospace'),
          ),
        ),
      ],
    );
  }

  Widget _buildSyncFab(
    WidgetRef ref,
    BrandSyncState syncState,
    ThemeData theme,
  ) {
    final isSyncing = syncState.status == BrandSyncStatus.syncing;

    // Show success message when sync completes
    ref.listen<BrandSyncState>(
      brandSyncProvider,
      (previous, next) {
        if (previous?.status == BrandSyncStatus.syncing &&
            next.status == BrandSyncStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Brand database synced successfully!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        } else if (next.status == BrandSyncStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.errorMessage ?? 'Failed to sync brands'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
    );

    return FloatingActionButton(
      onPressed: isSyncing
          ? null
          : () {
              ref.read(brandSyncProvider.notifier).syncBrands();
              ref.read(materialSyncProvider.notifier).syncMaterials();
              ref.read(aspectSyncProvider.notifier).syncAspects();
              ref.read(diameterSyncProvider.notifier).syncDiameters();
              ref.read(idTypeSyncProvider.notifier).syncIdTypes();
              ref
                  .read(measurementUnitSyncProvider.notifier)
                  .syncMeasurementUnits();
            },
      tooltip: 'Sync Lookups Database',
      backgroundColor: isSyncing ? Colors.grey : theme.colorScheme.secondary,
      child: isSyncing
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : const Icon(Icons.sync),
    );
  }
}
