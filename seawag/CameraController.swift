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
import FacebookShare
import TwitterKit
import TwitterCore
import CoreFoundation
import Fabric
import Social


class CameraController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var CameraScreen: UIImageView!
    @IBOutlet var previewView: UIView!
    @IBOutlet weak var WeLabel: UILabel!
    @IBOutlet weak var Logo: UIImageView!
    @IBOutlet weak var Carrete: UIButton!
    @IBOutlet weak var Userconfig: UIButton!
    @IBOutlet weak var PhotoSelector: UIButton!
    @IBOutlet weak var VideoSelector: UIButton!
    @IBOutlet weak var Center: UIButton!
    @IBOutlet weak var Editor: UIButton!
    
    
    var session: AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    public static var usingFrontCamera = false
    var StartOrClose : Bool = true {
        willSet(newSoC) {
            GoStart(SoC: newSoC)
        }
    }
    static var instance = CameraController()
    class var sharedManager: CameraController {
        struct Static {
            static let instance = CameraController.instance
        }
        return Static.instance
    }
    
    var on: Bool = false
    var CamerVision: Bool = false
    
    public static var ImageTaken: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Editor.setImage(nil, for: .normal)
        stillImageOutput = AVCaptureStillImageOutput()
        stillImageOutput?.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        CameraController.instance = self
        
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
        CamerVision = true
    }
  
    @IBAction func TakePhoto(_ sender: UIButton) {
        if(CamerVision){
            CamerVision = false
            PhotoSelector.setImage(nil, for: .normal)
            PhotoSelector.isEnabled = false
            Center.setImage(#imageLiteral(resourceName: "Public"), for: .normal)
            VideoSelector.setImage(nil, for: .normal)
            Editor.setImage(#imageLiteral(resourceName: "Edit"), for: .normal)
            Editor.isEnabled = true
            self.TakePicture()
            GoStart(SoC: false)
          //  GoStart(SoC: true)
        }
        else if(Editor.isEnabled){
            self.PublicSocial()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PublicateVC") as! PublicateController
            self.present(vc, animated: true, completion: { () -> Void in
            
            })
        }
        
    }
    
    func GoStart(SoC : Bool){
        if(SoC)
        {
            self.PhotoSelector.isEnabled = true
            self.PhotoSelector.setImage(#imageLiteral(resourceName: "PhotOff"), for: .normal)
            self.Center.setImage(#imageLiteral(resourceName: "Center"), for: .normal)
            self.VideoSelector.setImage(#imageLiteral(resourceName: "VideOff"), for: .normal)
            self.Editor.setImage(nil, for: .normal)
            self.Editor.isEnabled = false
            
            self.WeLabel.isHidden = false
            self.Logo.image = #imageLiteral(resourceName: "Logo")
            self.Userconfig.setImage(#imageLiteral(resourceName: "UserWhite"), for: .normal)
            self.Carrete.setImage(#imageLiteral(resourceName: "CarretWhite"), for: .normal)
            self.CameraScreen.image = #imageLiteral(resourceName: "Fondo")
        }
    }
    func TakePicture(){
        
        if let videoConnection = stillImageOutput!.connection(withMediaType: AVMediaTypeVideo) {
            stillImageOutput?.captureStillImageAsynchronously(from: videoConnection, completionHandler: { (sampleBuffer, error) -> Void in
                
                if sampleBuffer != nil {
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    let dataProvider = CGDataProvider(data: imageData as! CFData)
                    let cgImageRef = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: CGColorRenderingIntent.defaultIntent)
                    let image = UIImage(cgImage: cgImageRef!, scale: 1, orientation: (CameraController.usingFrontCamera ? UIImageOrientation.leftMirrored: UIImageOrientation.right)
                        
                    )
                    //let beginImage = CIImage(image: image)?.applying(CGAffineTransform(rotationAngle: 0.0).scaledBy(x: 0.2, y: 0.2))
                    
                    //let imageseend = UIImage(ciImage: beginImage!)
                    CameraController.ImageTaken = self.CameraScreen
                    self.CameraScreen.image = image
                    CameraController.ImageTaken.image = image
                    self.previewView.isHidden = true
                }
            })}
        
    }
    func PublicSocial()
    {
        
        let imageDate = UIImageJPEGRepresentation(self.CameraScreen.image!,0.1)
        let imageString = imageDate?.base64EncodedString(options: (NSData.Base64EncodingOptions()))
                    
        let account = ACAccountStore()
        let accountType = account.accountType(withAccountTypeIdentifier: ACAccountTypeIdentifierTwitter)
                    
        account.requestAccessToAccounts(with: accountType, options: nil, completion: {(success, error) in
                                                        
            if success {
                let arrayOfAccounts = account.accounts(with: accountType)
                                                            
                if (arrayOfAccounts?.count)! > 0 {
                        let twitterAccount = arrayOfAccounts?.first as! ACAccount
                        var message = Dictionary<String, AnyObject>()
                            message["status"] = "Testing 1" as AnyObject?
                            message["media[]"] = imageString as AnyObject?
                            //message["media"] = imageDate as AnyObject?
                        let requestURL = NSURL(string:"https://api.twitter.com/1.1/statuses/update_with_media.json")
                        let postRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.POST, url: requestURL as URL!, parameters: message)
                                                                
                            postRequest?.account = twitterAccount
                            postRequest?.addMultipartData(imageDate, withName: "media[]", type: "image/jpeg", filename: "image.jpg")
                            postRequest?.perform(handler: { data, response, error -> Void in                                                             if let err = error {
                                                        print("Error : \(err.localizedDescription)")
                                                    }
                                                        print("Twitter HTTP response \(response?.statusCode)")
                                                })
                                            }
                                    }
                    })
                    //self.tweetWithImage(data: (UIImagePNGRepresentation(image) as! NSData))
                    do{
                        let photo = Photo(image: self.CameraScreen.image!, userGenerated: true)
                        let content = PhotoShareContent(photos: [photo])
                        let sharer = GraphSharer(content: content)
                        sharer.failsOnInvalidData = true
                        sharer.completion = { result in
                            // Handle share results
                        }
                        try sharer.share()
                        //try ShareDialog.show(from: self, content: content)
                    }catch {}
    }
                    //self.post(tweetString: "publicacion correcta", tweetImage: (UIImagePNGRepresentation(image) as! NSData))
        
                    //self.post(toService: SLServiceTypeFacebook)
                    //self.post(toService: SLServiceTypeTwitter)
                    
                    //self.tweetWithImage(data: (UIImagePNGRepresentation(image))
                    
                    
                     /*
                    // Swift
                    let composer = TWTRComposer()
                    
                    composer.setText("Seawag")
                    composer.setImage(image)
                    
                    
                    // Called from a UIViewController
                    composer.show(from: self) { result in
                        if (result == TWTRComposerResult.cancelled) {
                            print("Tweet composition cancelled")
                        }
                        else {
                            print("Sending tweet!")
                        }
                    }
                    // */
 /*
    func tweetWithImage(data:NSData)
    {
        
        let account = ACAccountStore()
        let accountType = account.accountType(
            withAccountTypeIdentifier: ACAccountTypeIdentifierTwitter)
        
        account.requestAccessToAccounts(with: accountType, options: [:]) {
            (success: Bool, error: Error?) -> Void in
                                                    if success {
                                                        let arrayOfAccounts =
                                                            account.accounts(with: accountType)
                                                        
                                                        if (arrayOfAccounts?.count)! > 0 {
                                                            let twitterAccount = arrayOfAccounts?.first as! ACAccount
                                                            var message = Dictionary<String, AnyObject>()
                                                            message["status"] = "Test Tweet with image" as AnyObject?
                                                            
                                                            let requestURL = NSURL(string:
                                                                "https://api.twitter.com/1.1/statuses/update.json")
                                                            let postRequest = SLRequest(forServiceType:
                                                                SLServiceTypeTwitter,
                                                                                        requestMethod: SLRequestMethod.POST,
                                                                                        url: requestURL as URL!,
                                                                                        parameters: message)
                                                            
                                                            postRequest?.account = twitterAccount
                                                            postRequest?.addMultipartData(data as Data!, withName: "media", type: nil, filename: nil)
                                                            
                                                            postRequest?.perform(handler: { data, response, error -> Void in                                                             if let err = error {
                                                                    print("Error : \(err.localizedDescription)")
                                                                }
                                                                print("Twitter HTTP response \(response?.statusCode)")
                                                            
                                                            })
                                                        }
                                                    }
                                                    else
                                                    {
                                                        // do what you want here
                                                        
                                                    }
        }
    }
    
    
    
    func nsdataToJSON (data: Data) -> Any? {
        do {
            return try JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers)
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil
    }
    
    func post (tweetString: String, tweetImage: NSData) {
        
        let client = TWTRAPIClient()
        let uploadUrl = "https://upload.twitter.com/1.1/media/upload.json"
        let updateUrl = "https://api.twitter.com/1.1/statuses/update.json"
        let imageString = tweetImage.base64EncodedString(options: NSData.Base64EncodingOptions())
        let request = client.urlRequest(withMethod: "POST", url: uploadUrl, parameters: ["media": imageString], error: nil)
        client.sendTwitterRequest(request, completion: { (urlResponse, data, connectionError) -> Void in
            
            if let mediaDict = (self.nsdataToJSON(data: (data!)) as AnyObject?) {
                let validTweetString: String // = TweetValidator().validTween(tweetString)
                validTweetString = "mensaje"
                let message = ["status": validTweetString, "media_ids": mediaDict["media_id_string"]!] as [String : Any]
                let request = client.urlRequest(withMethod: "POST", url: updateUrl, parameters: message, error:nil)
                
                client.sendTwitterRequest(request, completion: { (response, data, connectionError) -> Void in
                })
            }
        })
    }
    
    func nsdataToJSON (data: NSData) -> Any? {
        do {
            return try JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers)
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil
    }
    */
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
