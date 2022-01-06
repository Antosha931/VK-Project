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
    
    let segueIdentifierToTabBar = "reuseIdentifierToTabBar"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(keyboardDie))
        backView.addGestureRecognizer(gestureRecognizer)
        
    }
    
    @objc func keyboardDie() {
        self.backView.endEditing(true)
    }
    
    func showAlert(message: String, completion: @escaping (UIAlertAction) -> Void) {
        let alertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: completion)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func loginButton(_ sender: Any) {
        if let login = loginTextField.text,
           let password = passwordTextField.text,
           !login.isEmpty,
           !password.isEmpty,
           login == "1",
           password == "1" {
            backView.backgroundColor = UIColor.white
            performSegue(withIdentifier: segueIdentifierToTabBar, sender: nil)
        } else {
            showAlert(message: "Логин или пароль введены неверно, повторите попытку!")
            { _ in self.backView.backgroundColor = UIColor.white
                return
            }
    }
    
}

}

