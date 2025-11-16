# RFID Scanning Feature

This document explains the RFID/NFC scanning functionality in the Spoolman Helper Flutter app.

## Overview

The app uses NFC/RFID technology to scan TigerTag RFID spools for filament inventory management. The scanning feature is built with:

- **nfc_manager** (v3.5.0) - Flutter package for NFC operations
- **Riverpod** (v3.0.3) - State management
- Material Design 3 UI

## Features

✅ **NFC Availability Check** - Detects if the device supports NFC
✅ **Real-time Scanning** - Continuously scans for RFID tags
✅ **Tag Information Display** - Shows UID and raw tag data
✅ **Scan History** - Keeps a list of all scanned tags in the session
✅ **Error Handling** - Clear error messages and status indicators
✅ **Cross-platform** - Works on both Android and iOS devices with NFC

## Architecture

### Provider Structure

**`rfid_scanner_provider.dart`** - Main provider for RFID scanning state management

Contains:
- `RfidScannerStatus` enum - Current scanner state (idle, initializing, scanning, error)
- `RfidTagData` class - Data model for scanned tags
- `RfidScannerState` class - State container for the scanner
- `rfidScannerProvider` - Notifier that manages scanning operations

### UI Structure

**`rfid_scanner_page.dart`** - Main RFID scanner page

Features:
- Welcome greeting and app description
- NFC availability status card
- Scanner status indicator with animations
- Start/Stop scanning button
- Error message display
- Scanned tags list with details dialog

## Usage

### Starting a Scan Session

1. Open the app (RFID scanner page loads automatically)
2. Check that NFC is available on your device
3. Tap "Start RFID Scanner" button
4. Hold your device near an RFID tag
5. Tag information will appear in the scanned tags list

### Reading Tag Details

1. After scanning a tag, it appears in the "Scanned Tags" list
2. Tap on any tag entry to see detailed information:
   - Full UID
   - Timestamp of when it was scanned
   - Raw tag data (platform-specific information)

### Stopping a Scan Session

1. Tap "Stop Scanning" button to end the session
2. Previously scanned tags remain in the history
3. Tap "Clear" to remove all scanned tags from history

## Platform Configuration

### Android

**Location:** `android/app/src/main/AndroidManifest.xml`

Required permissions:
```xml
<uses-permission android:name="android.permission.NFC" />
<uses-feature android:name="android.hardware.nfc" android:required="false" />
```

Intent filters configured for:
- `NDEF_DISCOVERED` - NDEF formatted tags
- `TAG_DISCOVERED` - Generic tag discovery
- `TECH_DISCOVERED` - Specific NFC technology discovery

### iOS

**Location:** `ios/Runner/Info.plist` and `ios/Runner/Runner.entitlements`

Required:
- NFCReaderUsageDescription - Explains why the app needs NFC access
- NFC tag reading entitlement
- Supported formats: NDEF and TAG

**Note:** For iOS, you need to:
1. Enable "Near Field Communication Tag Reading" capability in Xcode
2. Add the entitlements file to your target
3. Test on a physical device (NFC doesn't work in simulator)

## Supported Tag Types

The app can read multiple NFC tag types:

- **NFC-A (ISO 14443-3A)** - Most common, includes MIFARE
- **NFC-B (ISO 14443-3B)** - Less common contactless cards
- **NFC-F (JIS X 6319-4)** - FeliCa tags
- **NFC-V (ISO 15693)** - Vicinity cards
- **ISO 15693** - Long-range RFID tags

## State Management with Riverpod

### Watching Scanner State

```dart
final scannerState = ref.watch(rfidScannerProvider);

// Access current status
if (scannerState.status == RfidScannerStatus.scanning) {
  // Scanner is active
}

// Check NFC availability
if (scannerState.isNfcAvailable) {
  // NFC is supported
}

// Get last scanned tag
final lastTag = scannerState.lastScannedTag;

// Get all scanned tags
final allTags = scannerState.scannedTags;
```

### Controlling the Scanner

```dart
final notifier = ref.read(rfidScannerProvider.notifier);

// Start scanning
await notifier.startScanning();

// Stop scanning
await notifier.stopScanning();

// Clear scanned tags history
notifier.clearScannedTags();

// Clear error message
notifier.clearError();
```

## Error Handling

The scanner handles various error scenarios:

1. **NFC Not Available** - Device doesn't support NFC
2. **Session Start Failure** - Failed to initialize NFC session
3. **Tag Read Error** - Failed to read tag data
4. **Permission Denied** - User hasn't granted NFC permissions

All errors are displayed in a dismissible error card with clear messages.

## Future Enhancements

Planned features for TigerTag integration:

- [ ] Parse TigerTag-specific NDEF records
- [ ] Extract filament information (type, color, weight)
- [ ] Write data to tags
- [ ] Sync with Spoolman server
- [ ] Tag authentication/validation
- [ ] Offline mode with local storage
- [ ] Tag history and analytics

## Testing

### Android Testing

1. Build and install the app on an Android device with NFC
2. Enable NFC in device settings
3. Use any NFC tag for testing (e.g., transit cards, access cards)

### iOS Testing

1. Requires physical iPhone 7 or later with iOS 13+
2. Enable NFC in settings (if available)
3. Configure signing & capabilities in Xcode
4. Test with compatible NFC tags

**Note:** iOS has stricter NFC requirements than Android:
- Background tag reading requires App Clip activation record
- Core NFC session automatically stops after 60 seconds
- First read might require user approval

## Troubleshooting

### NFC Not Detected

**Android:**
- Check that NFC is enabled in Settings > Connections > NFC
- Ensure device has NFC hardware (not all devices do)
- Try rebooting the device

**iOS:**
- Verify device is iPhone 7 or later
- Check iOS version is 13.0 or later
- Restart the app

### Tags Not Reading

- Hold device steady over tag for 1-2 seconds
- Try different positions/angles
- Ensure tag is compatible (not encrypted or locked)
- Check if tag has any metal interference nearby

### Permission Errors

**Android:**
- Check AndroidManifest.xml has NFC permissions
- Verify app has location permission (required for some NFC operations)

**iOS:**
- Verify Info.plist has NFCReaderUsageDescription
- Check entitlements file is configured correctly
- Ensure capability is enabled in Xcode

## Resources

- [nfc_manager Documentation](https://pub.dev/packages/nfc_manager)
- [Android NFC Guide](https://developer.android.com/guide/topics/connectivity/nfc)
- [iOS Core NFC](https://developer.apple.com/documentation/corenfc)
- [NFC Forum Specifications](https://nfc-forum.org/our-work/specification-releases/)

