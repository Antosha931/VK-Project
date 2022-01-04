//
//  ViewController.swift
//  VK Project
//
//  Created by Антон Титов on 04.01.2022.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var nameProjectLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(keyboardDie))
        backView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func keyboardDie() {
        self.backView.endEditing(true)
    }
    
    @objc func keyboardWasShown() {
        backView.largeContentImageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 200, right: 0)
    }
    
    @objc func keyboardHide() {
        backView.largeContentImageInsets = UIEdgeInsets.zero
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @IBAction func loginButton(_ sender: Any) {
        
    }
    
}

