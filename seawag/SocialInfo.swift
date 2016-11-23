//
//  SocialInfo.swift
//  seawag
//
//  Created by Mario Dávalos on 22/11/16.
//  Copyright © 2016 Ooomovil. All rights reserved.
//

import Foundation
import UIKit

class SocialInfo: NSObject, NSCoding {
    
    var CommentTwitter: String?
    
    var HashtagTwitter: String?
    
    var UsersTwitter: String?
    
    var LocationTwitter: String?
    
    var CommentFacebook: String?
    
    var HashtagFacebook: String?
    
    var UsersFacebook: String?
    
    var LocationFacebook: String?
    
    
    override init(){
        super.init()
    }
    
    required init(coder aDecoder: NSCoder){
        super.init()
        if let CommentTwitter = aDecoder.decodeObject(forKey: "CommentTwitter") as? String {
            self.CommentTwitter = CommentTwitter
        }
        if let HashtagTwitter = aDecoder.decodeObject(forKey: "HashtagTwitter") as? String {
            self.HashtagTwitter = HashtagTwitter
        }
        if let UsersTwitter = aDecoder.decodeObject(forKey: "UsersTwitter") as? String {
            self.UsersTwitter = UsersTwitter
        }
        if let LocationTwitter = aDecoder.decodeObject(forKey: "LocationTwitter") as? String {
            self.LocationTwitter = LocationTwitter
        }
    }
    
    func encode(with aCoder: NSCoder) {
        if let message = self.todo {
            aCoder.encode(message, forKey: "todo")
        }
        if let date = self.dueDate {
            aCoder.encode(date, forKey: "dueDate")
        }
        if let img = self.image {
            aCoder.encode(img, forKey: "image")
        }
        if let identifier = self.id {
            aCoder.encode(identifier, forKey: "identifier")
        }
    }
    
}
