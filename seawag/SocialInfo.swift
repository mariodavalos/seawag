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
    
    var CommentFacebook: String?
    
    var HashtagFacebook: String?
    
    var UsersFacebook: String?
    
    var UsuarioEmail: String?
    
    
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
        if let CommentFacebook = aDecoder.decodeObject(forKey: "CommentFacebook") as? String {
            self.CommentFacebook = CommentFacebook
        }
        if let HashtagFacebook = aDecoder.decodeObject(forKey: "HashtagFacebook") as? String {
            self.HashtagFacebook = HashtagFacebook
        }
        if let UsersFacebook = aDecoder.decodeObject(forKey: "UsersFacebook") as? String {
            self.UsersFacebook = UsersFacebook
        }
        if let UsuarioEmail = aDecoder.decodeObject(forKey: "UsuarioEmail") as? String {
            self.UsuarioEmail = UsuarioEmail
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
        if let CommentFacebook = self.CommentFacebook {
            aCoder.encode(CommentFacebook, forKey: "CommentFacebook")
        }
        if let HashtagFacebook = self.HashtagFacebook {
            aCoder.encode(HashtagFacebook, forKey: "HashtagFacebook")
        }
        if let UsersFacebook = self.UsersFacebook {
            aCoder.encode(UsersFacebook, forKey: "UsersFacebook")
        }
        if let UsuarioEmail = self.UsuarioEmail {
            aCoder.encode(UsuarioEmail, forKey: "UsuarioEmail")
        }
    }
    
}
