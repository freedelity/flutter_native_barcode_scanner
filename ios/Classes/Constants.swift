// Copyright 2023 Freedelity. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Constants for serializing barcode formats in event channel
// used between dart code and native code.
//
// Keep in sync with these other files:
//  - lib/barcode_scanner.dart
//  - android/src/main/kotlin/be/freedelity/barcode_scanner/Constants.kt

struct BarcodeFormats {
    static let CODE_39: Int = 0
    static let CODE_93: Int = 1
    static let CODE_128: Int = 2
    static let EAN_8: Int = 3
    static let EAN_13: Int = 4
    static let ITF: Int = 5
    static let DATAMATRIX: Int = 7
    static let QR_CODE: Int = 8
    static let UPC_E: Int = 10
}