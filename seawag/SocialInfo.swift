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
        if let CommentFacebook = aDecoder.decodeObject(forKey: "CommentFacebook") as? String {
            self.CommentFacebook = CommentFacebook
        }
        if let HashtagFacebook = aDecoder.decodeObject(forKey: "HashtagFacebook") as? String {
            self.HashtagFacebook = HashtagFacebook
        }
        if let UsersFacebook = aDecoder.decodeObject(forKey: "UsersFacebook") as? String {
            self.UsersFacebook = UsersFacebook
        }
        if let LocationFacebook = aDecoder.decodeObject(forKey: "LocationFacebook") as? String {
            self.LocationFacebook = LocationFacebook
        }
    }
    
    func encode(with aCoder: NSCoder) {
        if let CommentTwitter = self.CommentTwitter {
            aCoder.encode(CommentTwitter, forKey: "CommentTwitter")
        }
        if let HashtagTwitter = self.HashtagTwitter {
            aCoder.encode(HashtagTwitter, forKey: "HashtagTwitter")
        }
        if let UsersTwitter = self.UsersTwitter {
            aCoder.encode(UsersTwitter, forKey: "UsersTwitter")
        }
        if let LocationTwitter = self.LocationTwitter {
            aCoder.encode(LocationTwitter, forKey: "LocationTwitter")
        }
        if let CommentFacebook = self.CommentFacebook {
            aCoder.encode(CommentFacebook, forKey: "CommentFacebook")
        }
        if let HashtagFacebook = self.HashtagFacebook {
            aCoder.encode(HashtagFacebook, forKey: "HashtagFacebook")
        }
        if let UsersFacebook = self.UsersFacebook {
            aCoder.encode(UsersFacebook, forKey: "UsersFacebook")
        }
        if let LocationFacebook = self.LocationFacebook {
            aCoder.encode(LocationFacebook, forKey: "LocationFacebook")
        }
    }
    
}
