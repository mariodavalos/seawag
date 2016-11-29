//
//  SocialController.swift
//  seawag
//
//  Created by Mario Dávalos on 15/11/16.
//  Copyright © 2016 Ooomovil. All rights reserved.
//

import Foundation
import UIKit

class SocialController: UIViewController , UITextFieldDelegate {
    
    @IBOutlet weak var SaveButton: UIButton!
    
    @IBOutlet weak var TwitterButton: UIButton!
    @IBOutlet weak var FaceButton: UIButton!
    @IBOutlet weak var CommentButton: UIImageView!
    @IBOutlet weak var HashtagButton: UIImageView!
    @IBOutlet weak var UsersButton: UIImageView!
    @IBOutlet weak var LocationButton: UIImageView!
    @IBOutlet weak var Cleaner: UIButton!
    @IBOutlet weak var CaractersNumber: UILabel!
    @IBOutlet weak var CaracteresLabel: UILabel!
    
    @IBOutlet weak var Comments: UITextField!
    @IBOutlet weak var Hastags: UITextField!
    @IBOutlet weak var Users: UITextField!
    @IBOutlet weak var Locations: UITextField!
    
    let socialsave = SocialSaving()
    var socialinfo: SocialInfo?
    
    var socialRed: Bool? = false
    var FaceOrTwr: Bool? = false
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var BottomConstrain: NSLayoutConstraint!
    
    var keyboardHeight:CGFloat!
    var textFields: [UITextField]!
    var KeyShow: Bool = false
    
    @IBOutlet weak var TopConstrain: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addGestureReogizer()
        textFields = [Comments, Hastags, Users]
        
        CaractersNumber.text = ""
        CaracteresLabel.text = ""
        
        self.SaveButton.layer.borderWidth = 1
        self.SaveButton.layer.borderColor =  UIColor.init(red: 98/255.0, green: 159/255.0, blue: 196/255.0, alpha: 1.0).cgColor
        self.SaveButton.layer.cornerRadius = 22.0
        TwitterButton.imageView?.contentMode = .scaleAspectFit
        FaceButton.imageView?.contentMode = .scaleAspectFit
        
        socialinfo = socialsave.getItem(index: 0)
        Comments.isEnabled = false
        Hastags.isEnabled = false
        Users.isEnabled = false
        Locations.isEnabled = false
        LocationButton.image = nil
        Cleaner.setImage(nil, for: .normal)
        // Keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    func adjustingHeight(show:Bool, notification:NSNotification) {
        
        var userInfo = notification.userInfo!
        
        let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        
        UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
            if(self.Hastags.isEditing){
                self.TopConstrain.constant = -self.Comments.frame.size.height
            }
            else if(self.Users.isEditing){
                self.TopConstrain.constant = -self.Comments.frame.size.height*2
            }
            else {
                self.TopConstrain.constant = 0
            }
        })
    }
    
    @IBOutlet weak var ScrollDates: UIScrollView!
    
    @IBOutlet weak var StackDates: UIStackView!
    func setScrollViewPosition(){
        BottomConstrain.constant = keyboardHeight + 40
        self.view.layoutIfNeeded()
        
        // Calculamos la altura de la pantalla
        
        let screenSize: CGRect = UIScreen.main.bounds
        let screenHeight: CGFloat = screenSize.height
        
        // Recorremos el array de textFields en busca de quien tiene el foco
        for textField in textFields {
            if textField.isFirstResponder {
                var yPositionField: CGFloat = 0.0
                var yPositionScrol: CGFloat = 0.0
                // Guardamos la altura del UITextField
                let heightField = textField.frame.size.height
                // Guardamos la posición 'Y' del UITextField
                let heighttop = StackDates.frame.origin.y
                if(textField.placeholder=="Comentario"){
                    yPositionField = heighttop + ((heightField+7) * 1)
                    yPositionScrol = (heighttop-100) + ((heightField+7) * 3)
                }
                if(textField.placeholder=="Hashtag"){
                    yPositionField = heighttop + ((heightField+7) * 2)
                    yPositionScrol = (heighttop-100) + ((heightField) * 2)
                }
                if(textField.placeholder=="Etiquetar personas"){
                    yPositionField = heighttop + ((heightField+7) * 3)
                    yPositionScrol = (heighttop-100) + ((heightField) * 1)
                }
                // Calculamos la 'Y' máxima del UITextField
                let yPositionMaxField = yPositionField + heightField
                // Calculamos la 'Y' máxima del View que no queda oculta por el teclado
                let Ymax = screenHeight - keyboardHeight
                // Comprobamos si nuestra 'Y' máxima del UITextField es superior a la Ymax
                if Ymax < yPositionMaxField {
                    // Comprobar si la 'Ymax' el UITextField es más grande que el tamaño de la pantalla
                    if yPositionMaxField > screenHeight {
                        let diff = yPositionMaxField - screenHeight
                        print("El UITextField se sale por debajo \(diff) unidades")
                        // Hay que añadir la distancia a la que está por debajo el UITextField ya que se sale del screen height
                        scrollView.setContentOffset(CGPoint(x: 0, y: self.keyboardHeight + diff), animated: true)
                    }else{
                        // El UITextField queda oculto por el teclado, entonces movemos el Scroll View
                        scrollView.setContentOffset(CGPoint(x: 0, y: self.keyboardHeight - yPositionScrol), animated: true)
                    }
                }else{print("NO MUEVO EL SCROLL")}
            }
        }
    }
    func keyboardWillShow(notification: NSNotification) {
        let info:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardHeight = keyboardSize.height
        KeyShow = true
        setScrollViewPosition()
    }
    func keyboardWillHide(notification: NSNotification) {
        BottomConstrain.constant = 0
        self.view.layoutIfNeeded()
        KeyShow = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func Closing(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func TwiterDates(_ sender: UIButton) {
        TwitterButton.setImage(#imageLiteral(resourceName: "Twittonn"), for: .normal)
        FaceButton.setImage(#imageLiteral(resourceName: "Feceboof"), for: .normal)
        CommentButton.image = #imageLiteral(resourceName: "CommentTwr")
        HashtagButton.image = #imageLiteral(resourceName: "HashtagTwr")
        UsersButton.image = #imageLiteral(resourceName: "UserTwr")
        Cleaner.setImage(#imageLiteral(resourceName: "Eraser"), for: .normal)
        //LocationButton.image = #imageLiteral(resourceName: "LocationTwr")
        
        if(socialRed!){
            socialinfo?.CommentFacebook = Comments.text
            socialinfo?.HashtagFacebook = Hastags.text
            socialinfo?.UsersFacebook = Users.text
            //socialinfo?.LocationFacebook = Locations.text
        }
        Comments.text = socialinfo?.CommentTwitter
        Hastags.text = socialinfo?.HashtagTwitter
        Users.text = socialinfo?.UsersTwitter
        //Locations.text = socialinfo?.LocationTwitter
        socialRed = true
        FaceOrTwr = false
        
        Comments.isEnabled = true
        Hastags.isEnabled = true
        Users.isEnabled = true
        //Locations.isEnabled = true
        
        let cadena = (Comments.text)! + (Hastags.text)! + (Users.text)!
        let Length = cadena.characters.count
        CaractersNumber.text = Length <= 133 ? String(133 - Length) : "0"
        CaracteresLabel.text = "Caracteres"
    }
    @IBAction func FaceBookDates(_ sender: UIButton) {
        TwitterButton.setImage(#imageLiteral(resourceName: "Twittoff"), for: .normal)
        FaceButton.setImage(#imageLiteral(resourceName: "Faceboon"), for: .normal)
        CommentButton.image = #imageLiteral(resourceName: "CommentFace")
        HashtagButton.image = #imageLiteral(resourceName: "HashtagFace")
        UsersButton.image = #imageLiteral(resourceName: "UserFace")
        Cleaner.setImage(#imageLiteral(resourceName: "Eraser"), for: .normal)
        //LocationButton.image = #imageLiteral(resourceName: "LocationFace")
        
        if(socialRed!){
            socialinfo?.CommentTwitter = Comments.text
            socialinfo?.HashtagTwitter = Hastags.text
            socialinfo?.UsersTwitter = Users.text
          //  socialinfo?.LocationTwitter = Locations.text
        }
        
        Comments.text = socialinfo?.CommentFacebook
        Hastags.text = socialinfo?.HashtagFacebook
        Users.text = socialinfo?.UsersFacebook
        //Locations.text = socialinfo?.LocationFacebook
        socialRed = true
        FaceOrTwr = true
        
        Comments.isEnabled = true
        Hastags.isEnabled = true
        Users.isEnabled = true
        //Locations.isEnabled = true
        CaractersNumber.text = ""
        CaracteresLabel.text = ""
    }
    
    @IBAction func SaveInfoSocial(_ sender: UIButton) {
        print("Guardando infoSocial:\(Comments.text)")
        if(FaceOrTwr)!{
            socialinfo?.CommentFacebook = Comments.text
            socialinfo?.HashtagFacebook = Hastags.text
            socialinfo?.UsersFacebook = Users.text
            socialinfo?.LocationFacebook = Locations.text
        }else{
            socialinfo?.CommentTwitter = Comments.text
            socialinfo?.HashtagTwitter = Hastags.text
            socialinfo?.UsersTwitter = Users.text
            socialinfo?.LocationTwitter = Locations.text
        }
        socialsave.addItem(item: socialinfo!)
        self.dismiss(animated: true, completion: nil) 
        let alert = UIAlertController(title: "Guardado", message: "La informacion se ha guardado", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches , with: event)
        self.view.endEditing(true)
    }
    func addGestureReogizer(){
        let gr = UITapGestureRecognizer()
        gr.numberOfTapsRequired = 1
        gr.numberOfTouchesRequired = 1
        gr.addTarget(self, action: #selector(RegisterController.dimisskey))
        self.ScrollDates.isUserInteractionEnabled = true
        self.ScrollDates.addGestureRecognizer(gr)
        self.scrollView.isUserInteractionEnabled = true
        self.scrollView.addGestureRecognizer(gr)
    }
    func dimisskey(){
        if(KeyShow){
            self.view.endEditing(true)
        }
    }
    
    @IBAction func CleanerEraser(_ sender: UIButton) {
        Users.text = ""
        Hastags.text = ""
        Comments.text =  ""
        if(FaceOrTwr! == false && socialRed!){
            let cadena = (Comments.text)! + (Hastags.text)! + (Users.text)!
            let Length = cadena.characters.count
            CaractersNumber.text = Length <= 133 ? String(133 - Length) : "0"
        }
    }
    
    
    @IBAction func CarreteShow(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        //imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: TextFielDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.Comments {
            self.Hastags.becomeFirstResponder()
        }
        else if textField == self.Hastags {
            self.Users.becomeFirstResponder()
        }
        else if textField == self.Users {
            self.Users.resignFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //guard let text = textField.text else { return true }
       
        var Length = 0
        if(FaceOrTwr! == false){
            let cadena = (Comments.text)! + (Hastags.text)! + (Users.text)!
            Length = string.characters.count > 0 ? cadena.characters.count : cadena.characters.count - 2
            CaracteresLabel.text = "Caracteres"
            CaractersNumber.text = Length <= 133 ? String(133 - (Length)) : "0"
            //Length = string.characters.count > 0 ? Length : 133
        }
        return Length <= 133
    }
    
}
