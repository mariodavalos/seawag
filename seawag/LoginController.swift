//
//  ViewController.swift
//  seawag
//
//  Created by Mario Dávalos on 08/11/16.
//  Copyright © 2016 Ooomovil. All rights reserved.
//

import Foundation
import UIKit
import FacebookShare
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
 
    var dict : NSDictionary!
    
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
    
    @IBAction func LoginAccess(_ sender: UIButton) {
        var request = URLRequest(url: URL(string: "http://201.168.207.17:8888/seawag/kuff_api/loginUser")!)
        request.httpMethod = "POST"
        let postString =
            "uname="+User.text!+"&upass="+Paser.text!
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
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "CameraVC") as! CameraController
                    self.present(vc, animated: true, completion: nil)
                }
            }
            else
            {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error de acceso", message: "Usuario o contraseña incorrectos", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        task.resume()
        
    }
    
    @IBAction func FacebookLogin(_ sender: UIButton) {
        if AccessToken.current != nil {
            let request = GraphRequest(graphPath: "me", parameters: ["fields":"email"], accessToken: AccessToken.current, httpMethod: .GET, apiVersion: FacebookCore.GraphAPIVersion.defaultVersion)
            request.start { (response, result) in
                switch result {
                case .success(let value):
                    let email = value.dictionaryValue?["email"] as! String
                    var request = URLRequest(url: URL(string: "http://201.168.207.17:8888/seawag/kuff_api/loginUser")!)
                    request.httpMethod = "POST"
                    let postString =
                        "uname="+email+"&fb_token=ab51f5acb40977296fce11daed3feb1991e4579c"
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
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CameraVC") as! CameraController
                                self.present(vc, animated: true, completion: nil)
                            }
                        }
                        else
                        {
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: "Error de acceso", message: "Revisa tu conexion a facebook", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    }
                    task.resume()

                case .failed(let error):
                    print(error)
                }
            }
            
        }
        else{
        let loginManager = LoginManager()
        loginManager.logIn([ .publicProfile, .email, .userFriends ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                let request = GraphRequest(graphPath: "me", parameters: ["fields":"email,first_name,last_name"], accessToken: AccessToken.current, httpMethod: .GET, apiVersion: FacebookCore.GraphAPIVersion.defaultVersion)
                request.start { (response, result) in
                    switch result {
                    case .success(let value):
                        var request = URLRequest(url: URL(string: "http://201.168.207.17:8888/seawag/kuff_api/regUser")!)
                        request.httpMethod = "POST"
                        let name = value.dictionaryValue?["first_name"] as! String
                        let apellido = value.dictionaryValue?["last_name"] as! String
                        let email = value.dictionaryValue?["email"] as! String
                        let postString = "nombre="+name+"&apellido="+apellido+"&email="+email+"&fb_token=ab51f5acb40977296fce11daed3feb1991e4579c"
                        request.httpBody = postString.data(using: .utf8)
                        let task = URLSession.shared.dataTask(with: request) { data, response, error in
                            guard let data = data, error == nil else {
                                // check for fundamental networking error
                                print("error=\(error)")
                                return
                            }
                            
                            let response = String(data: data, encoding: .utf8)
                            if(response!.contains("\"status\":200"))
                            {
                                print("response = \(response)")
                                DispatchQueue.main.async {
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "CameraVC") as! CameraController
                                    self.present(vc, animated: true, completion: nil)
                                }
                            }
                            
                                let responseString = String(data: data, encoding: .utf8)
                                print("responseString = \(responseString)")
                            }
                            task.resume()
                            print(value.dictionaryValue)
                        case .failed(let error):
                            print(error)
                        }
                }
                }
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

