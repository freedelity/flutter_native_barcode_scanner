// Copyright 2023 Freedelity. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
package be.freedelity.barcode_scanner

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.pm.PackageManager
import android.view.View
import androidx.camera.view.PreviewView
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.plugin.platform.PlatformView
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors

internal class BarcodeScannerView(activity: Activity, barcodeScannerController: BarcodeScannerController, context: Context, creationParams: Map<String?, Any?>?) : PlatformView {

    private val cameraExecutor: ExecutorService = Executors.newSingleThreadExecutor()
    private val previewView: PreviewView = PreviewView(context)

    override fun getView(): View {
        return previewView
    }

    override fun dispose() {
        cameraExecutor.shutdown()
    }

    init {

        if( allPermissionsGranted(context) ) {
            barcodeScannerController.startCamera(creationParams, context, previewView, cameraExecutor)
        } else {
            ActivityCompat.requestPermissions(activity, REQUIRED_PERMISSIONS, REQUEST_CODE_PERMISSIONS)
        }

        barcodeScannerController.startCamera(creationParams, context, previewView, cameraExecutor)
    }

    companion object {
        private const val REQUEST_CODE_PERMISSIONS = 10
        private val REQUIRED_PERMISSIONS =
            mutableListOf (
                Manifest.permission.CAMERA
            ).toTypedArray()
    }

    private fun allPermissionsGranted(context: Context) = REQUIRED_PERMISSIONS.all {
        ContextCompat.checkSelfPermission(context, it) == PackageManager.PERMISSION_GRANTED
    }
}
