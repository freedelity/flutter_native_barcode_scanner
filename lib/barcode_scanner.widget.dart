// Copyright 2023 Freedelity. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'barcode_scanner.dart';

/// Defines if the camera is at the front or the back of the device
enum CameraSelector {front, back}

/// Widget displaying the camera stream while scanning barcodes.
class BarcodeScannerWidget extends StatefulWidget {

  /// Select which camera should be used when creating the widget.
  final CameraSelector? cameraSelector;

  /// Indicates if the barcode scanning process should start when creating the widget.
  final bool startScanning;

  /// Indicates if barcode scanning should stop after a barcode is detected. If `false`, `onBarcodeDetected` may be triggered multiple times for the same barcode.
  final bool stopScanOnBarcodeDetected;

  /// This function will be called when a barcode is detected.
  final Function(Barcode barcode) onBarcodeDetected;

  final Function(dynamic error) onError;

  const BarcodeScannerWidget({
    Key? key,
    this.cameraSelector,
    this.startScanning = true,
    this.stopScanOnBarcodeDetected = true,
    required this.onBarcodeDetected,
    required this.onError
  }) : super(key: key);

  @override
  _BarcodeScannerWidgetState createState() => _BarcodeScannerWidgetState();
}

class _BarcodeScannerWidgetState extends State<BarcodeScannerWidget> {

  static const String platformViewChannel = 'be.freedelity/scanner/view';
  static const EventChannel eventChannel = EventChannel('be.freedelity/scanner/imageStream');

  late Map<String, dynamic> creationParams;

  @override
  void initState() {
    super.initState();

    creationParams = {
      'camera_selector': widget.cameraSelector?.name,
      'start_scanning': widget.startScanning
    };

    eventChannel.receiveBroadcastStream().listen((dynamic event) async {
      final format = BarcodeFormat.unserialize(event['format']);
      if( format != null ) {
        await BarcodeScanner.stopScanner();

        await widget.onBarcodeDetected(Barcode(format: format, value: event['barcode'] as String));

        if(!widget.stopScanOnBarcodeDetected) {
          BarcodeScanner.startScanner();
        }
      }

    }, onError: (dynamic error) {
      widget.onError(error);
    });
  }

  @override
  Widget build(BuildContext context) {

    if (Platform.isIOS) {
      return UiKitView(
          viewType: platformViewChannel,
          layoutDirection: TextDirection.ltr,
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec()
      );
    }

    return Stack(
        children: [
          PlatformViewLink(
              viewType: platformViewChannel,
              surfaceFactory: (context, controller) {
                return AndroidViewSurface(
                  controller: controller as AndroidViewController,
                  gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
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
                    }
                )
                  ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated);
              }
          ),
          const Positioned.fill(
              child: ModalBarrier(dismissible: false, color: Colors.transparent)
          )
        ]
    );
  }
}
