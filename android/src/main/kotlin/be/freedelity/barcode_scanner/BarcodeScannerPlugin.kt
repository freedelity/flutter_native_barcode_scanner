// Copyright 2023 Freedelity. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
package be.freedelity.barcode_scanner

import android.app.Activity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodChannel

class BarcodeScannerPlugin: FlutterPlugin, ActivityAware {

  private val platformViewChannel = "be.freedelity/native_scanner/view"
  private val methodChannel = "be.freedelity/native_scanner/method"
  private val scanEventChannel = "be.freedelity/native_scanner/imageStream"

  private var barcodeScannerController: BarcodeScannerController? = null
  private lateinit var activity: Activity
  private lateinit var method: MethodChannel

  private lateinit var flutterPluginBinding: FlutterPlugin.FlutterPluginBinding

  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    method = MethodChannel(binding.binaryMessenger, methodChannel)
    method.setMethodCallHandler(barcodeScannerController)

    flutterPluginBinding = binding
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    method.setMethodCallHandler(null)
  }

  override fun onDetachedFromActivity() {
    if (barcodeScannerController != null) {
      barcodeScannerController!!.stopListening()
      barcodeScannerController = null
    }
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    this.activity = binding.activity

    barcodeScannerController = BarcodeScannerController(
      activity,
      flutterPluginBinding.binaryMessenger,
      methodChannel,
      scanEventChannel
    )

    flutterPluginBinding
      .platformViewRegistry
      .registerViewFactory(platformViewChannel, BarcodeScannerViewFactory(activity, barcodeScannerController!!))
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {onAttachedToActivity(binding)}

  override fun onDetachedFromActivityForConfigChanges() {onDetachedFromActivity()}
}
