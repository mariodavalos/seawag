//
//  AlertEmailController.swift
//  seawag
//
//  Created by Mario Dávalos on 25/11/16.
//  Copyright © 2016 Ooomovil. All rights reserved.
//

import Foundation
import UIKit

class AlertEmailController: UIViewController {
    
    
    @IBOutlet weak var ActiveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ActiveButton.layer.cornerRadius = 22.0
    }
    
    @IBAction func LoginReturn(_ sender: UIButton) {
         self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
