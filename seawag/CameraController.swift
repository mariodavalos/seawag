//
//  CameraController.swift
//  seawag
//
//  Created by Mario Dávalos on 11/11/16.
//  Copyright © 2016 Ooomovil. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices
import AVFoundation

class CameraController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var CameraScreen: UIImageView!
    @IBOutlet var previewView: UIView!
    @IBOutlet weak var WeLabel: UILabel!
    @IBOutlet weak var Logo: UIImageView!
    @IBOutlet weak var Carrete: UIButton!
    @IBOutlet weak var Userconfig: UIButton!
    @IBOutlet weak var PhotoSelector: UIButton!
    @IBOutlet weak var Center: UIButton!
    @IBOutlet weak var Editor: UIButton!
    
    
    var session: AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    public static var usingFrontCamera = false
    var on: Bool = false
    
    public static var ImageTaken: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Editor.setImage(nil, for: .normal)
        stillImageOutput = AVCaptureStillImageOutput()
        stillImageOutput?.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCamera()
        if(CameraController.ImageTaken != nil){
            CameraScreen.image = CameraController.ImageTaken.image
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    @IBAction func CameraFront(_ sender: UIButton) {
        CameraController.usingFrontCamera = !CameraController.usingFrontCamera
        if(CameraController.usingFrontCamera) {
            Carrete.setImage(nil, for: .normal)
            Carrete.isEnabled = false
        }
        else {
            Carrete.setImage(#imageLiteral(resourceName: "Flash"), for: .normal)
            Carrete.isEnabled = true
        }
        loadCamera()
    }
    
    func loadCamera() {
        if(session == nil){
            session = AVCaptureSession()
            session!.sessionPreset = AVCaptureSessionPresetPhoto
        }
        var error: NSError?
        var input: AVCaptureDeviceInput!
        
        do {
            input = try AVCaptureDeviceInput(device: (CameraController.usingFrontCamera ? getFrontCamera() : getBackCamera()))
        } catch let error1 as NSError {
            error = error1
            input = nil
            print(error!.localizedDescription)
        }
        
        for i : AVCaptureDeviceInput in (self.session?.inputs as! [AVCaptureDeviceInput]){
            self.session?.removeInput(i)
        }
        if error == nil && session!.canAddInput(input) {
            session!.addInput(input)
           
            if session!.canAddOutput(stillImageOutput) {
                session!.addOutput(stillImageOutput)
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
            videoPreviewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
            self.previewView.layer.addSublayer(videoPreviewLayer!)
            DispatchQueue.main.async {
                self.session!.startRunning()
            }
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        videoPreviewLayer!.frame = previewView.bounds
    }
    @IBAction func didTakePhoto(_ sender: UIButton) {
        
        previewView.isHidden = false
        WeLabel.isHidden = true
        Logo.image = nil
        Userconfig.setImage(#imageLiteral(resourceName: "Rotate"), for: .normal)
        Carrete.setImage(#imageLiteral(resourceName: "Flash"), for: .normal)
        PhotoSelector.setImage(#imageLiteral(resourceName: "PhotOnn"), for: .normal)
        Center.setImage(#imageLiteral(resourceName: "Camera"), for: .normal)
        Editor.setImage(nil, for: .normal)
        Editor.isEnabled = false
    }
    
    @IBAction func TakePhoto(_ sender: UIButton) {
        if let videoConnection = stillImageOutput!.connection(withMediaType: AVMediaTypeVideo) {
            stillImageOutput?.captureStillImageAsynchronously(from: videoConnection, completionHandler: { (sampleBuffer, error) -> Void in
          
                if sampleBuffer != nil {
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    let dataProvider = CGDataProvider(data: imageData as! CFData)
                    let cgImageRef = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: CGColorRenderingIntent.defaultIntent)
                    let image = UIImage(cgImage: cgImageRef!, scale: 1, orientation: (CameraController.usingFrontCamera ? UIImageOrientation.leftMirrored: UIImageOrientation.right)
                        )
             
                    CameraController.ImageTaken = self.CameraScreen
                    self.CameraScreen.image = image
                    CameraController.ImageTaken.image = image
                    self.previewView.isHidden = true
                }
            })
        }
        Editor.setImage(#imageLiteral(resourceName: "Edit"), for: .normal)
        Editor.isEnabled = true
    }
    
    @IBAction func ActivateFlash(_ sender: UIButton) {
        let avDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        if (avDevice?.hasTorch)! {
            do {
                _ = try avDevice?.lockForConfiguration()
            } catch {}
            if on == true {
                avDevice?.torchMode = AVCaptureTorchMode.off
                on = false
            } else {
                do {
                    _ = try avDevice?.setTorchModeOnWithLevel(1.0)
                    on = true
                } catch {}
            }
            avDevice?.unlockForConfiguration()
        }
    }
    
    func getFrontCamera() -> AVCaptureDevice?{
        let videoDevices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
        
        
        for device in videoDevices!{
            let device = device as! AVCaptureDevice
            if device.position == AVCaptureDevicePosition.front {
                return device
            }
        }
        return nil
    }
    
    func getBackCamera() -> AVCaptureDevice{
        return AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
    }
    
}
