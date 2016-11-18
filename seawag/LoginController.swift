//
//  ViewController.swift
//  seawag
//
//  Created by Mario Dávalos on 08/11/16.
//  Copyright © 2016 Ooomovil. All rights reserved.
//

import Foundation
import UIKit

import FacebookCore
import FacebookLogin

class LoginController: UIViewController {

    @IBOutlet weak var Login: UIButton!
    @IBOutlet weak var Registrate: UIButton!
    @IBOutlet weak var Facebook: UIButton!
    @IBOutlet weak var User: UITextField!
    @IBOutlet weak var Paser: UITextField!
    @IBOutlet weak var FacebookSession: UIButton!
    
    @IBOutlet weak var FondoParallax: UIImageView!
    @IBOutlet var LoginParallax: UIView!
    
    
    
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
        addParallaxToView(vw: FondoParallax)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func FacebookLogin(_ sender: UIButton) {
        let loginManager = LoginManager()
        loginManager.logIn([.publishActions], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print(accessToken.userId!)
                
            }
        }
    }
    func addParallaxToView(vw: UIImageView) {
        let amount = 100
        
        let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontal.minimumRelativeValue = -amount
        horizontal.maximumRelativeValue = amount
        
        let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        vertical.minimumRelativeValue = -amount
        vertical.maximumRelativeValue = amount
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontal, vertical]
        vw.addMotionEffect(group)
    }

}

