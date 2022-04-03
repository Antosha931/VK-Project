//
//  ViewController.swift
//  VK Project
//
//  Created by Антон Титов on 04.01.2022.
//

import UIKit
import FirebaseAuth

final class LoginViewController: UIViewController {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var nameProjectLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private let segueIdentifierToTabBar = "reuseIdentifierToTabBar"
    private let networking = NetworkService()
    private var notificationFb: AuthStateDidChangeListenerHandle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(keyboardDie))
        backView.addGestureRecognizer(gestureRecognizer)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        notificationFb = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            guard let self = self else { return }
            if user != nil {
                self.performSegue(withIdentifier: self.segueIdentifierToTabBar, sender: nil)
                self.loginTextField.text = nil
                self.passwordTextField.text = nil
        } }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        Auth.auth().removeStateDidChangeListener(notificationFb)
    }
    
    @objc func keyboardDie() {
        self.backView.endEditing(true)
    }
    
    private func showAlert(message: String) {
        let alertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func userRegistrationButton(_ sender: Any) {
        let alert = UIAlertController(title: "Регистрация пользователя", message: "Заполните данные", preferredStyle: .alert)
        
        alert.addTextField { textEmail in
            textEmail.placeholder = "Введите email"
        }
        alert.addTextField { textPassword in
            textPassword.isSecureTextEntry = true
            textPassword.placeholder = "Введите пароль" }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let emailField = alert.textFields?[0],
                  let passwordField = alert.textFields?[1],
                  let password = passwordField.text,
                  let email = emailField.text else { return }
            
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] (user, error) in
                if let error = error { self?.showAlert(message: error.localizedDescription) } else {
                    Auth.auth().signIn(withEmail: email, password: password) }
            }
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func loginButton(_ sender: Any) {
        guard let email = loginTextField.text,
           let password = passwordTextField.text,
           !email.isEmpty,
           !password.isEmpty else {
            showAlert(message: "Заполните поля для ввода пользовательсикх данных")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if let _ = error, user == nil {
                return self.showAlert(message: "Логин или пароль введены неверно, повторите попытку!")
            } else {
                self.performSegue(withIdentifier: self.segueIdentifierToTabBar, sender: nil)
            }
        }
    }
    
    @IBAction func anonymousLoginButton(_ sender: Any) {
        Auth.auth().signInAnonymously { authResult, error in
            guard let user = authResult?.user else { return }
            print(user)
            if user.isAnonymous {
                let uid = user.uid
                print(uid)
                self.performSegue(withIdentifier: self.segueIdentifierToTabBar, sender: nil)
            } else {
                self.showAlert(message: error?.localizedDescription ?? "")
            }
        }
    }
}

// MARK: - Loading indicator animation

//extension LoginViewController {
//
//    func setupImageLoading() {
//        loadingView1.alpha = 0
//        loadingView1.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
//        loadingView2.alpha = 0
//        loadingView2.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
//        loadingView3.alpha = 0
//        loadingView3.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
//    }
//
//    func animatedLoadingLabel() {
//        UIView.animate(withDuration: 1.5,
//                                delay: 0.5,
//                                options: [.autoreverse, .repeat],
//                                animations: {
//                                    self.loadingView1.alpha = 1
//                                },
//                                completion: nil)
//        UIView.animate(withDuration: 1.5,
//                                delay: 1,
//                                options: [.autoreverse, .repeat],
//                                animations: {
//                                    self.loadingView2.alpha = 1
//                                },
//                                completion: nil)
//        UIView.animate(withDuration: 1.5,
//                                delay: 1.5,
//                                options: [.autoreverse, .repeat],
//                                animations: {
//                                    self.loadingView3.alpha = 1
//                                },
//                                completion: {_ in
//                                    self.performSegue(withIdentifier: self.segueIdentifierToTabBar, sender: nil)
//                                })
//    }
//}

