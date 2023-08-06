import Flutter
import UIKit

public class BarcodeScannerPluginSwift: NSObject, FlutterPlugin {
    
    private var cameraController: BarcodeScannerController
    
    init(cameraController: BarcodeScannerController) {
        self.cameraController = cameraController
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        
        let viewController = (UIApplication.shared.delegate?.window??.rootViewController)!
        let cameraController = BarcodeScannerController()
        let factory = BarcodeScannerViewFactory(mainUIController: viewController, cameraController: cameraController)
        let instance = BarcodeScannerPluginSwift(cameraController: cameraController)
        
        registrar.register(factory, withId: "be.freedelity/scanner/view")
        
        let channel = FlutterMethodChannel(name: "be.freedelity/scanner/method", binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        let eventChannel = FlutterEventChannel(name: "be.freedelity/scanner/imageStream", binaryMessenger: registrar.messenger())
        eventChannel.setStreamHandler(cameraController)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        cameraController.handle(call, result: result)
    }
}
