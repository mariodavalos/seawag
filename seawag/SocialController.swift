//
//  SocialController.swift
//  seawag
//
//  Created by Mario Dávalos on 15/11/16.
//  Copyright © 2016 Ooomovil. All rights reserved.
//

import Foundation

import UIKit

class SocialController: UIViewController {
    
    @IBOutlet weak var SaveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SaveButton.layer.borderWidth = 2
        self.SaveButton.layer.borderColor = UIColor.blue.cgColor
        self.SaveButton.layer.cornerRadius = 22.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func Closing(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
