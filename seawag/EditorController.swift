//
//  EditorController.swift
//  seawag
//
//  Created by Mario Dávalos on 11/11/16.
//  Copyright © 2016 Ooomovil. All rights reserved.
//

import Foundation
import UIKit
import CoreImage
var context: CIContext!
var currentFilter: CIFilter!

class EditorController: UIViewController {
    
    
    @IBOutlet weak var AplicateButton: UIButton!
    
    @IBOutlet weak var Filter1: UIButton!
    @IBOutlet weak var Filter2: UIButton!
    @IBOutlet weak var Filter3: UIButton!
    @IBOutlet weak var Filter4: UIButton!
    @IBOutlet weak var Filter5: UIButton!
    @IBOutlet weak var Filter6: UIButton!
    @IBOutlet weak var Filter7: UIButton!
    @IBOutlet weak var Filter8: UIButton!
    @IBOutlet weak var Filter9: UIButton!
    @IBOutlet weak var Filter10: UIButton!
    
    @IBOutlet weak var Shadow1: UIButton!
    @IBOutlet weak var Shadow2: UIButton!
    @IBOutlet weak var Shadow3: UIButton!
    @IBOutlet weak var Shadow4: UIButton!
    @IBOutlet weak var Shadow5: UIButton!
    @IBOutlet weak var Shadow6: UIButton!
    @IBOutlet weak var Shadow7: UIButton!
    @IBOutlet weak var Shadow8: UIButton!
    @IBOutlet weak var Shadow9: UIButton!
    @IBOutlet weak var Shadow10: UIButton!
    
    @IBOutlet weak var ImageTake: UIImageView!
    public static var ImageTakes: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ImageTake.image = CameraController.ImageTaken.image
        
        //Filter1.setImage(ImageTake.image, for: .normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func viewDidAppear(_ animated: Bool) {
        RoundFilters()
        DispatchQueue.main.async {
            self.FilterAplicate1()
        }
        
    }
    func FilterAplicate1(){
        
        context = CIContext()
        let beginImage = CIImage(image: ImageTake.image!)?.applying(CGAffineTransform(rotationAngle: 0.0).scaledBy(x: 0.33, y: 0.33))
        var procesedFilter: [UIImage] = []
        for i in 1...10 {
            autoreleasepool {
                context = CIContext()
                if(i==1){currentFilter = CIFilter(name: "CISepiaTone")}
                if(i==2){currentFilter = CIFilter(name: "CIPhotoEffectInstant")}
                if(i==3){currentFilter = CIFilter(name: "CIComicEffect")}
                if(i==4){currentFilter = CIFilter(name: "CIPointillize")}
                if(i==5){currentFilter = CIFilter(name: "CIDiscBlur")}
                if(i==6){currentFilter = CIFilter(name: "CIColorInvert")}
                if(i==7){currentFilter = CIFilter(name: "CIPhotoEffectTonal")}
                if(i==8){currentFilter = CIFilter(name: "CIColorMonochrome")}
                if(i==9){currentFilter = CIFilter(name: "CIPhotoEffectProcess")}
                if(i==10){currentFilter = CIFilter(name: "CICrystallize")}
                currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
                
                if let cgimg = context.createCGImage(currentFilter.outputImage!, from: currentFilter.outputImage!.extent) {
                    procesedFilter.append(UIImage(cgImage: cgimg, scale: CGFloat(0.1), orientation: (CameraController.usingFrontCamera ? UIImageOrientation.leftMirrored: UIImageOrientation.right)))
               }
                context = nil
                currentFilter = nil
            }
        }
        Filter1.setImage(procesedFilter.removeFirst(), for: .normal)
        Filter2.setImage(procesedFilter.removeFirst(), for: .normal)
        Filter3.setImage(procesedFilter.removeFirst(), for: .normal)
        Filter4.setImage(procesedFilter.removeFirst(), for: .normal)
        Filter5.setImage(procesedFilter.removeFirst(), for: .normal)
        Filter6.setImage(procesedFilter.removeFirst(), for: .normal)
        Filter7.setImage(procesedFilter.removeFirst(), for: .normal)
        Filter8.setImage(procesedFilter.removeFirst(), for: .normal)
        Filter9.setImage(procesedFilter.removeFirst(), for: .normal)
        Filter10.setImage(procesedFilter.removeFirst(), for: .normal)
    }
    func RoundFilters(){
        self.AplicateButton.layer.borderWidth = 0.5
        self.AplicateButton.layer.borderColor = UIColor.black.cgColor
        self.AplicateButton.layer.cornerRadius = 15.0
        
        FiltersImage(Filter: Filter1)
        FiltersImage(Filter: Filter2)
        FiltersImage(Filter: Filter3)
        FiltersImage(Filter: Filter4)
        FiltersImage(Filter: Filter5)
        FiltersImage(Filter: Filter6)
        FiltersImage(Filter: Filter7)
        FiltersImage(Filter: Filter8)
        FiltersImage(Filter: Filter9)
        FiltersImage(Filter: Filter10)
    }
    
    func FiltersImage(Filter: UIButton!)
    {
        Filter.layer.cornerRadius =  0.5 * Filter.bounds.size.width
        Filter.clipsToBounds = true
    }
    func ShadowClean(Shadow: UIButton!){
        Shadow.layer.shadowColor = UIColor.white.cgColor
        Shadow.layer.masksToBounds = true
    }
    func ShadowCreate(Shadow: UIButton!){
        Shadow.layer.shadowColor = UIColor.black.cgColor
        Shadow.layer.shadowOpacity = 1.0
        Shadow.layer.shadowRadius = 8
        Shadow.layer.shadowOffset = CGSize(width: 0.0, height: Filter1.bounds.size.width/8)
        Shadow.layer.masksToBounds = false
    }
    func CleanShadows()
    {
        ShadowClean(Shadow: Shadow1)
        ShadowClean(Shadow: Shadow2)
        ShadowClean(Shadow: Shadow3)
        ShadowClean(Shadow: Shadow4)
        ShadowClean(Shadow: Shadow5)
        ShadowClean(Shadow: Shadow6)
        ShadowClean(Shadow: Shadow7)
        ShadowClean(Shadow: Shadow8)
        ShadowClean(Shadow: Shadow9)
        ShadowClean(Shadow: Shadow10)
    }
    
    @IBAction func FilterFunction1(_ sender: UIButton) {
        CleanShadows()
        ShadowCreate(Shadow: Shadow1)
        ImageTake.image = Filter1.image(for: .normal)
    }
    
    @IBAction func FilterFunction2(_ sender: UIButton) {
        CleanShadows()
        ShadowCreate(Shadow: Shadow2)
        ImageTake.image = Filter2.image(for: .normal)
    }
    
    @IBAction func FilterFunction3(_ sender: UIButton) {
        CleanShadows()
        ShadowCreate(Shadow: Shadow3)
        ImageTake.image = Filter3.image(for: .normal)
    }
    
    @IBAction func FilterFunction4(_ sender: UIButton) {
        CleanShadows()
        ShadowCreate(Shadow: Shadow4)
        ImageTake.image = Filter4.image(for: .normal)
    }
    
    @IBAction func FilterFunction5(_ sender: UIButton) {
        CleanShadows()
        ShadowCreate(Shadow: Shadow5)
        ImageTake.image = Filter5.image(for: .normal)
    }
    
    @IBAction func FilterFunction6(_ sender: UIButton) {
        CleanShadows()
        ShadowCreate(Shadow: Shadow6)
        ImageTake.image = Filter6.image(for: .normal)
    }
    
    @IBAction func FilterFunction7(_ sender: UIButton) {
        CleanShadows()
        ShadowCreate(Shadow: Shadow7)
        ImageTake.image = Filter7.image(for: .normal)
    }
    
    @IBAction func FilterFunction8(_ sender: UIButton) {
        CleanShadows()
        ShadowCreate(Shadow: Shadow8)
        ImageTake.image = Filter8.image(for: .normal)
    }
    
    @IBAction func FilterFunction9(_ sender: UIButton) {
        CleanShadows()
        ShadowCreate(Shadow: Shadow9)
        ImageTake.image = Filter9.image(for: .normal)
    }
    
    @IBAction func FilterFunction10(_ sender: UIButton) {
        CleanShadows()
        ShadowCreate(Shadow: Shadow10)
        ImageTake.image = Filter10.image(for: .normal)
    }
    @IBAction func AplicateFilter(_ sender: UIButton) {
        CameraController.ImageTaken.image = ImageTake.image;
        self.dismiss(animated: true, completion: nil)
    }
    
}
