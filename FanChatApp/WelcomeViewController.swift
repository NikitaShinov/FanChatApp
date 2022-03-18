//
//  WelcomeViewController.swift
//  FanChatApp
//
//  Created by max on 02.02.2022.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Welcome"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = #colorLiteral(red: 0.9114710668, green: 1, blue: 0.7352172452, alpha: 1)
        view.addSubview(scrollView)
        scrollView.addSubview(appLogo)
        scrollView.addSubview(emailTextField)
        scrollView.addSubview(passwordTextField)
        scrollView.addSubview(loginButton)
        scrollView.addSubview(registerButton)
        
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
    }
    
    private let appLogo: UIImageView = {
        let appLogoName = "appLogo"
        let image = UIImage(named: appLogoName)
        let imageView = UIImageView(image: image)
        
        return imageView
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let emailTextField: UITextField = {
        
        let login = UITextField()
        login.placeholder = "Enter your e-mail"
        login.autocorrectionType = .no
        login.returnKeyType = .continue
        login.layer.cornerRadius = 15
        login.layer.borderWidth = 5
        login.layer.borderColor = UIColor.orange.cgColor
        login.backgroundColor = .systemBackground
        login.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        login.leftViewMode = .always
        
        return login
        
    }()
    
    private let passwordTextField: UITextField = {
        
        let password = UITextField()
        password.placeholder = "Enter your password"
        password.autocorrectionType = .no
        password.returnKeyType = .done
        password.layer.cornerRadius = 15
        password.layer.borderWidth = 5
        password.isSecureTextEntry = true
        password.layer.borderColor = UIColor.orange.cgColor
        password.backgroundColor = .systemBackground
        password.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        password.leftViewMode = .always
        
        return password
        
    }()
    
    private let loginButton: UIButton = {
        
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        
        return button
    }()
    
    private let registerButton: UIButton = {
        
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0, green: 0.8017725994, blue: 0.131030637, alpha: 1)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        
        return button
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        let size = scrollView.width / 3
        
        appLogo.frame = CGRect(x: (scrollView.width - size)/2,
                               y: 20,
                               width: size,
                               height: size)
        
        emailTextField.frame = CGRect(x: 30,
                                      y: appLogo.bottom + 10,
                                      width: scrollView.width - 70,
                                      height: 50)
        
        passwordTextField.frame = CGRect(x: 30,
                                         y: emailTextField.bottom + 10,
                                         width: scrollView.width - 70,
                                         height: 50)
        
        loginButton.frame = CGRect(x: 30,
                                   y: scrollView.bottom - 350,
                                   width: scrollView.width - 70,
                                   height: 50)
        
        registerButton.frame = CGRect(x: 30,
                                      y: loginButton.bottom + 10,
                                      width: scrollView.width - 70,
                                      height: 50)
        
        
    }
    
    @objc private func registerButtonTapped() {
        let vc = RegisterViewController()
        vc.title = "Create new User"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func loginButtonTapped() {
        guard let emailAdress = emailTextField.text, emailAdress != "",
              let password = passwordTextField.text, password != "", password.count >= 6 else {
                  alertPopUp()
                  return
              }
        Auth.auth().signIn(withEmail: emailAdress, password: password) { user, error in
            if let error = error {
                self.alertPopUp()
                print (error.localizedDescription)
                return
            }
            self.view.endEditing(true)
            
            
        }
        
        
    }
    
    private func alertPopUp() {
        let alert = UIAlertController(title: "Ooops!", message: "Wrong input.\nPlease check your credentials.", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(okayAction)
        present(alert, animated: true)
    }


}

