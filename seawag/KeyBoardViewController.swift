//
//  KeyBoardViewController.swift
//  Certificaciones
//
//  Created by Martin Viruete Gonzalez on 16/08/16.
//  Copyright © 2016 oOMovil. All rights reserved.
//

import UIKit

class KeyBoardViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var keyBoardIsVisible = false
    private var keyBoardDidShow = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.cerrarTeclado)))
        NotificationCenter.default.addObserver(self,selector: #selector(self.keyboardDidShow(notification:)),name: NSNotification.Name.UIKeyboardDidShow,object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(self.keyboardDidHide(notification:)),name: NSNotification.Name.UIKeyboardDidHide,object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(self.keyboardWillShow(notification:)),name: NSNotification.Name.UIKeyboardWillShow,object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(self.keyboardWillHide(notification:)),name: NSNotification.Name.UIKeyboardWillHide,object: nil)
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    // MARK: - Ajustar Keyboard
    func adjustInsetForKeyboardShow(show: Bool, notification: NSNotification) {
        guard self.scrollView != nil else { return }
        guard let value = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue else { return }
        
        self.keyBoardIsVisible = show
        let keyboardFrame = value.cgRectValue
        let adjustmentHeight = (keyboardFrame.height + 20) * (show ? 1 : -1)
        self.scrollView.contentInset.bottom += adjustmentHeight
        self.scrollView.scrollIndicatorInsets.bottom += adjustmentHeight
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if !self.keyBoardIsVisible{
            self.adjustInsetForKeyboardShow(show: true, notification: notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.adjustInsetForKeyboardShow(show: false, notification: notification)
    }
    
    func keyboardDidShow(notification: NSNotification){
        self.keyBoardDidShow = true
    }
    
    func keyboardDidHide(notification: NSNotification){
        self.keyBoardDidShow = false
    }
    
    func cerrarTeclado(){
        if self.keyBoardDidShow{
            self.view.endEditing(true)
        }
    }
    
    // MARK: - deinit
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}
