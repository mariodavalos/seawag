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
    
    
    @IBAction func Confirm(_ sender: Any) {
        
    }
}
