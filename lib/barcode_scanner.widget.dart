// Copyright 2023 Freedelity. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'barcode_scanner.dart';

/// Widget displaying the camera stream while scanning barcodes.
class BarcodeScannerWidget extends StatefulWidget {
  /// Select which camera should be used when creating the widget.
  final CameraSelector cameraSelector;

  /// Indicates if the barcode scanning process should start when creating the widget.
  final bool startScanning;

  /// Indicates if barcode scanning should stop after a barcode is detected. If `false`, `onBarcodeDetected` may be triggered multiple times for the same barcode.
  final bool stopScanOnBarcodeDetected;

  /// The orientation of the camera. Default set as Prortait
  final CameraOrientation orientation;

  /// The type of scanner which should decode the image and scan data
  final ScannerType scannerType;

  /// This function will be called when a barcode is detected.
  final Function(Barcode barcode)? onBarcodeDetected;

  /// This function will be called when a bloc of text or a MRZ is detected.
  final Function(String textResult)? onTextDetected;

  final Function(dynamic error) onError;

  const BarcodeScannerWidget(
      {Key? key,
        this.cameraSelector = CameraSelector.back,
        this.startScanning = true,
        this.stopScanOnBarcodeDetected = true,
        this.orientation = CameraOrientation.portrait,
        this.scannerType = ScannerType.barcode,
        this.onBarcodeDetected,
        this.onTextDetected,
        required this.onError})
      : assert(onBarcodeDetected != null || onTextDetected != null), super(key: key);

  @override
  State<BarcodeScannerWidget> createState() => _BarcodeScannerWidgetState();
}

class _BarcodeScannerWidgetState extends State<BarcodeScannerWidget> {
  static const String platformViewChannel = 'be.freedelity/native_scanner/view';
  static const EventChannel eventChannel =
  EventChannel('be.freedelity/native_scanner/imageStream');

  late Map<String, dynamic> creationParams;
  late StreamSubscription eventSubscription;

  @override
  void initState() {
    super.initState();

    creationParams = {
      'orientation': widget.orientation.name,
      'scanner_type': widget.scannerType.name,
      'camera_selector': widget.cameraSelector.name,
      'start_scanning': widget.startScanning,
    };

    eventSubscription = eventChannel.receiveBroadcastStream().listen((dynamic event) async {
      if (widget.onBarcodeDetected != null && widget.scannerType == ScannerType.barcode) {
        final format = BarcodeFormat.unserialize(event['format']);
        if (format != null) {
          await BarcodeScanner.stopScanner();

          await widget.onBarcodeDetected!(Barcode(format: format, value: event['barcode'] as String));

          if (!widget.stopScanOnBarcodeDetected) {
            BarcodeScanner.startScanner();
          }
        }
      } else if (widget.onTextDetected != null && widget.scannerType != ScannerType.barcode) {
        if (widget.scannerType == ScannerType.mrz) {
          await BarcodeScanner.stopScanner();
          await widget.onTextDetected!(event['mrz'] as String);
        } else {
          await widget.onTextDetected!(event['text'] as String);
        }
      }
    }, onError: (dynamic error) {
      widget.onError(error);
    });
  }

  @override
  void dispose() {
    eventSubscription.cancel();
    BarcodeScanner.closeCamera();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return UiKitView(
          viewType: platformViewChannel,
          layoutDirection: TextDirection.ltr,
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec());
    }

    return Stack(children: [
      PlatformViewLink(
          viewType: platformViewChannel,
          surfaceFactory: (context, controller) {
            return AndroidViewSurface(
              controller: controller as AndroidViewController,
              gestureRecognizers: const <Factory<
                  OneSequenceGestureRecognizer>>{},
              hitTestBehavior: PlatformViewHitTestBehavior.opaque,
            );
          },
          onCreatePlatformView: (params) {
            return PlatformViewsService.initExpensiveAndroidView(
                id: params.id,
                viewType: platformViewChannel,
                layoutDirection: TextDirection.ltr,
                creationParams: creationParams,
                creationParamsCodec: const StandardMessageCodec(),
                onFocus: () {
                  params.onFocusChanged(true);
                })
              ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated);
          }),
      const Positioned.fill(
          child: ModalBarrier(dismissible: false, color: Colors.transparent))
    ]);
  }
}
