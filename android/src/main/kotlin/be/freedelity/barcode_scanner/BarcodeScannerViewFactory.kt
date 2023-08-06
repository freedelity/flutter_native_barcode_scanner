// Copyright 2023 Freedelity. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
package be.freedelity.barcode_scanner

import android.app.Activity
import android.content.Context
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class BarcodeScannerViewFactory(private val activity: Activity, private val barcodeScannerController: BarcodeScannerController) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {
        return BarcodeScannerView(activity, barcodeScannerController, context!!, args as Map<String?, Any?>?)
    }
}
