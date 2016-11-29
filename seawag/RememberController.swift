//
//  RememberController.swift
//  seawag
//
//  Created by Mario Dávalos on 08/11/16.
//  Copyright © 2016 Ooomovil. All rights reserved.
//

import UIKit

class RememberController: UIViewController {
    
    
    @IBOutlet weak var PassButton: UIButton!
    @IBOutlet weak var Email: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Email.underlinedExtend()
        PassButton.layer.cornerRadius = 22.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be
    }
    
    
    @IBAction func RememberConfirm(_ sender: UIButton) {
        ConfirmRemember()
    }
    func ConfirmRemember(){
        var request = URLRequest(url: URL(string: "http://201.168.207.17:8888/seawag/kuff_api/recoverPassword")!)
        request.httpMethod = "POST"
        let postString =
            "email="+Email.text!
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
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "CorrectCV") as! AlertController
                    self.present(vc, animated: true, completion: nil)
                }
            }
            else
            {
                DispatchQueue.main.async {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "AlertEmailCV") as! AlertEmailController
                    self.present(vc, animated: true, completion: nil)
                }
            }
        }
        task.resume()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches , with: event)
        self.view.endEditing(true)
    }
    
    @IBAction func Closing(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
