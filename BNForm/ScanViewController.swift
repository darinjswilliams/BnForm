//
//  ScanViewController.swift
//  BNForm
//
//  Created by Darin Williams on 10/8/17.
//  Copyright © 2017 dwilliams. All rights reserved.
//

import UIKit
import AVFoundation


class CameraView:UIView{
    
    //display video as it is being capture by input device
    override class var layerClass: AnyClass{
        get{
            return AVCaptureVideoPreviewLayer.self
        }
    }
    
    override var layer: AVCaptureVideoPreviewLayer{
        get{
            return super.layer as! AVCaptureVideoPreviewLayer
        }
    }
}

class ScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var cameraView: CameraView!
    
    //capture session
    let session = AVCaptureSession()
    
    //dispatch queue
    let sessionQueue = DispatchQueue(label: AVCaptureSession.self.description(), attributes: [], target:nil)
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
        //intialize session for scan
        session.beginConfiguration()
        
        let videoDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        if(videoDevice != nil){
            
           let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice)
            
            if(videoDeviceInput != nil){
                
                if(session.canAddInput(videoDeviceInput)){
                    session.addInput(videoDeviceInput)
                    
                } else {
                    
                    scanNotPossible()
                }
                
            }
            
            let metaDataOutput = AVCaptureMetadataOutput()
            
            if(session.canAddOutput(metaDataOutput)){
                
                session.addOutput(metaDataOutput)
                
                //Define the QR and bar types to read
                metaDataOutput.metadataObjectTypes = [
                
                    AVMetadataObjectTypeEAN13Code,
                    AVMetadataObjectTypeQRCode,
                    AVMetadataObjectTypeUPCECode,
                    AVMetadataObjectTypeCode128Code
                
                ]
                
                metaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            }
            
            
        }
        
        session.commitConfiguration()
        cameraView.layer.session = session
        cameraView.layer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        
        //configure orientation
        let videoOrientation: AVCaptureVideoOrientation
        
        switch UIApplication.shared.statusBarOrientation {
        case .portrait:
            videoOrientation = .portrait
            
        case .portraitUpsideDown:
            videoOrientation = .portraitUpsideDown
            
        case .landscapeLeft:
            videoOrientation = .landscapeLeft
            
        case .landscapeRight:
            videoOrientation = .landscapeRight
        
       
        default:
            videoOrientation = .portrait
        }
        
        cameraView.layer.connection.videoOrientation = videoOrientation
        
    }
    
    func scanNotPossible(){
        
        //let user know that scanning is possible with device
        let alert =  UIAlertController(title: "Can not Scan device", message: "Update software", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
       present(alert, animated: true, completion: nil)
    }
    
    override func loadView() {
        cameraView = CameraView()
        
        view = cameraView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func homeBtnPressed(_ sender: Any) {
        print("HomeButton Pressed")
        
        performSegue(withIdentifier: "scanToHome", sender: self)
    }
    
    @IBAction func scanShareBttn(_ sender: Any) {
        let activityVC = UIActivityViewController(activityItems: ["www.google.com"], applicationActivities: nil)
        
        activityVC.popoverPresentationController?.sourceView = self.view
        
        self.present(activityVC, animated: true, completion: nil)
        
    }
    @IBAction func productSearch(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "goSearchProduct", sender: self)
    }
    
    
    @IBAction func createReport(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "goCreateReport", sender: self)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sessionQueue.async {
            self.session.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sessionQueue.async {
            self.session.stopRunning()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
       
        super.viewWillTransition(to: size, with: coordinator)
        
        //update orientation
        let videoOrientation: AVCaptureVideoOrientation
        
        switch  UIDevice.current.orientation {
        case .portrait:
            videoOrientation = .portrait
            
        case .portraitUpsideDown:
            videoOrientation = .portraitUpsideDown
            
        case .landscapeLeft:
            videoOrientation = .landscapeLeft
            
        case .landscapeRight:
            videoOrientation = .landscapeRight
            
            
        default:
            videoOrientation = .portrait
        }
        
        cameraView.layer.connection.videoOrientation = videoOrientation
    }
    
    
    //function that reads QR and Barcode
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        if(metadataObjects.count > 0 && metadataObjects.first is AVMetadataMachineReadableCodeObject){
            
           if let barCodeInfo = metadataObjects.first{
            
              //turn into human readable
            let barcodeReadable = barCodeInfo as? AVMetadataMachineReadableCodeObject;
            
            if let readableCode = barcodeReadable{
                
                //send scan barcode down stream as readable code
                detectedBarCode(code: readableCode.stringValue)
             }
            }//end of BarCodeInfo
            
        }
    }
        func detectedBarCode(code: String){
            
        
            
            let alertController = UIAlertController(title: "Found a Product Scanned", message: code, preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "Search", style: .default, handler: { action in
            
                // Remove the spaces.
                let trimmedCode = code.trimmingCharacters(in:  NSCharacterSet.whitespaces)
                
                // EAN or UPC?
                // Check for added "0" at beginning of code.
                
                let trimmedCodeString = "\(trimmedCode)"
                var trimmedCodeNoZero: String
                
                if trimmedCodeString.hasPrefix("0") && trimmedCodeString.characters.count > 1 {
                    trimmedCodeNoZero = String(trimmedCodeString.characters.dropFirst())
                    
                    // Send the doctored UPC to DataService.searchAPI()
                    DataService.searchAPI(codeNumber: trimmedCodeNoZero)
                    print("Trimmed code with zero..." ,trimmedCodeNoZero)
                } else {
                    
                    // Send the doctored EAN to DataService.searchAPI()
                    DataService.searchAPI(codeNumber: trimmedCodeString)
                    print("Trimmed code with zero...", trimmedCode)
                }

            
            }))
            
            // Vibrate the device to give the user some feedback.
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            
            present(alertController, animated: true, completion: nil)

    }
        
    

}
