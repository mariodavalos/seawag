//
//  ViewController.swift
//  seawag
//
//  Created by Mario Dávalos on 08/11/16.
//  Copyright © 2016 Ooomovil. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var Login: UIButton!
    @IBOutlet weak var Registrate: UIButton!
    @IBOutlet weak var Facebook: UIButton!
    @IBOutlet weak var User: UITextField!
    @IBOutlet weak var Paser: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.Login.layer.cornerRadius = 22.0
        self.Registrate.layer.cornerRadius = 22.0
        self.Registrate.layer.borderWidth = 2
        self.Registrate.layer.borderColor = UIColor.white.cgColor
        self.Facebook.layer.cornerRadius = 22.0
        self.User.layer.cornerRadius = 22.0
        self.User.layer.borderWidth = 2
        self.User.layer.borderColor = UIColor.white.cgColor
        self.Paser.layer.cornerRadius = 22.0
        self.Paser.layer.borderWidth = 2
        self.Paser.layer.borderColor = UIColor.white.cgColor
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

