//
//  PublicateController.swift
//  seawag
//
//  Created by Mario Dávalos on 22/11/16.
//  Copyright © 2016 Ooomovil. All rights reserved.
//

import Foundation
import UIKit

class PublicateController: UIViewController {
    
    @IBOutlet weak var Start: UIButton!
    @IBOutlet weak var Close: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Close.layer.cornerRadius = 18.0
        Start.layer.cornerRadius = 18.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func Starting(_ sender: UIButton) {
        //CameraController.GoStart()
        self.dismiss(animated: true, completion:{ () -> Void in
           CameraController.sharedManager.StartOrClose = true
        })
    }
    
    @IBAction func Closing(_ sender: UIButton) {
        self.dismiss(animated: true, completion: { () -> Void in
            CameraController.sharedManager.StartOrClose = false
        })

    }
}
