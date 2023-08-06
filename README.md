# native_barcode_scanner

A flutter plugin to scan barcodes using the device camera.

## Platform Support

| Android |  iOS    |
| :-----: | :-----: |
|   ✅    |   ✅    |

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
