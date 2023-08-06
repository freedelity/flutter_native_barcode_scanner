// Copyright 2023 Freedelity. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Constants for serializing barcode formats in event channel
// used between dart code and native code.
//
// Keep in sync with these other files:
//  - lib/barcode_scanner.dart
//  - ios/Classes/Constants.swift

object BarcodeFormats {
    const val CODE_39 : Int = 0;
    const val CODE_93 : Int = 1;
    const val CODE_128 : Int = 2;
    const val EAN_8 : Int = 3;
    const val EAN_13 : Int = 4;
    const val ITF : Int = 5;
    const val CODABAR : Int = 6;
    const val DATAMATRIX : Int = 7;
    const val QR_CODE : Int = 8;
}
