//
//  RegisterController .swift
//  seawag
//
//  Created by Mario Dávalos on 08/11/16.
//  Copyright © 2016 Ooomovil. All rights reserved.
//

import UIKit

class RegisterController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var Name: UITextField!
    @IBOutlet weak var LastName: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Email2: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var Password2: UITextField!
    
    @IBOutlet weak var Register: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Register.layer.cornerRadius = 22.0
        Name.underlined()
        LastName.underlined()
        Email.underlined()
        Email2.underlined()
        Password.underlined()
        Password2.underlined()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var NoName: UILabel!
    
    @IBAction func Register(_ sender: UIButton) {
        if(validateDates()){
         //Name.messageAlert(message: "Todo es correcto")
        }
    }
    func validateDates()-> Bool{
        var success: Bool
        success = true
        success  = (Name.messageAlertLine(message: "Campo obligatorio", isview: (Name.text?.isEmpty)!) && success) ? true : false
        success  = (LastName.messageAlertLine(message: "Campo obligatorio", isview: (LastName.text?.isEmpty)!) && success) ? true : false
        success  = (Email.messageAlertLine(message: "Campo obligatorio", isview: (Email.text?.isEmpty)!) && success) ? true : false
        success  = (Email2.messageAlertLine(message: "Campo obligatorio", isview: (Email2.text?.isEmpty)!) && success) ? true : false
        success  = (Password.messageAlertLine(message: "Campo obligatorio", isview: (Password.text?.isEmpty)!) && success) ? true : false
        success  = (Password2.messageAlertLine(message: "Campo obligatorio", isview: (Password2.text?.isEmpty)!) && success) ? true : false
        if((!(Email.text?.isEmpty)!)){
           success  = (Email.messageAlertLine(message: "Correo no coincide", isview: ((Email2.text!.compare(Email.text!)) != ComparisonResult.orderedSame)) && success) ? true : false
            }
        if((!(Password.text?.isEmpty)!)){
            success  = (Password.messageAlertLine(message: "Password no coincide", isview: ((Password2.text!.compare(Password.text!)) != ComparisonResult.orderedSame )) && success) ? true : false
        }
        return success
    }
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
    @IBAction func Closing(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
