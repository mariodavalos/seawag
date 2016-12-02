//
//  TwitterLoginViewController.swift
//  seawag
//
//  Created by Mario Dávalos on 01/12/16.
//  Copyright © 2016 Ooomovil. All rights reserved.
//

import UIKit
import TwitterKit
import TwitterCore

class TwitterLoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Twitter.sharedInstance().logIn(withMethods: [.webBased]) { session, error in
            print(session)
            print(error)
        }
        
        
        
    }

}
