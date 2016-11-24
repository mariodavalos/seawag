//
//  SocialController.swift
//  seawag
//
//  Created by Mario Dávalos on 15/11/16.
//  Copyright © 2016 Ooomovil. All rights reserved.
//

import Foundation
import UIKit

class SocialController: UIViewController , UITextFieldDelegate {
    
    @IBOutlet weak var SaveButton: UIButton!
    
    @IBOutlet weak var TwitterButton: UIButton!
    @IBOutlet weak var FaceButton: UIButton!
    @IBOutlet weak var CommentButton: UIImageView!
    @IBOutlet weak var HashtagButton: UIImageView!
    @IBOutlet weak var UsersButton: UIImageView!
    @IBOutlet weak var LocationButton: UIImageView!
    @IBOutlet weak var Cleaner: UIButton!
    @IBOutlet weak var CaractersNumber: UILabel!
    
    @IBOutlet weak var Comments: UITextField!
    @IBOutlet weak var Hastags: UITextField!
    @IBOutlet weak var Users: UITextField!
    @IBOutlet weak var Locations: UITextField!
    
    let socialsave = SocialSaving()
    var socialinfo: SocialInfo?
    
    var socialRed: Bool? = false
    var FaceOrTwr: Bool? = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SaveButton.layer.borderWidth = 1
        self.SaveButton.layer.borderColor =  UIColor.init(red: 98/255.0, green: 159/255.0, blue: 196/255.0, alpha: 1.0).cgColor
        self.SaveButton.layer.cornerRadius = 22.0
        
        socialinfo = socialsave.getItem(index: 0)
        Comments.isEnabled = false
        Hastags.isEnabled = false
        Users.isEnabled = false
        Locations.isEnabled = false

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func Closing(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func TwiterDates(_ sender: UIButton) {
        TwitterButton.setImage(#imageLiteral(resourceName: "Twittonn"), for: .normal)
        FaceButton.setImage(#imageLiteral(resourceName: "Feceboof"), for: .normal)
        CommentButton.image = #imageLiteral(resourceName: "CommentTwr")
        HashtagButton.image = #imageLiteral(resourceName: "HashtagTwr")
        UsersButton.image = #imageLiteral(resourceName: "UserTwr")
        LocationButton.image = #imageLiteral(resourceName: "LocationTwr")
        
        if(socialRed!){
            socialinfo?.CommentFacebook = Comments.text
            socialinfo?.HashtagFacebook = Hastags.text
            socialinfo?.UsersFacebook = Users.text
            socialinfo?.LocationFacebook = Locations.text
        }
        Comments.text = socialinfo?.CommentTwitter
        Hastags.text = socialinfo?.HashtagTwitter
        Users.text = socialinfo?.UsersTwitter
        Locations.text = socialinfo?.LocationTwitter
        socialRed = true
        FaceOrTwr = false
        
        Comments.isEnabled = true
        Hastags.isEnabled = true
        Users.isEnabled = true
        Locations.isEnabled = true
        
    }
    @IBAction func FaceBookDates(_ sender: UIButton) {
        TwitterButton.setImage(#imageLiteral(resourceName: "Twittoff"), for: .normal)
        FaceButton.setImage(#imageLiteral(resourceName: "Faceboon"), for: .normal)
        CommentButton.image = #imageLiteral(resourceName: "CommentFace")
        HashtagButton.image = #imageLiteral(resourceName: "HashtagFace")
        UsersButton.image = #imageLiteral(resourceName: "UserFace")
        LocationButton.image = #imageLiteral(resourceName: "LocationFace")
        
        if(socialRed!){
            socialinfo?.CommentTwitter = Comments.text
            socialinfo?.HashtagTwitter = Hastags.text
            socialinfo?.UsersTwitter = Users.text
            socialinfo?.LocationTwitter = Locations.text
        }
        
        Comments.text = socialinfo?.CommentFacebook
        Hastags.text = socialinfo?.HashtagFacebook
        Users.text = socialinfo?.UsersFacebook
        Locations.text = socialinfo?.LocationFacebook
        socialRed = true
        FaceOrTwr = true
        
        Comments.isEnabled = true
        Hastags.isEnabled = true
        Users.isEnabled = true
        Locations.isEnabled = true
        
    }
    
    @IBAction func SaveInfoSocial(_ sender: UIButton) {
        print("Guardando infoSocial:\(Comments.text)")
        if(FaceOrTwr)!{
            socialinfo?.CommentFacebook = Comments.text
            socialinfo?.HashtagFacebook = Hastags.text
            socialinfo?.UsersFacebook = Users.text
            socialinfo?.LocationFacebook = Locations.text
        }else{
            socialinfo?.CommentTwitter = Comments.text
            socialinfo?.HashtagTwitter = Hastags.text
            socialinfo?.UsersTwitter = Users.text
            socialinfo?.LocationTwitter = Locations.text
        }
        socialsave.addItem(item: socialinfo!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches , with: event)
        self.Hastags.resignFirstResponder()
        self.Users.resignFirstResponder()
        self.Locations.resignFirstResponder()
        self.Comments.resignFirstResponder()
    }
    
    //MARK: TextFielDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.Comments {
            self.Hastags.becomeFirstResponder()
        }
        else if textField == self.Hastags {
            self.Users.becomeFirstResponder()
        }
        else if textField == self.Users {
            self.Locations.becomeFirstResponder()
        }
        else if textField == self.Locations {
            Locations.resignFirstResponder()
        }
        return true
    }
    
    
}
