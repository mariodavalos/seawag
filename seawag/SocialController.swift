//
//  SocialController.swift
//  seawag
//
//  Created by Mario Dávalos on 15/11/16.
//  Copyright © 2016 Ooomovil. All rights reserved.
//

import Foundation

import UIKit

class SocialController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var SaveButton: UIButton!
    
    @IBOutlet weak var TwitterButton: UIButton!
    @IBOutlet weak var FaceButton: UIButton!
    @IBOutlet weak var CommentButton: UIImageView!
    @IBOutlet weak var HashtagButton: UIImageView!
    @IBOutlet weak var UsersButton: UIImageView!
    @IBOutlet weak var LocationButton: UIImageView!
    @IBOutlet weak var CommentsArrow: UIButton!
    @IBOutlet weak var HastagsArrow: UIButton!
    @IBOutlet weak var UsersArrow: UIButton!
    @IBOutlet weak var Cleaner: UIButton!
    @IBOutlet weak var CaractersNumber: UILabel!
    
    @IBOutlet weak var Comments: UITextField!
    @IBOutlet weak var Hastags: UITextField!
    @IBOutlet weak var Users: UITextField!
    @IBOutlet weak var Locations: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SaveButton.layer.borderWidth = 2
        self.SaveButton.layer.borderColor = UIColor.blue.cgColor
        self.SaveButton.layer.cornerRadius = 22.0
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
        CommentsArrow.setImage(#imageLiteral(resourceName: "MenuTwr"), for: .normal)
        HastagsArrow.setImage(#imageLiteral(resourceName: "MenuTwr"), for: .normal)
        UsersArrow.setImage(#imageLiteral(resourceName: "MenuTwr"), for: .normal)
        
    }
    @IBAction func FaceBookDates(_ sender: UIButton) {
        TwitterButton.setImage(#imageLiteral(resourceName: "Twittoff"), for: .normal)
        FaceButton.setImage(#imageLiteral(resourceName: "Faceboon"), for: .normal)
        CommentButton.image = #imageLiteral(resourceName: "CommentFace")
        HashtagButton.image = #imageLiteral(resourceName: "HashtagFace")
        UsersButton.image = #imageLiteral(resourceName: "UserFace")
        LocationButton.image = #imageLiteral(resourceName: "LocationFace")
        CommentsArrow.setImage(#imageLiteral(resourceName: "MenuFace"), for: .normal)
        HastagsArrow.setImage(#imageLiteral(resourceName: "MenuFace"), for: .normal)
        UsersArrow.setImage(#imageLiteral(resourceName: "MenuFace"), for: .normal)
        
    }
    
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
