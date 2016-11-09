//
//  RegisterController .swift
//  seawag
//
//  Created by Mario Dávalos on 08/11/16.
//  Copyright © 2016 Ooomovil. All rights reserved.
//

import UIKit

class RegisterController: UIViewController {
    
    
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
    
    
}
