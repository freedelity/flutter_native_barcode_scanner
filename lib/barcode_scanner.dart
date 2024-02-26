// Copyright 2023 Freedelity. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/services.dart';

export 'barcode_scanner.widget.dart';

/// List of supported barcode formats.
enum BarcodeFormat {
  code39,
  code93,
  code128,
  ean8,
  ean13,
  itf,
  codabar,
  dataMatrix,
  qrCode,
  upca,
  upce;

  /// @nodoc
  static BarcodeFormat? unserialize(int constant) {
    switch (constant) {
      case _formatCode39:
        return BarcodeFormat.code39;
      case _formatCode93:
        return BarcodeFormat.code93;
      case _formatCode128:
        return BarcodeFormat.code128;
      case _formatEan8:
        return BarcodeFormat.ean8;
      case _formatEan13:
        return BarcodeFormat.ean13;
      case _formatItf:
        return BarcodeFormat.itf;
      case _formatCodabar:
        return BarcodeFormat.codabar;
      case _formatDataMatrix:
        return BarcodeFormat.dataMatrix;
      case _formatQrCode:
        return BarcodeFormat.qrCode;
      case _formatUpca:
        return BarcodeFormat.upca;
      case _formatUpce:
        return BarcodeFormat.upce;
      default:
        return null;
    }
  }
}

/// This class encodes a barcode value.
class Barcode {
  /// Format of the barcode
  final BarcodeFormat format;

  /// Value of the barcode
  final String value;

  Barcode({required this.format, required this.value});
}

/// iOS camera orientation must be specified if the orientation is other than portrait.
/// Android camera orientation is automatically taken from system
enum CameraOrientation { portrait, landscapeLeft, landscapeRight }

/// Defines the type of scanned data
enum ScannerType { barcode, text, mrz }

/// Defines if the camera is at the front or the back of the device
enum CameraSelector { front, back }

/// This provides static methods to alter how the barcode scanning process.
abstract class BarcodeScanner {
  static const MethodChannel _channel =
      MethodChannel('be.freedelity/native_scanner/method');

  /// This allows to toggle the flashlight.
  static Future toggleFlashlight() => _channel.invokeMethod('toggleTorch');

  /// Go from back camera to front or vice versa.
  static Future flipCamera() => _channel.invokeMethod('flipCamera');

  /// Stop the scanner. No barcode will be produced until next call to `BarcodeScanner.startScanner`.
  static Future stopScanner() => _channel.invokeMethod('stopScanner');

  /// Start the scanning process. It is useful in case `BarcodeScanner.stopScanner` has been called before or if `BarcodeScannerWidget` has been created with `startScanning` set to `false`.
  static Future startScanner() => _channel.invokeMethod('startScanner');

  /// Close Android camera manually.
  static Future closeCamera() => _channel.invokeMethod('closeCamera');
}

// Constants for serializing barcode formats in event channel
// used between dart code and native code.
//
// Keep in sync with these other files:
//  - android/src/main/kotlin/be/freedelity/barcode_scanner/Constants.kt
//  - ios/Classes/Constants.swift
const int _formatCode39 = 0;
const int _formatCode93 = 1;
const int _formatCode128 = 2;
const int _formatEan8 = 3;
const int _formatEan13 = 4;
const int _formatItf = 5;
const int _formatCodabar = 6;
const int _formatDataMatrix = 7;
const int _formatQrCode = 8;
const int _formatUpca = 9;
const int _formatUpce = 10;
