import Flutter
import UIKit
import AVFoundation

class BarcodeScannerViewFactory: NSObject, FlutterPlatformViewFactory {
    
    private var mainUIController: UIViewController
    private var cameraController: BarcodeScannerController
    
    init(mainUIController: UIViewController, cameraController: BarcodeScannerController) {
        self.mainUIController = mainUIController
        self.cameraController = cameraController
        super.init()
    }
    
    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return BarcodeScannerView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            cameraController: cameraController,
            mainUIController: mainUIController)
    }
}
