//
//  LogoutController.swift
//  seawag
//
//  Created by Mario Dávalos on 28/11/16.
//  Copyright © 2016 Ooomovil. All rights reserved.
//

import Foundation

import UIKit
import FacebookLogin
import FacebookShare
import FacebookCore

import TwitterKit
import TwitterCore
import CoreFoundation
import Fabric

class LogoutController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var ConfirmButton: UIButton!
    @IBOutlet weak var ClosingButton: UIButton!
    
    @IBOutlet weak var TitleLabel: UILabel!
    
    @IBOutlet weak var UserImage: UIImageView!
    @IBOutlet weak var EmailImage: UIImageView!
    @IBOutlet weak var PasswordImage: UIImageView!
    
    var keyboardHeight:CGFloat!
    var textFields: [UITextField]!
    var KeyShow: Bool = false
    @IBOutlet weak var BottomConstrain: NSLayoutConstraint!
    @IBOutlet weak var TopConstrain: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var Name: UITextField!
    @IBOutlet weak var LastName: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var Password2: UITextField!
    @IBOutlet weak var LastSpacing: UIImageView!
    @IBOutlet weak var LastNameStack: UIStackView!
    
    var Save:Bool = false
    let loginsave = LoginSaving()
    var logininfo: LoginInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logininfo = loginsave.getItem(index: 0)
        
        ConfirmButton.layer.cornerRadius = 22.0
        ClosingButton.layer.cornerRadius = 22.0
        logininfo = loginsave.getItem(index: 0)
        Name.text = LoginController.NameLog + " " + LoginController.NamLLog
        LastName.text = LoginController.NamLLog
        LastNameStack.isHidden = true
        Email.text = LoginController.EmaiLog
        Password2.isHidden = true
        if(LoginController.PassLog == "ab51f5acb40977296fce11daed3feb1991e4579c")
        {
            Password.isHidden = true
            PasswordImage.isHidden = true
            Password2.isHidden = true
        }else{
            Password.text = LoginController.PassLog
            Password2.text = LoginController.PassLog
        }
        Name.textColor = UIColor.init(red: 98/255.0, green: 159/255.0, blue: 196/255.0, alpha: 1.0)
        LastName.textColor = UIColor.init(red: 98/255.0, green: 159/255.0, blue: 196/255.0, alpha: 1.0)
        Email.textColor = UIColor.init(red: 98/255.0, green: 159/255.0, blue: 196/255.0, alpha: 1.0)
        Password.textColor = UIColor.init(red: 98/255.0, green: 159/255.0, blue: 196/255.0, alpha: 1.0)
        Password2.textColor = UIColor.init(red: 98/255.0, green: 159/255.0, blue: 196/255.0, alpha: 1.0)
        
        textFields = [Name, LastName, Email, Password, Password2]
        
        // Keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.addGestureReogizer()
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    func adjustingHeight(show:Bool, notification:NSNotification) {
        
        var userInfo = notification.userInfo!
        
        //let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        
        let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        
        //let changeInHeight = (keyboardFrame.height + 40) * (show ? 1 : -1)
        
        UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
            if(self.Name.isEditing){
                self.TopConstrain.constant = 0
            }
            else if(self.LastName.isEditing){
                self.TopConstrain.constant = -self.Name.frame.size.height
            }
            else if(self.Email.isEditing){
                self.TopConstrain.constant = -self.Name.frame.size.height*2
            }
            else if(self.Password.isEditing){
                self.TopConstrain.constant = -self.Name.frame.size.height*4
            }
            else if(self.Password2.isEditing){
                self.TopConstrain.constant = -self.Name.frame.size.height*5
            }
            else {
                self.TopConstrain.constant = 0
            }
        })
    }
    
    func setScrollViewPosition(){
        // Modificamos el valor de la constante del constraint inferior, le damos la altura del teclado más 20 de marge. De este modo estamos agrandando el Scroll View lo suficiente para poder hacer scroll hacia arriba y trasladar el UITextField hasta que quede a la vista del usuario. Ejecutamos el cambio en el constraint con la función layoutIfNeeded().
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
                if(textField.placeholder=="Apellido"){
                    yPositionField = 80.0 + ((heightField+7) * 2)
                    yPositionScrol = 40.0 + ((heightField+7) * 4)
                }
                if(textField.placeholder=="Password"){
                    yPositionField = 80.0 + ((heightField+7) * 4)
                    yPositionScrol = 40.0 + ((heightField) * 2)
                }
                if(textField.placeholder=="Confirmar password"){
                    yPositionField = 100.0 + ((heightField+7) * 5)
                    yPositionScrol = 40.0 + ((heightField) * 1)
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
        TopConstrain.constant = 0
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
    
    @IBAction func EditUser(_ sender: UIButton) {
        do{
        if(Save){
            self.view.endEditing(true)
            if(try validateDates()){
               SavingInfo()
            }
        }   else{
            Save = true
            Name.text = LoginController.NameLog
            LastNameStack.isHidden = false
            Name.isEnabled = true
            EmailImage.image = #imageLiteral(resourceName: "Email")
            Email.textColor = UIColor.init(red: 129/255.0, green: 130/255.0, blue: 134/255.0, alpha: 1.0)
            Password.isEnabled = true
            if(LoginController.PassLog != "ab51f5acb40977296fce11daed3feb1991e4579c")
            {
                Password2.isHidden = false
            }
            ClosingButton.isHidden = true
            ConfirmButton.setTitle("GUARDAR", for: .normal)
            /*Name.underlined()
            LastName.underlined()
            Email.underlined()
            Password.underlined()
            Password2.underlined()*/
        }
        }catch{}
    }
    @IBAction func LogOut(_ sender: UIButton) {
        let loginManager = LoginManager()
        loginManager.logOut()
        self.logininfo?.SavingAccess = "0"
        self.loginsave.addItem(item: self.logininfo!)
        
        // Swift
        let store = Twitter.sharedInstance().sessionStore
        
        if let userID = store.session()?.userID {
            store.logOutUserID(userID)
        }
        
        let LoginC = self.storyboard?.instantiateViewController(withIdentifier: "LoginCV") as! LoginController
        self.present(LoginC, animated: true, completion: nil)
    }
    func SavingInfo(){
        var request = URLRequest(url: URL(string: "http://201.168.207.17:8888/seawag/kuff_api/updatePerfil")!)
        request.httpMethod = "POST"
        var postString = "email="+self.Email.text!+"&nombre="+self.Name.text!+"&apellido="+self.LastName.text!
        if(LoginController.PassLog != "ab51f5acb40977296fce11daed3feb1991e4579c")
        {
            postString = postString+"&pass="+self.Password.text!
        }
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                // check for fundamental networking error
                let alert = UIAlertController(title: "Error de acceso", message: "Revisa tu conexion a internet", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            let responseString = String(data: data, encoding: .utf8)
            if(responseString!.contains("\"status\":200"))
            {
                print("responseString = \(responseString)")
                DispatchQueue.main.async {
                    if(LoginController.PassLog != "ab51f5acb40977296fce11daed3feb1991e4579c")
                    {
                        LoginController.PassLog = self.Password.text!
                    }
                    LoginController.NameLog = self.Name.text!
                    LoginController.NamLLog = self.LastName.text!
                    if(self.logininfo?.SavingAccess == "1")
                    {
                        if(self.logininfo?.FacebookAccess == "0"){
                            self.logininfo?.PassLogin = self.Password.text!
                            self.loginsave.addItem(item: self.logininfo!)
                        }
                    }
                    let alert = UIAlertController(title: "Guardado", message: "Los cambios se han realizado correctamente", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler:{ action in
                        DispatchQueue.main.async {
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CameraVC") as! CameraController
                            self.present(vc, animated: true, completion: nil)
                        }
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            else
            {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error de acceso", message: "Actualizacion incorrecta, intente de nuevo", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        task.resume()
    }
    func validateDates()throws -> Bool{
        var success: Bool
        success = true
        success  = (Name.messageAlertLine(message: "Campo obligatorio", isview: (Name.text?.isEmpty)!) && success) ? true : false
        do{
            if(success) { self.UserImage.image = #imageLiteral(resourceName: "UserCorrect")
                if(self.isBeingPresented){
                self.Name.textColor =  UIColor.init(red: 98/255.0, green: 159/255.0, blue: 196/255.0, alpha: 1.0)
                }
            }
            else{
                self.UserImage.image = #imageLiteral(resourceName: "UserIncorrect")
                self.Name.textColor = UIColor.red
            }
        }catch{}
        success  = (LastName.messageAlertLine(message: "Campo obligatorio", isview: (LastName.text?.isEmpty)!) && success) ? true : false
        if(LoginController.PassLog != "ab51f5acb40977296fce11daed3feb1991e4579c"){
        success  = (Password.messageAlertLine(message: "Campo obligatorio", isview: (Password.text?.isEmpty)!) && success) ? true : false
        success  = (Password2.messageAlertLine(message: "Campo obligatorio", isview: (Password2.text?.isEmpty)!) && success) ? true : false
        
        if((!(Password.text?.isEmpty)!)){
            success  = (Password.messageAlertLine(message: "Password no coincide", isview: ((Password2.text!.compare(Password.text!)) != ComparisonResult.orderedSame)) && success) ? true : false
            if((Password2.text!.compare(Password.text!)) != ComparisonResult.orderedSame)
            {
                self.PasswordImage.image = #imageLiteral(resourceName: "PasswordIncorrect")
                self.Password.textColor = UIColor.red
                
            }
            else{
                self.PasswordImage.image = #imageLiteral(resourceName: "PasswordCorrect")
                self.Password.textColor = UIColor.init(red: 98/255.0, green: 159/255.0, blue: 196/255.0, alpha: 1.0)
            }
        }else{
            self.PasswordImage.image = #imageLiteral(resourceName: "PasswordIncorrect")
        }
        }
        return success
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches , with: event)
        self.view.endEditing(true)
        do{
        if(try validateDates()){
            //Name.messageAlert(message: "Todo es correcto")
        }
        }catch{}
    }
    func addGestureReogizer(){
        let gr = UITapGestureRecognizer()
        gr.numberOfTapsRequired = 1
        gr.numberOfTouchesRequired = 1
        gr.addTarget(self, action: #selector(LogoutController.dimisskey))
        self.scrollView.isUserInteractionEnabled = true
        self.scrollView.addGestureRecognizer(gr)
    }
    func dimisskey(){
        if(KeyShow){
            self.view.endEditing(true)
        }
    }
    //MARK: TextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.Name {
            self.LastName.becomeFirstResponder()
        }
        else if textField == self.LastName {
            self.Password.becomeFirstResponder()
        }
        else if textField == self.Password {
            self.Password2.becomeFirstResponder()
        }
        else if textField == self.Password2 {
            Password2.resignFirstResponder()
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
        return true
    }

}
