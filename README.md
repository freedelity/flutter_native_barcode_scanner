# native_barcode_scanner

A fast flutter plugin to scan barcodes and QR codes using the device camera.

This plugin offers good performance compared to other plugins by minimizing the amount of data that is transferred between the Dart VM and the native side.

Most of the operations are actually done in the native side by using native SDK for barcode recognition and using [`PlatformView`](https://docs.flutter.dev/platform-integration/android/platform-views) to show the camera stream.

Barcode recognition is based on these SDK:
- [Google ML Kit Vision](https://developers.google.com/ml-kit/vision/barcode-scanning) on Android
- [Capture subsystem of AVFoundation](https://developer.apple.com/documentation/avfoundation/capture_setup) on iOS

The `PlatformView` allows to avoid transferring every video frame to let the plugin client display it inside a classical Flutter view.
Using PlatformView has a performance trade-off compared to Flutter views but having to copy every frames through platform channels is much more costly.
Even for devices with an older version than Android 10 (where `PlatformViews` induced a bigger performance penalty), using `PlatformView` gives better performance than other plugins exchanging image stream across platform channels.

## Platform Support

| Android |  iOS    |
| :-----: | :-----: |
|   ✅    |   ✅    |

## Barcode format Supported

|   Format   | Android |  iOS    |
|:----------:|:-------:| :-----: |
|  CODE-39   |    ✅    |   ✅    |
|  CODE-93   |    ✅    |   ✅    |
|  CODE-128  |    ✅    |   ✅    |
|   EAN-8    |    ✅    |   ✅    |
|   EAN-13   |    ✅    |   ✅    |
|    ITF     |    ✅    |   ✅    |
|  Codabar   |    ✅    |   ✅    |
| DataMatrix |    ✅    |   ✅    |
|   QRCode   |    ✅    |   ✅    |
|   UPC-A    |    ✅    |   ❌    |
|   UPC-E    |    ✅    |   ✅    |

## Getting Started

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  native_barcode_scanner: ^1.0.0
```

## Usage

Then you just have to import the package with

```dart
import 'package:native_barcode_scanner/barcode_scanner.dart';
```

Then, create a `BarcodeScannerWidget` in your widget tree where you want to show the camera stream. This widget has a `onBarcodeDetected` callback which can be used to be notified when barcodes are detected and let you process them:

```dart
@override
  Widget build(BuildContext context) {
    return BarcodeScannerWidget(
      onBarcodeDetected: (barcode) {
        print('Barcode detected: ${barcode.value} (format: ${barcode.format.name})');
      }
    );
  }
```

If you need to manipulate the behaviour of the barcode scanning process, you may use the static methods of the `BarcodeScanner` class.
