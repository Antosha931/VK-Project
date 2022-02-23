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
    @IBOutlet weak var loadingView1: UIView!
    @IBOutlet weak var loadingView2: UIView!
    @IBOutlet weak var loadingView3: UIView!
    
    let segueIdentifierToTabBar = "reuseIdentifierToTabBar"
    let networking = NetworkService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupImageLoading()
        
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
            animatedLoadingLabel()
//            performSegue(withIdentifier: segueIdentifierToTabBar, sender: nil)
        } else {
            showAlert(message: "Логин или пароль введены неверно, повторите попытку!")
            { _ in self.backView.backgroundColor = UIColor.red
                return
            }
        }
    }
}

// MARK: - Loading indicator animation

extension LoginViewController {
    
    func setupImageLoading() {
        loadingView1.alpha = 0
        loadingView1.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        loadingView2.alpha = 0
        loadingView2.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        loadingView3.alpha = 0
        loadingView3.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
    }
    
    func animatedLoadingLabel() {
        UIView.animate(withDuration: 1.5,
                                delay: 0.5,
                                options: [.autoreverse, .repeat],
                                animations: {
                                    self.loadingView1.alpha = 1
                                },
                                completion: nil)
        UIView.animate(withDuration: 1.5,
                                delay: 1,
                                options: [.autoreverse, .repeat],
                                animations: {
                                    self.loadingView2.alpha = 1
                                },
                                completion: nil)
        UIView.animate(withDuration: 1.5,
                                delay: 1.5,
                                options: [.autoreverse, .repeat],
                                animations: {
                                    self.loadingView3.alpha = 1
                                },
                                completion: {_ in
                                    self.performSegue(withIdentifier: self.segueIdentifierToTabBar, sender: nil)
                                })
    }
}

