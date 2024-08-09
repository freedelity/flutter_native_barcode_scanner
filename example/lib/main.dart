// Copyright 2023 Freedelity. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:native_barcode_scanner/barcode_scanner.dart';

void main() async {
  runZonedGuarded(() async {
    DartPluginRegistrant.ensureInitialized();
    WidgetsFlutterBinding.ensureInitialized();

    runApp(const MyApp());
  }, (e, stacktrace) async {
    debugPrint('$e, $stacktrace');
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

enum CameraActions { flipCamera, toggleFlashlight, stopScanner, startScanner, setOverlay, navigate }

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Builder(builder: (builderContext) {
      return const MyDemoApp();
    }));
  }
}

class MyDemoApp extends StatefulWidget {

  const MyDemoApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyDemoAppState();
}

class _MyDemoAppState extends State<MyDemoApp> {

  int? progress;
  bool withOverlay = true;
  ScannerType scannerType = ScannerType.mrz;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(title: Text('Scanner ${scannerType.name} example'), actions: [
          PopupMenuButton<CameraActions>(
            onSelected: (CameraActions result) {
              switch (result) {
                case CameraActions.flipCamera:
                  BarcodeScanner.flipCamera();
                  break;
                case CameraActions.toggleFlashlight:
                  BarcodeScanner.toggleFlashlight();
                  break;
                case CameraActions.stopScanner:
                  BarcodeScanner.stopScanner();
                  break;
                case CameraActions.startScanner:
                  BarcodeScanner.startScanner();
                  break;
                case CameraActions.setOverlay:
                  setState(() => withOverlay = !withOverlay);
                  break;
                case CameraActions.navigate:
                  navigate();
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<CameraActions>>[
              const PopupMenuItem<CameraActions>(
                value: CameraActions.startScanner,
                child: Text('Start scanner'),
              ),
              const PopupMenuItem<CameraActions>(
                value: CameraActions.stopScanner,
                child: Text('Stop scanner'),
              ),
              const PopupMenuItem<CameraActions>(
                value: CameraActions.flipCamera,
                child: Text('Flip camera'),
              ),
              const PopupMenuItem<CameraActions>(
                value: CameraActions.toggleFlashlight,
                child: Text('Toggle flashlight'),
              ),
              PopupMenuItem<CameraActions>(
                value: CameraActions.setOverlay,
                child: Text('${withOverlay ? 'Remove' : 'Add'} overlay'),
              ),
              const PopupMenuItem<CameraActions>(
                value: CameraActions.navigate,
                child: Text('Navigate push'),
              ),
            ],
          ),
        ]),
        body: Stack(
          children: [
            Positioned.fill(
              child: Builder(builder: (builderContext) {
                Widget child = BarcodeScannerWidget(
                  scannerType: ScannerType.mrz,
                  onBarcodeDetected: (barcode) async {
                    await showDialog(
                        context: builderContext,
                        builder: (dialogContext) {
                          return Align(
                              alignment: Alignment.center,
                              child: Card(
                                  margin: const EdgeInsets.all(24),
                                  child: Container(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(mainAxisSize: MainAxisSize.min, children: [Text('barcode : ${barcode.value}'), Text('format : ${barcode.format.name}'), ElevatedButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Close dialog'))]))));
                        });
                  },
                  onTextDetected: (String text) async {
                    await showDialog(
                      context: builderContext,
                      builder: (dialogContext) {
                        return Align(
                          alignment: Alignment.center,
                          child: Card(
                            margin: const EdgeInsets.all(24),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('text : \n$text'),
                                  ElevatedButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Close dialog')),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  onScanProgress: (int? progress) => setState(() => this.progress = progress),
                  onMrzDetected: (String text, Uint8List bytes) {
                    setState(() => progress = null);
                    showDialog(
                      context: builderContext,
                      builder: (dialogContext) {
                        return Align(
                          alignment: Alignment.center,
                          child: Card(
                            margin: const EdgeInsets.all(24),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(text),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    child: Image.memory(bytes),
                                  ),
                                  ElevatedButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Close dialog')),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  onError: (dynamic error) {
                    debugPrint('$error');
                  },
                );

                if (withOverlay) {
                  return buildWithOverlay(builderContext, child);
                }

                return child;

              }),
            ),
            progress == null ? Container() : Positioned(
              bottom: 0, left: 0, right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                color: Colors.white,
                child: Row(
                  children: [
                    const Expanded(child: LinearProgressIndicator()),
                    const SizedBox(width: 16,),
                    Text('$progress %'),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  buildWithOverlay(BuildContext builderContext, Widget scannerWidget) {
    return Stack(children: [
      Positioned.fill(child: scannerWidget),
      Align(alignment: Alignment.center, child: Divider(color: Colors.red[400], thickness: 0.8)),
      Center(child: Container(margin: const EdgeInsets.symmetric(horizontal: 64), width: double.infinity, height: 200, decoration: BoxDecoration(border: Border.all(color: Colors.white, width: 2), borderRadius: BorderRadius.circular(15)))),
      Positioned(
          top: 16,
          right: 16,
          child: ElevatedButton(
              style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.purple), foregroundColor: WidgetStatePropertyAll(Colors.white), shape: WidgetStatePropertyAll(CircleBorder()), padding: WidgetStatePropertyAll(EdgeInsets.all(8))),
              onPressed: () {
                ScaffoldMessenger.of(builderContext).showSnackBar(const SnackBar(content: Text('Icon button pressed')));
              },
              child: const Icon(Icons.refresh, size: 32))),
    ]);
  }

  navigate() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return Scaffold(
          appBar: AppBar(
            title: const Text('Navigate test view'),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                width: double.infinity,
              ),
              const Text('Press back button'),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const MyDemoApp()));
                  },
                  child: const Text('Back'))
            ],
          ));
    }));
  }
}
