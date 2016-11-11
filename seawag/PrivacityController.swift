//
//  PrivacityController.swift
//  seawag
//
//  Created by Mario Dávalos on 10/11/16.
//  Copyright © 2016 Ooomovil. All rights reserved.
//

import Foundation

import UIKit

class PrivacityController: UIViewController {
    
    @IBOutlet weak var Close: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Close.layer.cornerRadius = 22.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Closing(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
