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
    @IBOutlet weak var MarcaAgua: UIImageView!
    @IBOutlet weak var Carrete: UIButton!
    @IBOutlet weak var Userconfig: UIButton!
    @IBOutlet weak var PhotoSelector: UIButton!
    @IBOutlet weak var VideoSelector: UIButton!
    @IBOutlet weak var Center: UIButton!
    @IBOutlet weak var Editor: UIButton!
    @IBOutlet weak var Rotate: UIButton!
    @IBOutlet weak var Config: UIButton!
    
    @IBOutlet weak var PUBLICAR: UITextField!
    
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
            //self.CameraScreen.image = #imageLiteral(resourceName: "Fondo")
            
            DispatchQueue.main.async {
                self.GoStart(SoC: newSoC)
            }
            
            
            
        }
    }
    var ImageShow : UIImage = UIImage() {
        willSet(newSoC) {
            ImageShowOtherController(imagetak: newSoC)
        }
    }
    var SocialValide : Bool = false {
        willSet(newSoC) {
            returnSocial()
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
        Editor.imageView?.contentMode = .scaleAspectFit
        Config.imageView?.contentMode = .scaleAspectFit
        PhotoSelector.imageView?.contentMode = .scaleAspectFit
        //self.CameraScreen.image = #imageLiteral(resourceName: "Fondo")
        
        stillImageOutput = AVCaptureStillImageOutput()
        stillImageOutput?.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        CameraController.instance = self
        loadCamera()
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
                if(CameraController.ImageTaken != nil){
            CameraScreen.image = CameraController.ImageTaken.image
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    @IBAction func UserReturn(_ sender: UIButton) {
        if(UserOrReturn){
            CameraController.LogOutView = self.storyboard?.instantiateViewController(withIdentifier: "LogOutVC") as! LogoutController
            self.present(CameraController.LogOutView!, animated: true, completion: nil)
        }else{
            //CameraController.sharedManager.StartOrClose = true
            self.PhotoSelector.isEnabled = true
            self.PhotoSelector.setImage(#imageLiteral(resourceName: "PhotOff"), for: .normal)
            self.Center.setImage(#imageLiteral(resourceName: "Center"), for: .normal)
            self.PUBLICAR.isHidden = true
            self.VideoSelector.setImage(nil, for: .normal)
            self.Editor.setImage(nil, for: .normal)
            self.Editor.isEnabled = false
            
            self.WeLabel.isHidden = false
            self.Logo.image = #imageLiteral(resourceName: "Logo")
            self.Userconfig.setImage(#imageLiteral(resourceName: "UserWhite"), for: .normal)
            UserOrReturn = true
            self.Rotate.setImage(nil, for: .normal)
            self.Carrete.setImage(#imageLiteral(resourceName: "CarretWhite"), for: .normal)
            Carrete.isEnabled = true
            FlashIcon = false
            self.CameraScreen.image = #imageLiteral(resourceName: "Fondo")
            self.previewView.isHidden = true
            self.MarcaAgua.isHidden = true
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
                Carrete.isEnabled = true
            }
            else{
                Carrete.setImage(nil, for: .normal)
            }
            
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
            Carrete.isEnabled = true
        }
        else{
            Carrete.setImage(nil, for: .normal)
        }
        FlashIcon = true
        PhotoSelector.setImage(#imageLiteral(resourceName: "PhotOnn"), for: .normal)
        Center.setImage(#imageLiteral(resourceName: "Camera"), for: .normal)
        PUBLICAR.isHidden = true
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
            PUBLICAR.isHidden = false
            VideoSelector.setImage(nil, for: .normal)
            Editor.setImage(#imageLiteral(resourceName: "Edit"), for: .normal)
            Editor.isEnabled = true
            self.TakePicture()
        }
        else if(Editor.isEnabled){
            self.PublicSocial()
        }
    }
    
    func GoStart(SoC : Bool){
        if(SoC)
        {
            
            if(!self.isBeingPresented)
            {
                self.PhotoSelector.isEnabled = true
                self.PhotoSelector.setImage(#imageLiteral(resourceName: "PhotOff"), for: .normal)
                self.Center.setImage(#imageLiteral(resourceName: "Center"), for: .normal)
                self.PUBLICAR.isHidden = true
                self.VideoSelector.setImage(nil, for: .normal)
                self.Editor.setImage(nil, for: .normal)
                self.Editor.isEnabled = false
                
                self.WeLabel.isHidden = false
                self.Logo.image = #imageLiteral(resourceName: "Logo")
                self.Userconfig.setImage(#imageLiteral(resourceName: "UserWhite"), for: .normal)
                UserOrReturn = true
                self.Rotate.setImage(nil, for: .normal)
                self.Carrete.setImage(#imageLiteral(resourceName: "CarretWhite"), for: .normal)
                Carrete.isEnabled = true
                FlashIcon = false
                self.CameraScreen.image = #imageLiteral(resourceName: "Fondo")
                self.previewView.isHidden = true
            }
        }
    }
    func TakePicture(){
        
        if let videoConnection = stillImageOutput!.connection(withMediaType: AVMediaTypeVideo) {
            stillImageOutput?.captureStillImageAsynchronously(from: videoConnection, completionHandler: { (sampleBuffer, error) -> Void in
                
                if sampleBuffer != nil {
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    let dataProvider = CGDataProvider(data: imageData as! CFData)
                    let cgImageRef = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: CGColorRenderingIntent.defaultIntent)
                    
                    let imageOriginal = UIImage(cgImage: cgImageRef!, scale: 1, orientation: (CameraController.usingFrontCamera ? UIImageOrientation.leftMirrored: UIImageOrientation.right))
                    
                    //let beginImage = CIImage(image: newImage)?.applying(CGAffineTransform(rotationAngle: 0.0).scaledBy(x: 0.35, y: 0.35))
                    
                    //let imageOriginal = UIImage(ciImage: beginImage!, scale: 1, orientation: (CameraController.usingFrontCamera ? UIImageOrientation.up: UIImageOrientation.right))
                    
                     //let marca = UIImage(cgImage: #imageLiteral(resourceName: "marcadeAgua").cgImage!, scale: 1, orientation: (CameraController.usingFrontCamera ? UIImageOrientation.up: UIImageOrientation.up))
                    
                    //let image = self.compositeTwoImages(top: marca, bottom: imageOriginal)!
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
                    
                    self.CameraScreen.image = imageOriginal
                    self.MarcaAgua.isHidden = false
                    CameraController.ImageTaken.image = imageOriginal
                    self.previewView.isHidden = true
                    
                    self.Logo.image = #imageLiteral(resourceName: "Logo")
                    //self.Userconfig.setImage(#imageLiteral(resourceName: "UserWhite"), for: .normal)
                    //self.UserOrReturn = true
                    self.Rotate.setImage(nil, for: .normal)
                    self.Carrete.setImage(#imageLiteral(resourceName: "CarretWhite"), for: .normal)
                    self.Carrete.isEnabled = true
                    self.FlashIcon = false
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
        
        return newImage
    }
    
    @IBAction func EditorImage(_ sender: UIButton) {
        self.present(CameraController.EditorView!, animated: true, completion: nil)
    }
    
    func PublicSocial()
    {
        socialinfo = socialsave.getItem()
        var PublicateSuccess: Bool = true
        let marca = UIImage(cgImage: #imageLiteral(resourceName: "marcadeAgua").cgImage!, scale: 1, orientation: UIImageOrientation.up)
        
        let image = self.compositeTwoImages(top: marca, bottom: CameraController.ImageTaken.image!)!
        
        let imageDate = UIImageJPEGRepresentation(image,0.5)
        let imageString = imageDate?.base64EncodedString(options: (NSData.Base64EncodingOptions()))
        
        if AccessToken.current != nil {
            do{
                var photo = Photo(image: CameraController.ImageTaken.image!, userGenerated: true)
                
                let standar = UserDefaults.standard
                let hashtags = standar.string(forKey: UserDefaultsKeys.Facebook_Hashtags) ?? ""
                let comentarios = standar.string(forKey: UserDefaultsKeys.Facebook_Comments) ?? ""
                print((socialinfo?.UsersFacebook)!)
                photo.caption = comentarios + " #Seawag " + hashtags + " " + (socialinfo?.UsersFacebook)!
                var content = PhotoShareContent(photos: [photo])
                
                if((socialinfo?.UsersFacebook?.isEmpty)!){
                    content.taggedPeopleIds = [(socialinfo?.UsersFacebook)!]
                }
                
                let sharer = GraphSharer(content: content)
                sharer.failsOnInvalidData = true
                sharer.completion = { result in
                    
                }
                try sharer.share()
                //try ShareDialog.show(from: self, content: content)
            }catch {}
        }else{
            PublicateSuccess = false
        }

        
        let account = ACAccountStore()
        let accountType = account.accountType(withAccountTypeIdentifier: ACAccountTypeIdentifierTwitter)
                    
        account.requestAccessToAccounts(with: accountType, options: nil, completion: {(success, error) in
                                                        
            if success {
                let arrayOfAccounts = account.accounts(with: accountType)
                
                if (arrayOfAccounts?.count)! > 0 {
                        let twitterAccount = arrayOfAccounts?.first as! ACAccount
                        print(twitterAccount)
                    var message = Dictionary<String, AnyObject>()
                    
                    let standar = UserDefaults.standard
                    let hashtags = standar.string(forKey: UserDefaultsKeys.Twitter_Hashtags) ?? ""
                    let comentarios = standar.string(forKey: UserDefaultsKeys.Twitter_Comments) ?? ""
                    let social = (self.socialinfo?.UsersTwitter)!
                        var status = comentarios + " #Seawag " + hashtags + " "
                        print(status.characters.count)
                    if(status.characters.count > 140){
                       let startIndex = status.index(status.startIndex, offsetBy: 140)
                        status = status.substring(to: startIndex)}
                    
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
                }else if(!PublicateSuccess){
                    PublicateSuccess = false
                }
                if(PublicateSuccess){
                    DispatchQueue.main.async {
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PublicateVC") as! PublicateController
                        self.present(vc, animated: true, completion: nil)
                    }
                }
                else{
                    let alert = UIAlertController(title: "No hay sessiones iniciadas", message: "No se ha iniciado en ninguna red social", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            })
                    //self.tweetWithImage(data: (UIImagePNGRepresentation(image) as! NSData))
        
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
    func ImageShowOtherController(imagetak: UIImage){
        /*var image = imagetak
        
        
        let beginImage = CIImage(image: image)?.applying(CGAffineTransform(rotationAngle: 0.0).scaledBy(x: 0.4, y: 0.4))
        
        image = UIImage(ciImage: beginImage!)//, scale: 1, orientation: UIImageOrientation.right)*/
        
        let image = UIImage(data: UIImageJPEGRepresentation(imagetak, 8.0)!)
        
        //image = UIImage(cgImage: #imageLiteral(resourceName: "marcadeAgua").cgImage!, scale: 1, orientation: (CameraController.usingFrontCamera ? UIImageOrientation.up: UIImageOrientation.up))
        
        CamerVision = false
        PhotoSelector.setImage(nil, for: .normal)
        PhotoSelector.isEnabled = false
        Center.setImage(#imageLiteral(resourceName: "Public"), for: .normal)
        PUBLICAR.isHidden = false
        VideoSelector.setImage(nil, for: .normal)
        Editor.setImage(#imageLiteral(resourceName: "Edit"), for: .normal)
        Editor.isEnabled = true
        
        CameraController.ImageTaken = self.CameraScreen
        
        self.CameraScreen.image = image
        self.MarcaAgua.isHidden = false
        CameraController.ImageTaken.image = image
        self.previewView.isHidden = true
        
        self.Logo.image = #imageLiteral(resourceName: "Logo")
        self.Userconfig.setImage(#imageLiteral(resourceName: "ReturnWhite"), for: .normal)
        self.UserOrReturn = false
        self.Rotate.setImage(nil, for: .normal)
        self.Carrete.setImage(#imageLiteral(resourceName: "CarretWhite"), for: .normal)
        Carrete.isEnabled = true
        self.FlashIcon = false
        self.WeLabel.isHidden = true
        
        CameraController.EditorView = self.storyboard?.instantiateViewController(withIdentifier: "EditorVC") as! EditorController
        
    }
    //MARK: UIImagePickerController methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let imagetak = info[UIImagePickerControllerOriginalImage] as? UIImage {
            ImageShowOtherController(imagetak: imagetak)
        }
        self.dismiss(animated: true, completion: nil)
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
        CameraController.SocialView = self.storyboard?.instantiateViewController(withIdentifier: "SocialVC") as! SocialController
        self.present(CameraController.SocialView!, animated: true, completion: nil)
    }
    func returnSocial(){
        CameraController.SocialView = self.storyboard?.instantiateViewController(withIdentifier: "SocialVC") as! SocialController
        self.present(CameraController.SocialView!, animated: false, completion: nil)
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
