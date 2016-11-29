//
//  AlertController.swift
//  seawag
//
//  Created by Mario Dávalos on 10/11/16.
//  Copyright © 2016 Ooomovil. All rights reserved.
//

import Foundation

import UIKit

class AlertController: UIViewController {
    
    
    @IBOutlet weak var ImageIcon: UIImageView!
    @IBOutlet weak var MessageText: UILabel!
    @IBOutlet weak var ActiveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ActiveButton.layer.cornerRadius = 22.0
    }
    
    @IBAction func LoginReturn(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginCV") as! LoginController
        self.present(vc, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
}
}
