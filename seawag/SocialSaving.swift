//
//  SocialSaving.swift
//  seawag
//
//  Created by Mario Dávalos on 23/11/16.
//  Copyright © 2016 Ooomovil. All rights reserved.
//

import UIKit

class SocialSaving: NSObject {
    var items: [SocialInfo] = []
    
    override init(){
        super.init()
        loadItems()
    }
    
    private let fileURL: URL = {
        let fileManager = FileManager.default
        let documentDirectoryURLs = fileManager.urls(for: .documentDirectory, in: .userDomainMask) as [NSURL]
        let documentDirectoryURL = documentDirectoryURLs.first!
        print ("path de documents \(documentDirectoryURL)")
        return documentDirectoryURL.appendingPathComponent("SeawagSocial.plist")!
    }()
    
    func addItem(item:SocialInfo){
        var index = 0
        var insert:Bool = false
        for itemb in items{
            if(itemb.UsuarioEmail == item.UsuarioEmail){
                items.insert(itemb, at: index)
                insert = true
            }
            index += 1
        }
        if(!insert){
            items.append(item)
        }
        saveItems()
    }
    
    func saveItems(){
        let itemsArray = items as NSArray
        if NSKeyedArchiver.archiveRootObject(itemsArray, toFile: self.fileURL.path){
            print("Guardado")
        }
        else{
            print("No guardado")
        }
    }
    func loadItems(){
        if let itemsArray = (NSKeyedUnarchiver.unarchiveObject(withFile: self.fileURL.path)){
            self.items = (itemsArray as? [SocialInfo])!
        }
    }
    func getItem() -> SocialInfo{
        let item: SocialInfo? = SocialInfo()
        item?.CommentFacebook = ""
        item?.HashtagTwitter = ""
        item?.CommentTwitter = ""
        item?.HashtagFacebook = ""
        item?.UsersTwitter = ""
        item?.UsersFacebook = ""
        item?.UsuarioEmail = LoginController.EmaiLog
        if (items.count<1){
            return item!
        }
        else{
            for itemb in items{
                if(itemb.UsuarioEmail == LoginController.EmaiLog){
                    return itemb
                }
            }
            return item!
        }
    }
}
