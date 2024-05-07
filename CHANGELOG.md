## 1.0.10
- Kotlin DSL for example app
- Bug fix : Fix Android supported version to 1.8
- Bug fix : Define close camera channel method for iOS

## 1.0.9

- Bug fix : Android camera already in use after close, preventing its use on other screens
- Bug fix : barcode event could be sent after the widget has been detached from the widget tree.

## 1.0.8

- Bug fix : the iOS default permission request never start the camera even when agreed

## 1.0.7

- Android : Upgrade AGP 8

## 1.0.6

- Support MRZ Scanner for Android

## 1.0.5

- Bug fix : iOS landscape view clipped since iOS 16

## 1.0.4

- Quick fix : iOS build failure

## 1.0.3

- Bug fix : BarcodeScanner onError callback is never called
- Bug fix : iOS missing Codabar format
- Support format upca/upce for Android
- Support format upce for iOS (upca is not available)

## 1.0.2

- Bug fix : update iOS .podspec file
- Bug fix : fix example app

## 1.0.1

- Update readme

## 1.0.0

- First release with Android and iOS support.
