//
//  ConfirmController.swift
//  seawag
//
//  Created by Mario Dávalos on 15/11/16.
//  Copyright © 2016 Ooomovil. All rights reserved.
//

import Foundation

import UIKit

class ConfirmController: UIViewController {
    
    @IBOutlet weak var ConfirmButton: UIButton!
    @IBOutlet weak var ClosingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ConfirmButton.layer.cornerRadius = 22.0
        ClosingButton.layer.cornerRadius = 22.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func Closing(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func Confirm(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            CameraController.EditorView?.dismiss(animated: true, completion: nil)
        })
    }
}
