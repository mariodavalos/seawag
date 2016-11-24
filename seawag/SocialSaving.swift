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
        return documentDirectoryURL.appendingPathComponent("Seawag.plist")!
    }()
    
    func addItem(item:SocialInfo){
        items.append(item)
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
    func getItem(index: Int) -> SocialInfo{
        let item: SocialInfo? = SocialInfo()
        if (items.count<1){
            return item!
        }
        else{
            return items[index]
        }
    }
}
