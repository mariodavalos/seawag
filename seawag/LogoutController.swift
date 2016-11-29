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

class LogoutController: UIViewController {
    
    @IBOutlet weak var ConfirmButton: UIButton!
    @IBOutlet weak var ClosingButton: UIButton!
    
    @IBOutlet weak var TitleLabel: UILabel!
    
    @IBOutlet weak var UserImage: UIImageView!
    @IBOutlet weak var EmailImage: UIImageView!
    @IBOutlet weak var PasswordImage: UIImageView!
    
    @IBOutlet weak var Name: UITextField!
    @IBOutlet weak var LastName: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var Password2: UITextField!
    @IBOutlet weak var LastSpacing: UIImageView!
    @IBOutlet weak var LastNameStack: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ConfirmButton.layer.cornerRadius = 22.0
        ClosingButton.layer.cornerRadius = 22.0
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
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func Closing(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func EditUser(_ sender: UIButton) {
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
    }
    @IBAction func LogOut(_ sender: UIButton) {
        let loginManager = LoginManager()
        loginManager.logOut()
        self.present(SplashController.LogInView!, animated: true, completion: nil)
    }
}
