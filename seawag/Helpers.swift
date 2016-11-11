//
//  Helpers.swift
//  seawag
//
//  Created by Mario Dávalos on 09/11/16.
//  Copyright © 2016 Ooomovil. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    func underlined(){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.gray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - 13, width:  self.frame.size.width, height: 1)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    func underlinedExtend(){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.gray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width + 25, height: 1)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    func messageEmpty(message: String)
    {
        let alert = CATextLayer()
        alert.string = message
        alert.foregroundColor = UIColor.red.cgColor
        alert.fontSize = 11
        alert.font = UIFont.italicSystemFont(ofSize: 11)
        alert.frame = CGRect(x: 0, y: self.frame.size.height - 12, width: self.frame.size.width, height: 13)
        if((self.layer.sublayers?.count)!>2)
        {
            self.layer.sublayers?.remove(at: 1)
        }
        self.layer.addSublayer(alert)
        self.layer.masksToBounds = true
        
    }
}
