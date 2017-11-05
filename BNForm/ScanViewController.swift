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
            
            let scan = metadataObjects.first as! AVMetadataMachineReadableCodeObject
            
            let alertController = UIAlertController(title: "Product Scanned", message: scan.stringValue, preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            // Vibrate the device to give the user some feedback.
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))

            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
