//
//  SocialController.swift
//  seawag
//
//  Created by Mario Dávalos on 15/11/16.
//  Copyright © 2016 Ooomovil. All rights reserved.
//

import Foundation
import UIKit

import FacebookCore
import FacebookLogin
import FacebookShare
import TwitterKit
import TwitterCore
import CoreFoundation
import Fabric
import Social

class SocialController: KeyBoardViewController , UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var SaveButton: UIButton!
    
    @IBOutlet weak var TwitterButton: UIButton!
    @IBOutlet weak var FaceButton: UIButton!
    @IBOutlet weak var CommentButton: UIImageView!
    @IBOutlet weak var HashtagButton: UIImageView!
    @IBOutlet weak var UsersButton: UIImageView!
    @IBOutlet weak var Cleaner: UIButton!
    @IBOutlet weak var CaractersNumber: UILabel!
    @IBOutlet weak var CaracteresLabel: UILabel!
    
    @IBOutlet weak var vistaUsuario: UIView!
    
    @IBOutlet weak var Comments: UITextView!
    @IBOutlet weak var Hastags: UITextView!
    @IBOutlet weak var Users: UITextView!
    
    let socialsave = SocialSaving()
    var socialinfo: SocialInfo?
    
    var socialRed: Bool? = false
    var FaceOrTwr: Bool? = false
    
    var comentariosTwitter = ""
    var hashtagsTwitter = ""
    var usuariosTwitter = ""
    
    var textFields: [UITextView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFields = [Comments, Hastags, Users]
        
        self.inicializarTextViews()
        
        self.SaveButton.layer.borderWidth = 1
        self.SaveButton.layer.borderColor =  UIColor.init(red: 98/255.0, green: 159/255.0, blue: 196/255.0, alpha: 1.0).cgColor
        self.SaveButton.layer.cornerRadius = 22.0
        
        Comments.isEditable = false
        Hastags.isEditable = false
        Users.isEditable = false
        
        Cleaner.setImage(nil, for: .normal)
        
        if(LoginController.FaceTwr==1)
        {
            FacebookInfo()
        }
        if(LoginController.FaceTwr==2)
        {
            TwitterInfo()
        }

    }
    
    func inicializarTextViews(){
        CaractersNumber.text = ""
        CaracteresLabel.text = ""
        
        Comments.text = "Comentario"
        Comments.textColor = UIColor.lightGray
        Hastags.text = "Hashtags"
        Hastags.textColor = UIColor.lightGray
        Users.text = "Etiquetar personas"
        Users.textColor = UIColor.lightGray
    }
    
    @IBAction func Closing(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func TwiterDates(_ sender: UIButton) {
        TwitterInfo()
    }
    
    func TwitterInfo(){
        
        TwitterButton.setImage(#imageLiteral(resourceName: "Twittonn"), for: .normal)
        FaceButton.setImage(#imageLiteral(resourceName: "Feceboof"), for: .normal)
        CommentButton.image = #imageLiteral(resourceName: "CommentTwr")
        HashtagButton.image = #imageLiteral(resourceName: "HashtagTwr")
        UsersButton.image = #imageLiteral(resourceName: "UserTwr")
        Cleaner.setImage(#imageLiteral(resourceName: "Eraser"), for: .normal)
        
        if(socialRed!){
            if Comments.textColor == UIColor.black {
                self.comentariosTwitter = Comments.text
            }
            if Hastags.textColor == UIColor.black {
                self.hashtagsTwitter = Hastags.text
            }
            if Users.textColor == UIColor.black {
                self.usuariosTwitter = Users.text
            }
        }
        
        self.vistaUsuario.isHidden = false
        
        let defaults = UserDefaults.standard
        
        let comentarios = defaults.string(forKey: UserDefaultsKeys.Twitter_Comments) ?? ""
        let hashtag = defaults.string(forKey: UserDefaultsKeys.Twitter_Hashtags) ?? ""
        let usuariosEtiquetados = defaults.string(forKey: UserDefaultsKeys.Twitter_Usuarios_Etiquetados) ?? ""
        
        if !comentarios.isEmpty{
            Comments.text = comentarios
            Comments.textColor = UIColor.black
        }else{
            Comments.text = "Comentario"
            Comments.textColor = UIColor.lightGray
        }
        
        if !hashtag.isEmpty{
            Hastags.text = hashtag
            Hastags.textColor = UIColor.black
        }
        else{
            Hastags.text = "Hashtags"
            Hastags.textColor = UIColor.lightGray
        }
        
        if !usuariosEtiquetados.isEmpty{
            Users.text = usuariosEtiquetados
            Users.textColor = UIColor.black}
        else{
            Users.text = "Etiquetar personas"
            Users.textColor = UIColor.lightGray
        }
        
        
        socialRed = true
        FaceOrTwr = false
        
        Comments.isEditable = true
        Hastags.isEditable = true
        Users.isEditable = true
        
        LoginController.FaceTwr = 2
        
        let comments = Comments.textColor == UIColor.black ? (Comments.text)! : ""
        let hashtags = Comments.textColor == UIColor.black ? (Comments.text)! : ""
        let uuseerss = Comments.textColor == UIColor.black ? (Comments.text)! : ""
        let cadena = comments + hashtags + uuseerss
        let Length = cadena.characters.count
        print(Length)
        CaractersNumber.text = Length <= 130 ? String(130 - Length) : "0"
        CaracteresLabel.text = "Caracteres"
        
       /* let account = ACAccountStore()
        let accountType = account.accountType(withAccountTypeIdentifier: ACAccountTypeIdentifierTwitter)
        
        account.requestAccessToAccounts(with: accountType, options: nil, completion: {(success, error) in
            
            if success {
                let arrayOfAccounts = account.accounts(with: accountType)
                
                if (arrayOfAccounts?.count)! <= 0 {
        let logInButton = TWTRLogInButton() { session, error in
            DispatchQueue.main.async {
                self.dismiss(animated: false, completion: {
                    CameraController.sharedManager.SocialValide = true
                })
            }
        }
        logInButton.loginMethods = [.webBased]
        
        // If using the log in methods on the Twitter instance
        Twitter.sharedInstance().logIn(withMethods: [.webBased]) { session, error in
            DispatchQueue.main.async {
                self.dismiss(animated: false, completion: {
                    CameraController.sharedManager.SocialValide = true
                })
            }
        }
                    
                
    }}})
        */
    }
    
    @IBAction func FaceBookDates(_ sender: UIButton) {
        FacebookInfo()
    }
    
    func FacebookInfo(){
        TwitterButton.setImage(#imageLiteral(resourceName: "Twittoff"), for: .normal)
        FaceButton.setImage(#imageLiteral(resourceName: "Faceboon"), for: .normal)
        CommentButton.image = #imageLiteral(resourceName: "CommentFace")
        HashtagButton.image = #imageLiteral(resourceName: "HashtagFace")
        UsersButton.image = #imageLiteral(resourceName: "UserFace")
        Cleaner.setImage(#imageLiteral(resourceName: "Eraser"), for: .normal)
        //LocationButton.image = #imageLiteral(resourceName: "LocationFace")
        
        
        if(socialRed!){
            if Comments.textColor == UIColor.black {
                socialinfo?.CommentTwitter = Comments.text}
            if Hastags.textColor == UIColor.black {
                socialinfo?.HashtagTwitter = Hastags.text}
            if Users.textColor == UIColor.black {
                socialinfo?.UsersTwitter = Users.text}
        }
        
        self.vistaUsuario.isHidden = true
        
        
        if(!(socialinfo?.CommentFacebook?.isEmpty)!){
            Comments.text = socialinfo?.CommentFacebook
            Comments.textColor = UIColor.black}
        else{
            Comments.text = "Comentario"
            Comments.textColor = UIColor.lightGray
        }
        if(!(socialinfo?.HashtagFacebook?.isEmpty)!){
            Hastags.text = socialinfo?.HashtagFacebook
            Hastags.textColor = UIColor.black}
        else{
            Hastags.text = "Hashtags"
            Hastags.textColor = UIColor.lightGray
        }
        if(!(socialinfo?.UsersFacebook?.isEmpty)!){
            Users.text = socialinfo?.UsersFacebook
            Users.textColor = UIColor.black}
        else{
            Users.text = "Etiquetar personas"
            Users.textColor = UIColor.lightGray
        }
        
        socialRed = true
        FaceOrTwr = true
        
        Comments.isEditable = true
        Hastags.isEditable = true
        Users.isEditable = true
        //Locations.isEnabled = true
        CaractersNumber.text = ""
        CaracteresLabel.text = ""
        
        LoginController.FaceTwr = 1
        
        if AccessToken.current == nil {
            let loginManager = LoginManager()
            loginManager.logIn([ .publishActions ], viewController: self) { loginResult in
                switch loginResult {
                case .failed(let error):
                    print(error)
                case .cancelled:
                    print("User cancelled login.")
                case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                     DispatchQueue.main.async {
                        self.dismiss(animated: false, completion: {
                            CameraController.sharedManager.SocialValide = true
                        })
                    }
                }
            }
        }
    }
    
    @IBAction func SaveInfoSocial(_ sender: UIButton) {
        if(FaceOrTwr)!{
            if Comments.textColor == UIColor.black {
                socialinfo?.CommentFacebook = Comments.text
            }
            if Hastags.textColor == UIColor.black {
                socialinfo?.HashtagFacebook = Hastags.text}
            if Users.textColor == UIColor.black {
                socialinfo?.UsersFacebook = Users.text}
        }else{
            if Comments.textColor == UIColor.black {
                socialinfo?.CommentTwitter = Comments.text}
            if Hastags.textColor == UIColor.black {
                socialinfo?.HashtagTwitter = Hastags.text}
            if Users.textColor == UIColor.black {
                socialinfo?.UsersTwitter = Users.text}
        }
        socialsave.addItem(item: socialinfo!)
        
        let defaults = UserDefaults.standard
        
        if FaceOrTwr!{
            if Comments.textColor == UIColor.black {
                socialinfo?.CommentFacebook = Comments.text
            }
            defaults.set(Hastags.text, forKey: UserDefaultsKeys.Facebook_Hashtags)
            defaults.set(Comments.text, forKey: UserDefaultsKeys.Facebook_Comments)
        }else{
            defaults.set(Hastags.text, forKey: UserDefaultsKeys.Twitter_Hashtags)
            defaults.set(Comments.text, forKey: UserDefaultsKeys.Twitter_Comments)
        }
        defaults.synchronize()
        
        let alert = UIAlertController(title: "Guardado", message: "La información se ha guardado", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches , with: event)
        self.view.endEditing(true)
    }
    
    @IBAction func CleanerEraser(_ sender: UIButton) {
        Users.text = Users.textColor == UIColor.black ? "" : (Users.text)!
        Hastags.text = Hastags.textColor == UIColor.black ? "" : (Hastags.text)!
        Comments.text =  Comments.textColor == UIColor.black ? "" : (Comments.text)!
        
        if(FaceOrTwr! == false && socialRed!){
            let comments = Comments.textColor == UIColor.black ? (Comments.text)! : ""
            let hashtags = Hastags.textColor == UIColor.black ? (Hastags.text)! : ""
            let uuseerss = Users.textColor == UIColor.black ? (Users.text)! : ""
            let cadena = comments + hashtags + uuseerss
            let Length = cadena.characters.count
            CaractersNumber.text = Length <= 128 ? String(128 - Length) : "0"
        }
    }
    
    
    @IBAction func CarreteShow(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: TextViewDelegate
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {  //guard let text = textField.text else { return true }
        
        if (text == "\n") {
            if textView == self.Comments {
                self.Hastags.becomeFirstResponder()
            }
            else if textView == self.Hastags {
                self.Users.becomeFirstResponder()
            }
            else if textView == self.Users {
                self.Users.resignFirstResponder()
                scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            }
            return true
        }
        
        var Length = 0
        if(FaceOrTwr! == false){
            let cadena = (Comments.text)!+(Hastags.text)!+(Users.text)!
            Length = (text != "") ? cadena.characters.count : cadena.characters.count - 2
            CaracteresLabel.text = "Caracteres"
            CaractersNumber.text = Length <= 128 ? String(128 - (Length)) : "0"
            //Length = 1
        }
        return Length <= 128
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    //MARK: UIImagePickerController methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let imagetak = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.dismiss(animated: true, completion:{ () -> Void in
                CameraController.sharedManager.ImageShow = imagetak
            })
            
        }
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: false, completion: nil)
        self.dismiss(animated: false, completion: nil)
        CameraController.SocialView = self.storyboard?.instantiateViewController(withIdentifier: "SocialVC") as! SocialController
         self.present(CameraController.SocialView!, animated: false, completion: nil)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            if(textView.accessibilityLabel=="Comentario"){
                textView.text = "Comentario"
            }
            if(textView.accessibilityLabel=="Hashtags"){
                textView.text = "Hashtags"
            }
            if(textView.accessibilityLabel=="Etiquetar"){
                textView.text = "Etiquetar personas"
            }
            textView.textColor = UIColor.lightGray
        }
    }
}
