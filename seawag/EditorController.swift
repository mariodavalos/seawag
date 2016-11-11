//
//  EditorController.swift
//  seawag
//
//  Created by Mario Dávalos on 11/11/16.
//  Copyright © 2016 Ooomovil. All rights reserved.
//

import Foundation
import UIKit

class EditorController: UIViewController {
    
    
    @IBOutlet weak var AplicateButton: UIButton!
    
    @IBOutlet weak var Filter1: UIButton!
    @IBOutlet weak var Filter2: UIButton!
    @IBOutlet weak var Filter3: UIButton!
    @IBOutlet weak var Filter4: UIButton!
    @IBOutlet weak var Filter5: UIButton!
    @IBOutlet weak var Filter6: UIButton!
    @IBOutlet weak var Filter7: UIButton!
    @IBOutlet weak var Filter8: UIButton!
    @IBOutlet weak var Filter9: UIButton!
    @IBOutlet weak var Filter10: UIButton!
    
    @IBOutlet weak var Shadow1: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Circulares()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func Circulares(){
        self.AplicateButton.layer.borderWidth = 0.5
        self.AplicateButton.layer.borderColor = UIColor.black.cgColor
        self.AplicateButton.layer.cornerRadius = 10.0
        
        
        Shadow1.layer.shadowColor = UIColor.black.cgColor
        Shadow1.layer.shadowOpacity = 1.0
        Shadow1.layer.shadowRadius = 8
        Shadow1.layer.shadowOffset = CGSize(width: 0.0, height: 10.0)
        Shadow1.layer.masksToBounds = false
        
        Filter1.layer.cornerRadius =  0.5 * Filter1.bounds.size.width
        Filter1.clipsToBounds = true
        Filter2.layer.cornerRadius =  0.5 * Filter1.bounds.size.width
        Filter2.clipsToBounds = true
        Filter3.layer.cornerRadius =  0.5 * Filter1.bounds.size.width
        Filter3.clipsToBounds = true
        Filter4.layer.cornerRadius =  0.5 * Filter1.bounds.size.width
        Filter4.clipsToBounds = true
        Filter5.layer.cornerRadius =  0.5 * Filter1.bounds.size.width
        Filter5.clipsToBounds = true
        Filter6.layer.cornerRadius =  0.5 * Filter1.bounds.size.width
        Filter6.clipsToBounds = true
        Filter7.layer.cornerRadius =  0.5 * Filter1.bounds.size.width
        Filter7.clipsToBounds = true
        Filter8.layer.cornerRadius =  0.5 * Filter1.bounds.size.width
        Filter8.clipsToBounds = true
        Filter9.layer.cornerRadius =  0.5 * Filter1.bounds.size.width
        Filter9.clipsToBounds = true
        Filter10.layer.cornerRadius =  0.5 * Filter1.bounds.size.width
        Filter10.clipsToBounds = true
    }
}
