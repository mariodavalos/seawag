//
//  SplashController.swift
//  seawag
//
//  Created by Mario Dávalos on 28/11/16.
//  Copyright © 2016 Ooomovil. All rights reserved.
//

import Foundation

import UIKit
import FacebookShare
import FacebookCore
import FacebookLogin

class SplashController: UIViewController {
    
    let loginsave = LoginSaving()
    var logininfo: LoginInfo?
    //public static var LogInView: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let LogInView = self.storyboard?.instantiateViewController(withIdentifier: "LoginCV") as! LoginController
        
        logininfo = loginsave.getItem(index: 0)
        /*
        self.logininfo?.SavingAccess = "0"
        self.loginsave.addItem(item: self.logininfo!)
        */
        if(logininfo?.SavingAccess == "1")
        {
            if(logininfo?.FacebookAccess == "1")
            {
                FacebookAcces()
            }
            else{
                LoginAcces()
            }
        }
        
        else
        {
            DispatchQueue.main.async {
                self.present(LogInView, animated: true, completion: nil)
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func LoginAcces(){
        var request = URLRequest(url: URL(string: "http://201.168.207.17:8888/seawag/kuff_api/loginUser")!)
        request.httpMethod = "POST"
        let postString =
            "uname="+(logininfo?.UserEmail!)!+"&upass="+(logininfo?.PassLogin)!
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                // check for fundamental networking error
                let alert = UIAlertController(title: "Error de acceso", message: "Revisa tu conexion a internet", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler: { action in
                    DispatchQueue.main.async {
                        let LogInView = self.storyboard?.instantiateViewController(withIdentifier: "LoginCV") as! LoginController
                        self.present(LogInView, animated: true, completion: nil)
                    }
                }))
                self.present(alert, animated: true, completion: nil)
                return
            }
            let responseString = String(data: data, encoding: .utf8)
            if(responseString!.contains("\"status\":200"))
            {
                print("responseString = \(responseString)")
                DispatchQueue.main.async {
                    LoginController.EmaiLog = (self.logininfo?.UserEmail)!
                    LoginController.PassLog = (self.logininfo?.PassLogin)!
                    let datacom = responseString?.components(separatedBy: "\"")
                    print(datacom?[15])
                    print(datacom?[19])
                    LoginController.NameLog = (datacom?[15])!
                    LoginController.NamLLog = (datacom?[19])!
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "CameraVC") as! CameraController
                    self.present(vc, animated: true, completion: nil)
                }
            }
            else
            {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error de acceso", message: "Usuario  inactivo", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler: { action in
                        DispatchQueue.main.async {
                            let LogInView = self.storyboard?.instantiateViewController(withIdentifier: "LoginCV") as! LoginController
                            self.present(LogInView, animated: true, completion: nil)
                        }
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        task.resume()
    }
    func FacebookAcces()
    {
        if AccessToken.current != nil {
            let request = GraphRequest(graphPath: "me", parameters: ["fields":"email,first_name,last_name"], accessToken: AccessToken.current, httpMethod: .GET, apiVersion: FacebookCore.GraphAPIVersion.defaultVersion)
            request.start { (response, result) in
                switch result {
                case .success(let value):
                    let name = value.dictionaryValue?["first_name"] as! String
                    let apellido = value.dictionaryValue?["last_name"] as! String
                    let email = value.dictionaryValue?["email"] as! String
                    LoginController.EmaiLog = email
                    LoginController.NameLog = name
                    LoginController.NamLLog = apellido
                    LoginController.PassLog = "ab51f5acb40977296fce11daed3feb1991e4579c"
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
                            DispatchQueue.main.async {
                                let LogInView = self.storyboard?.instantiateViewController(withIdentifier: "LoginCV") as! LoginController
                                self.present(LogInView, animated: true, completion: nil)
                            }
                            return
                        }
                        let responseString = String(data: data, encoding: .utf8)
                        if(responseString!.contains("\"status\":200"))
                        {
                            let datacom = responseString?.components(separatedBy: "\"")
                            print(datacom?[15])
                            print(datacom?[19])
                            LoginController.NameLog = (datacom?[15])!
                            LoginController.NamLLog = (datacom?[19])!
                            print("responseString = \(responseString)")
                            DispatchQueue.main.async {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CameraVC") as! CameraController
                                self.present(vc, animated: true, completion: nil)
                            }
                        }
                        else if(responseString!.contains("cuenta no activa"))
                        {
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: "Error de registro", message: "Error al acceder con facebook", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler: { action in
                                    DispatchQueue.main.async {
                                        let LogInView = self.storyboard?.instantiateViewController(withIdentifier: "LoginCV") as! LoginController
                                        self.present(LogInView, animated: true, completion: nil)
                                    }
                                }))

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
                    let alert = UIAlertController(title: "Error de login", message: "Cancelaste el acceso a facebook", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler:{ action in
                        DispatchQueue.main.async {
                            let LogInView = self.storyboard?.instantiateViewController(withIdentifier: "LoginCV") as! LoginController
                            self.present(LogInView, animated: true, completion: nil)
                        }
                    }))
                    self.present(alert, animated: true, completion: nil)
                case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                    if(grantedPermissions.contains("publish_actions"))
                    {
                        self.FacebookAcces()
                    }else{
                    let request = GraphRequest(graphPath: "me", parameters: ["fields":"email,first_name,last_name"], accessToken: AccessToken.current, httpMethod: .GET, apiVersion: FacebookCore.GraphAPIVersion.defaultVersion)
                    request.start { (response, result) in
                        switch result {
                        case .success(let value):
                            let name = value.dictionaryValue?["first_name"] as! String
                            let apellido = value.dictionaryValue?["last_name"] as! String
                            let email = value.dictionaryValue?["email"] as! String
                            LoginController.EmaiLog = email
                            LoginController.NameLog = name
                            LoginController.NamLLog = apellido
                            LoginController.PassLog = "ab51f5acb40977296fce11daed3feb1991e4579c"
                            DispatchQueue.main.async {
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CameraVC") as! CameraController
                                self.present(vc, animated: true, completion: nil)
                            }
                        case .failed(let error):
                            print(error)
                        }
                        }
                    }
                }
            }
        }
    }
}
