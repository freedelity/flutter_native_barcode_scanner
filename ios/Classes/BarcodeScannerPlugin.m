#import "BarcodeScannerPlugin.h"
#if __has_include(<barcode_scanner/barcode_scanner-Swift.h>)
#import <barcode_scanner/barcode_scanner-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "barcode_scanner-Swift.h"
#endif

@implementation BarcodeScannerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [BarcodeScannerPluginSwift registerWithRegistrar:registrar];
}
@end
