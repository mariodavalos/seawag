//
//  RegisterController .swift
//  seawag
//
//  Created by Mario Dávalos on 08/11/16.
//  Copyright © 2016 Ooomovil. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation
import CoreFoundation

class RegisterController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var Name: UITextField!
    @IBOutlet weak var LastName: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Email2: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var Password2: UITextField!
    
    @IBOutlet weak var Register: UIButton!
    
    var keyboardHeight:CGFloat!
    var textFields: [UITextField]!
    
    @IBOutlet weak var BottomConstrain: NSLayoutConstraint!
    @IBOutlet weak var TopConstrain: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var UserName: UIImageView!
    @IBOutlet weak var EmailLogo: UIImageView!
    @IBOutlet weak var PasswordLogo: UIImageView!
    
    var KeyShow: Bool = false
    
    @IBOutlet weak var ScrollDimissKey: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Register.layer.cornerRadius = 22.0
        
        textFields = [Name, LastName, Email, Email2, Password, Password2]

        // Keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.addGestureReogizer()
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func viewDidAppear(_ animated: Bool) {
        Name.underlined()
        LastName.underlined()
        Email.underlined()
        Email2.underlined()
        Password.underlined()
        Password2.underlined()
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
            else if(self.Email2.isEditing){
                self.TopConstrain.constant = -self.Name.frame.size.height*3
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
                if(textField.placeholder=="Apellidos"){
                yPositionField = 100.0 + ((heightField+7) * 2)
                yPositionScrol = 40.0 + ((heightField+7) * 5)
                }
                if(textField.placeholder=="Correo"){
                    yPositionField = 100.0 + ((heightField+7) * 3)
                    yPositionScrol = 40.0 + ((heightField) * 4)
                }
                if(textField.placeholder=="Confirmar correo"){
                    yPositionField = 100.0 + ((heightField+7) * 4)
                    yPositionScrol = 40.0 + ((heightField) * 3)
                }
                if(textField.placeholder=="Password"){
                    yPositionField = 100.0 + ((heightField+7) * 5)
                    yPositionScrol = 40.0 + ((heightField) * 2)
                }
                if(textField.placeholder=="Confirmar password"){
                    yPositionField = 100.0 + ((heightField+7) * 6)
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
        self.view.layoutIfNeeded()
        KeyShow = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var NoName: UILabel!
    
    @IBAction func Register(_ sender: UIButton) {
        self.view.endEditing(true)
        if(validateDates()){
            var request = URLRequest(url: URL(string: "http://201.168.207.17:8888/seawag/kuff_api/regUser")!)
            request.httpMethod = "POST"
            let postString =
                "nombre="+Name.text!+"&apellido="+LastName.text!+"&email="+Email.text!+"&pass="+Password.text!
            request.httpBody = postString.data(using: .utf8)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    // check for fundamental networking error
                    print("error=\(error)")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    // check for http errors
                    print("usuario registrado,estatus \(httpStatus.statusCode)")
                    print("response = \(response)")
                }
                
                let responseString = String(data: data, encoding: .utf8)
                if(responseString!.contains("\"status\":200"))
                {
                    print("responseString = \(responseString)")
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Registro", message: "Usuario registrado correctamente", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: {
                            DispatchQueue.main.async {
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CameraVC") as! CameraController
                                self.present(vc, animated: true, completion: nil)
                            }
                        })
                    }
                }
                else if(responseString!.contains("Duplicate entry"))
                {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Error de registro", message: "Correo duplicado", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                else
                {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Error de registro", message: "Intentar de nuevo mas tarde", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
            task.resume()
            //self.dismiss(animated: true, completion: nil)
        }
    }
    func validateDates()-> Bool{
        var success: Bool
        success = true
        success  = (Name.messageAlertLine(message: "Campo obligatorio", isview: (Name.text?.isEmpty)!) && success) ? true : false
        
        if(success) { self.UserName.image = #imageLiteral(resourceName: "UserCorrect")
        self.Name.textColor =  UIColor.init(red: 98/255.0, green: 159/255.0, blue: 196/255.0, alpha: 1.0)
        }
        else{
            self.UserName.image = #imageLiteral(resourceName: "UserIncorrect")
            self.Name.textColor = UIColor.red
        }
        
        success  = (LastName.messageAlertLine(message: "Campo obligatorio", isview: (LastName.text?.isEmpty)!) && success) ? true : false
        success  = (Email.messageAlertLine(message: "Campo obligatorio", isview: (Email.text?.isEmpty)!) && success) ? true : false
        
        if(validateEmail(candidate: Email.text!))
        { self.EmailLogo.image = #imageLiteral(resourceName: "EmailCorrect")
          self.Email.textColor = UIColor.init(red: 98/255.0, green: 159/255.0, blue: 196/255.0, alpha: 1.0)
        }
        else{
            self.EmailLogo.image = #imageLiteral(resourceName: "EmailIncorrect")
            self.Email.textColor = UIColor.red
            
        }
        
        success  = (Email2.messageAlertLine(message: "Campo obligatorio", isview: (Email2.text?.isEmpty)!) && success) ? true : false
        success  = (Password.messageAlertLine(message: "Campo obligatorio", isview: (Password.text?.isEmpty)!) && success) ? true : false
        success  = (Password2.messageAlertLine(message: "Campo obligatorio", isview: (Password2.text?.isEmpty)!) && success) ? true : false
        
        if((!(Email.text?.isEmpty)!)){
           success  = (Email.messageAlertLine(message: "Correo no coincide", isview: ((Email2.text!.compare(Email.text!)) != ComparisonResult.orderedSame)) && success) ? true : false
            success = ((Email.messageAlertLine(message: "Correo invalido", isview: !(validateEmail(candidate: Email.text!))) && success) ? true : false)
        }
        
        if((!(Password.text?.isEmpty)!)){
            success  = (Password.messageAlertLine(message: "Password no coincide", isview: ((Password2.text!.compare(Password.text!)) != ComparisonResult.orderedSame)) && success) ? true : false
            if((Password2.text!.compare(Password.text!)) != ComparisonResult.orderedSame)
            {
                self.PasswordLogo.image = #imageLiteral(resourceName: "PasswordIncorrect")
                self.Password.textColor = UIColor.red
                
            }
            else{
                self.PasswordLogo.image = #imageLiteral(resourceName: "PasswordCorrect")
                self.Password.textColor = UIColor.init(red: 98/255.0, green: 159/255.0, blue: 196/255.0, alpha: 1.0)
            }
        }else{
            self.PasswordLogo.image = #imageLiteral(resourceName: "PasswordIncorrect")
        }
        return success
    }
    func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches , with: event)
        self.view.endEditing(true)
        if(validateDates()){
            //Name.messageAlert(message: "Todo es correcto")
        }
    }
    func addGestureReogizer(){
        let gr = UITapGestureRecognizer()
        gr.numberOfTapsRequired = 1
        gr.numberOfTouchesRequired = 1
        gr.addTarget(self, action: #selector(RegisterController.dimisskey))
        self.ScrollDimissKey.isUserInteractionEnabled = true
        self.ScrollDimissKey.addGestureRecognizer(gr)
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
            self.Email.becomeFirstResponder()
        }
        else if textField == self.Email {
            self.Email2.becomeFirstResponder()
        }
        else if textField == self.Email2 {
            self.Password.becomeFirstResponder()
        }
        else if textField == self.Password {
        self.Password2.becomeFirstResponder()
        }
        else if textField == self.Password2 {
            Password2.resignFirstResponder()
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //guard let text = textField.text else { return true }
        let Length = textField.text?.characters.count
        if (Length!>=0){
            if(string.characters.count>0){
                if(textField.placeholder=="Nombre(s)")
                    { UserName.image = #imageLiteral(resourceName: "UserCorrect")}
                else if(textField.placeholder=="Correo")
                    { EmailLogo.image = #imageLiteral(resourceName: "EmailCorrect")}
                else if(textField.placeholder=="Password")
                { PasswordLogo.image = #imageLiteral(resourceName: "PasswordCorrect")}
            }
        }
        if (Length!<=1){
            if(string.characters.count==0){
                if(textField.placeholder=="Nombre(s)")
                { UserName.image = #imageLiteral(resourceName: "UserOff")}
                else if(textField.placeholder=="Correo")
                { EmailLogo.image = #imageLiteral(resourceName: "Email")}
                else if(textField.placeholder=="Password")
                { PasswordLogo.image = #imageLiteral(resourceName: "Password")}
            }
        }
        return Length! <= 50
    }
    
    @IBAction func Closing(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
