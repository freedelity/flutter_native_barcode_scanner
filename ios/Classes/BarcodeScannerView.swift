
import Foundation
import UIKit
import AVFoundation
import Flutter

class BarcodeScannerView: NSObject, FlutterPlatformView  {
    
    public var mainUIController: UIViewController
    private var cameraController: BarcodeScannerController
    
    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        cameraController: BarcodeScannerController,
        mainUIController: UIViewController
    ) {
        self.mainUIController = mainUIController
        self.cameraController = cameraController

        if let argumentsDictionary = args as? Dictionary<String, Any> {
            if let orientation = argumentsDictionary["orientation"] as? String {
                cameraController.setOrientation(orientation: orientation)
            }
            if let selector = argumentsDictionary["camera_selector"] as? String {
                cameraController.setSelector(selector: selector)
            }
        } 
        
        super.init()
    }
    
    func view() -> UIView {
        if checkCameraAvailability() {

            if !checkForCameraPermission() {

                AVCaptureDevice.requestAccess(for: .video) {
                    success in DispatchQueue.main.sync {
                        if !success {
                            let alert = UIAlertController(title: "Action needed", message: "Please grant camera permission to use barcode scanner", preferredStyle: .alert)
                            
                            alert.addAction(UIAlertAction(title: "Grant", style: .default, handler: { action in
                                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                            }))
                            
                            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                            
                            self.mainUIController.present(alert, animated: true)
                        }
                    }
                }
                
            }

            return cameraController.view

        } else {
            showAlertDialog(title: "Unable to proceed", message: "Camera not available")
            return UIView()
        }
    }

    /// Check for camera availability
    func checkCameraAvailability()->Bool{
        return UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    func checkForCameraPermission()->Bool{
        return AVCaptureDevice.authorizationStatus(for: .video) == .authorized
    }
    
    func showAlertDialog(title:String,message:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(alertAction)
        self.mainUIController.present(alertController, animated: true, completion: nil)
    }
    
}
