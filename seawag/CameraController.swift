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
import FacebookCore
import FacebookLogin


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
    @IBOutlet weak var Rotate: UIButton!
    
    let socialsave = SocialSaving()
    var socialinfo: SocialInfo?
    var UserOrReturn: Bool = true
    
    var session: AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    public static var usingFrontCamera = false
    
    public static var EditorView: UIViewController?
    public static var SocialView: UIViewController?
    public static var LogOutView: UIViewController?
    
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
    var FlashIcon: Bool = false
    
    public static var ImageTaken: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        VideoSelector.setImage(nil, for: .normal)
        Editor.setImage(nil, for: .normal)
        stillImageOutput = AVCaptureStillImageOutput()
        stillImageOutput?.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        CameraController.instance = self
        CameraController.EditorView = self.storyboard?.instantiateViewController(withIdentifier: "EditorVC") as! EditorController
        CameraController.SocialView = self.storyboard?.instantiateViewController(withIdentifier: "SocialVC") as! SocialController
        CameraController.LogOutView = self.storyboard?.instantiateViewController(withIdentifier: "LogOutVC") as! LogoutController
        Rotate.setImage(nil, for: .normal)
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
    
    @IBAction func UserReturn(_ sender: UIButton) {
        if(UserOrReturn){
            self.present(CameraController.LogOutView!, animated: true, completion: nil)
        }else{
            CameraController.sharedManager.StartOrClose = true
        }
        
    }
    
    @IBAction func ChangeCamera(_ sender: UIButton) {
        CameraController.usingFrontCamera = !CameraController.usingFrontCamera
        if(CameraController.usingFrontCamera) {
            Carrete.setImage(nil, for: .normal)
            Carrete.isEnabled = false
        }
        else {
            let avDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
            
            if (avDevice?.hasTorch)! {
            Carrete.setImage(#imageLiteral(resourceName: "Flash"), for: .normal)
            }
            else{
                Carrete.setImage(nil, for: .normal)
            }
            Carrete.isEnabled = true
            FlashIcon = true
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
            //DispatchQueue.main.async {
                self.session!.startRunning()
           // }
                
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
        Userconfig.setImage(#imageLiteral(resourceName: "ReturnWhite"), for: .normal)
        UserOrReturn = false
        Rotate.setImage(#imageLiteral(resourceName: "Rotate"), for: .normal)
        let avDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        if (avDevice?.hasTorch)! {
            Carrete.setImage(#imageLiteral(resourceName: "Flash"), for: .normal)
        }
        else{
            Carrete.setImage(nil, for: .normal)
        }
        FlashIcon = true
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
            //GoStart(SoC: false)
          //  GoStart(SoC: true)
        }
        else if(Editor.isEnabled){
            self.PublicSocial()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PublicateVC") as! PublicateController
            self.present(vc, animated: true, completion: nil)
        }
        
    }
    
    func GoStart(SoC : Bool){
        if(SoC)
        {
            self.PhotoSelector.isEnabled = true
            self.PhotoSelector.setImage(#imageLiteral(resourceName: "PhotOff"), for: .normal)
            self.Center.setImage(#imageLiteral(resourceName: "Center"), for: .normal)
            self.VideoSelector.setImage(nil, for: .normal)
            self.Editor.setImage(nil, for: .normal)
            self.Editor.isEnabled = false
            
            self.WeLabel.isHidden = false
            self.Logo.image = #imageLiteral(resourceName: "Logo")
            self.Userconfig.setImage(#imageLiteral(resourceName: "UserWhite"), for: .normal)
            UserOrReturn = true
            self.Rotate.setImage(nil, for: .normal)
            self.Carrete.setImage(#imageLiteral(resourceName: "CarretWhite"), for: .normal)
            FlashIcon = false
            self.CameraScreen.image = #imageLiteral(resourceName: "Fondo")
            self.previewView.isHidden = true
        }
    }
    func TakePicture(){
        
        if let videoConnection = stillImageOutput!.connection(withMediaType: AVMediaTypeVideo) {
            stillImageOutput?.captureStillImageAsynchronously(from: videoConnection, completionHandler: { (sampleBuffer, error) -> Void in
                
                if sampleBuffer != nil {
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    let dataProvider = CGDataProvider(data: imageData as! CFData)
                    let cgImageRef = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: CGColorRenderingIntent.defaultIntent)
                    
                    var image = UIImage(cgImage: cgImageRef!, scale: 1, orientation: (CameraController.usingFrontCamera ? UIImageOrientation.leftMirrored: UIImageOrientation.right))
                    
                     let marca = UIImage(cgImage: #imageLiteral(resourceName: "marcadeAgua").cgImage!, scale: 1, orientation: (CameraController.usingFrontCamera ? UIImageOrientation.up: UIImageOrientation.up))
                    
                    image = self.compositeTwoImages(top: marca, bottom: image)!
                    /*context = CIContext()-ñ
                    currentFilter = CIFilter(name: "CIPhotoEffectProcess")
                    currentFilter.setValue(cgImageRef, forKey: kCIInputImageKey)
                    
                    if let cgimg = context.createCGImage(currentFilter.outputImage!, from: currentFilter.outputImage!.extent) {
                        image = UIImage(cgImage: cgimg, scale: 1, orientation: (CameraController.usingFrontCamera ? UIImageOrientation.leftMirrored: UIImageOrientation.right))
                    }
 
                */
                    //let beginImage = CIImage(image: image)?.applying(CGAffineTransform(rotationAngle: 0.0).scaledBy(x: 0.2, y: 0.2))
                    
                    //let imageseend = UIImage(ciImage: beginImage!)
                    CameraController.ImageTaken = self.CameraScreen
                    
                    self.CameraScreen.image = image
                    CameraController.ImageTaken.image = image
                    self.previewView.isHidden = true
                }
            })}
        
    }
    
    // composit two images
    func compositeTwoImages(top: UIImage, bottom: UIImage) -> UIImage? {
        
        //let heigt = (bottom.size.width/top.size.width)
        // begin context with new size
        UIGraphicsBeginImageContextWithOptions(bottom.size, false, 0.0)
        // draw images to context
        bottom.draw(in: CGRect(origin: CGPoint.zero, size: bottom.size))
        top.draw(in: CGRect(origin: CGPoint(x: 0, y: bottom.size.height-top.size.height*(bottom.size.width/top.size.width)), size: CGSize.init(width: bottom.size.width, height: top.size.height*(bottom.size.width/top.size.width))))
        // return the new image
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        // returns an optional
        return newImage
    }
    
    @IBAction func EditorImage(_ sender: UIButton) {
        self.present(CameraController.EditorView!, animated: true, completion: nil)
    }
    func PublicSocial()
    {
        if AccessToken.current == nil {
            
        let loginManager = LoginManager()
        loginManager.logIn([.publishActions], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                 print("Hecho el tiro.")
            }
        }
        }
        socialinfo = socialsave.getItem(index: 0)
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
                        let status = (self.socialinfo?.CommentTwitter)! + " #Seawag " + (self.socialinfo?.HashtagTwitter)!+" "+(self.socialinfo?.UsersTwitter)!
                            message["status"] = status as AnyObject?
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
                        var photo = Photo(image: self.CameraScreen.image!, userGenerated: true)
                        photo.caption = (socialinfo?.CommentFacebook)! + " #Seawag" + (socialinfo?.HashtagFacebook)!+" "+(socialinfo?.UsersFacebook)!
                        var content = PhotoShareContent(photos: [photo])
                        
                        if((socialinfo?.UsersFacebook?.isEmpty)!){
                            content.taggedPeopleIds = [(socialinfo?.UsersFacebook)!]
                        }
                        
                        if((socialinfo?.LocationFacebook?.isEmpty)!){
                           content.placeId = (socialinfo?.LocationFacebook)!
                        }
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
        if(FlashIcon)
        {
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
        }else{
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
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
    
    @IBAction func ConfigSocial(_ sender: UIButton) {
        self.present(CameraController.SocialView!, animated: true, completion: nil)
    }
}
