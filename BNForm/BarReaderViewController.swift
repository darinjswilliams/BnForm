//
//  BarReaderViewController.swift
//  BNForm
//
//  Created by Darin Williams on 11/6/17.
//  Copyright © 2017 dwilliams. All rights reserved.
//
//  AVCaptureSession will manage data form the camera – input to output.
//  The AVCaptureDevice is the physical device and its properties. AVCaptureSession receives input data from the AVCaptureDevice.
//  AVCaptureDeviceInput captures data from the input device.
//  AVCaptureMetadataOutput forwards metadata objects to be processed by a delegate object.
//

import UIKit
import AVFoundation

class BarReaderViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    
    var session: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Create a session object
        session = AVCaptureSession()
        
        //Set the Capture Device
        let videoCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        //Create Input Device
        let videoInput: AVCaptureDeviceInput?
        
        do{
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice!)
        }catch{
            return
        }
        
        //Add input to session
        if(session.canAddInput(videoInput)){
            session.addInput(videoInput)
        }else{
            //This method is created as fall to a cellphone with no camera
            canNotScanProduct()
        }
        
        // Do any additional setup after adding input to session
        // send the capture data to the delegate object by serial queue
        // Create output Object
        let metadataOutput = AVCaptureMetadataOutput()
        
        //Add output to the session
        if(session.canAddOutput(metadataOutput)){
            
            session.addOutput(metadataOutput)
            
            //send the capture data to the delegate by serial queue
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            //Set barcode type to scan for metadata objects types
            metadataOutput.metadataObjectTypes = [
                   AVMetadataObjectTypeEAN13Code,
                   AVMetadataObjectTypeQRCode,
                   AVMetadataObjectTypeUPCECode,
                   AVMetadataObjectTypeCode128Code
            ]

            
        }else{
             canNotScanProduct()
        }
        
        // add preveiw layer so we can see the video of product
        // display  video full size of screen but will adjust it
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        //Begin capture session
        session.startRunning()
    
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if(session?.isRunning == false){
            session.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(animated)
        
        if(session?.isRunning == false){
            session.stopRunning()
        }
    }
    
    func canNotScanProduct(){
        //Scanning for a product is not possible so inform the user
        let alert = UIAlertController(title: "Scan Not Possible", message: "Device needs a camera", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated:true, completion: nil)
        session=nil
    }
    
//   captureOutput:didOutputMetadataObjects:fromConnection,
//   we celebrate, as our barcode reader found something!
//
//   First, we will get the first object from the metadataObjects array and
//   convert it into machine readable code. Then, we will send that readableCode,
//   as a string, to barcodeDetected().
//
//   Before we move on to barcodeDetected(), however, we will provide some user
//   feedback in the form of vibration and stop the capture session. If, by chance
//   we forget to stop the session, get ready for a lot of vibrating.
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {

        // Get the first object from the metadataObjects array.
        if let barcodeData = metadataObjects.first {
            // Turn it into machine readable code
            let barcodeReadable = barcodeData as? AVMetadataMachineReadableCodeObject;
            if let readableCode = barcodeReadable {
                // Send the barcode as a string to barcodeDetected()
                barcodeDetected(code: readableCode.stringValue);
            }
            
            // Vibrate the device to give the user some feedback.
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            // Avoid a very buzzy device.
            session.stopRunning()
        }
    }
    
   
    func barcodeDetected(code: String) {
        
        // Let the user know we've found something.
        let alert = UIAlertController(title: "Found a Barcode!", message: code, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Search", style: UIAlertActionStyle.destructive, handler: { action in
            
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
            } else {
                
                // Send the doctored EAN to DataService.searchAPI()
                DataService.searchAPI(codeNumber: trimmedCodeString)
            }
            
            self.navigationController?.popViewController(animated: true)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
   override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
