//
//  LoginInfo.swift
//  seawag
//
//  Created by Mario Dávalos on 24/11/16.
//  Copyright © 2016 Ooomovil. All rights reserved.
//

import Foundation
import UIKit

class LoginInfo: NSObject, NSCoding {
    
    var SavingAccess: String?
    
    var FacebookAccess: String?
    
    var UserEmail: String?
    
    var PassLogin: String?
    
    
    override init(){
        super.init()
    }
    
    required init(coder aDecoder: NSCoder){
        super.init()
        if let SavingAccess = aDecoder.decodeObject(forKey: "SavingAccess") as? String {
            self.SavingAccess = SavingAccess
        }
        if let FacebookAccess = aDecoder.decodeObject(forKey: "FacebookAccess") as? String {
            self.FacebookAccess = FacebookAccess
        }
        if let UserEmail = aDecoder.decodeObject(forKey: "UserEmail") as? String {
            self.UserEmail = UserEmail
        }
        if let PassLogin = aDecoder.decodeObject(forKey: "PassLogin") as? String {
            self.PassLogin = PassLogin
        }
    }
    
    func encode(with aCoder: NSCoder) {
        if let SavingAccess = self.SavingAccess {
            aCoder.encode(SavingAccess, forKey: "SavingAccess")
        }
        if let FacebookAccess = self.FacebookAccess {
            aCoder.encode(FacebookAccess, forKey: "FacebookAccess")
        }
        if let UserEmail = self.UserEmail {
            aCoder.encode(UserEmail, forKey: "UserEmail")
        }
        if let PassLogin = self.PassLogin {
            aCoder.encode(PassLogin, forKey: "PassLogin")
        }
    }
    
}
