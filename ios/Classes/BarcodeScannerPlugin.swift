import Flutter
import UIKit

public class BarcodeScannerPlugin: NSObject, FlutterPlugin {
    
    private var cameraController: BarcodeScannerController
    
    init(cameraController: BarcodeScannerController) {
        self.cameraController = cameraController
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {

        let viewController = (UIApplication.shared.delegate?.window??.rootViewController)!
        let cameraController = BarcodeScannerController()
        let instance = BarcodeScannerPlugin(cameraController: cameraController)
        let factory = BarcodeScannerViewFactory(mainUIController: viewController, cameraController: cameraController)

        registrar.register(factory, withId: "be.freedelity/native_scanner/view")
        
        let channel = FlutterMethodChannel(name: "be.freedelity/native_scanner/method", binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        let eventChannel = FlutterEventChannel(name: "be.freedelity/native_scanner/imageStream", binaryMessenger: registrar.messenger())
        eventChannel.setStreamHandler(cameraController)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        cameraController.handle(call, result: result)
    }
}
