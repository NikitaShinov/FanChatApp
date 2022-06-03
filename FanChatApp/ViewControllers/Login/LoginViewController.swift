//
//  LoginViewController.swift
//  FanChatApp
//
//  Created by max on 02.02.2022.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    private let appLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "pl-logo")
        
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
//        login.text = "a@mail.ru"
        login.autocorrectionType = .no
        login.returnKeyType = .continue
        login.layer.cornerRadius = 15
        login.layer.borderWidth = 5
        login.layer.borderColor = UIColor.systemPurple.cgColor
        login.backgroundColor = .systemBackground
        login.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        login.leftViewMode = .always
        
        return login
        
    }()
    
    private let passwordTextField: UITextField = {
        
        let password = UITextField()
        password.placeholder = "Enter your password"
//        password.text = "arsenal"
        password.autocorrectionType = .no
        password.returnKeyType = .done
        password.layer.cornerRadius = 15
        password.layer.borderWidth = 5
        password.isSecureTextEntry = true
        password.layer.borderColor = UIColor.systemPurple.cgColor
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
    
    private let biometricLoginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .purple
        button.setTitleColor(.white, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 15
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
    
    private let forgotPasswordButton: UIButton = {
       let button =  UIButton()
        button.isOpaque = true
        button.setTitle("Forgot password?", for: .normal)
        button.setTitleColor(.purple, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        return button
    }()
    
    let biometricAuth = BiometricAuth()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.lightGreen()
        view.addSubview(scrollView)
        scrollView.addSubview(appLogo)
        scrollView.addSubview(emailTextField)
        scrollView.addSubview(passwordTextField)
        scrollView.addSubview(loginButton)
        scrollView.addSubview(registerButton)
        scrollView.addSubview(forgotPasswordButton)
        scrollView.addSubview(biometricLoginButton)
        
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        forgotPasswordButton.addTarget(self, action: #selector(forgotPassword), for: .touchUpInside)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let biometricEnabled = UserDefaults.standard.value(forKey: Constants.kBiometricEnabled) as? Bool
        if biometricEnabled != nil && biometricEnabled == true && biometricAuth.canEvaluatePolicy() {
//            biometricLoginButton.isHidden = false
        } else {
//            biometricLoginButton.isHidden = true
        }
        
        switch biometricAuth.biometricType() {
        case .faceID:
            biometricLoginButton.setTitle("Login with Face ID", for: .normal)
        default:
            biometricLoginButton.setTitle("Login with Touch ID", for: .normal)
        }
        
        if let userName = UserDefaults.standard.value(forKey: Constants.kUserName) as? String {
            emailTextField.text = userName
//            let passwordItem = KeychainPasswordItem(service: KeychainConfig.serviceName, account: userName, accessGroup: KeychainConfig.accessGroup)
//            if let password = try? passwordItem.readPassword() {
//                passwordTextField.text = password
//            }
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        let size = scrollView.width / 3
        
        appLogo.frame = CGRect(x: (scrollView.width - size)/2,
                               y: 20,
                               width: size,
                               height: size * 1.5)

        
        emailTextField.frame = CGRect(x: scrollView.center.x - ((scrollView.width - 70) / 2),
                                      y: appLogo.bottom + 10,
                                      width: scrollView.width - 70,
                                      height: 50)
        
        passwordTextField.frame = CGRect(x: scrollView.center.x - ((scrollView.width - 70) / 2),
                                         y: emailTextField.bottom + 10,
                                         width: scrollView.width - 70,
                                         height: 50)
        
        loginButton.frame = CGRect(x: scrollView.center.x - ((scrollView.width - 70) / 2),
                                   y: passwordTextField.bottom + 10,
                                   width: scrollView.width - 70,
                                   height: 50)
        
        registerButton.frame = CGRect(x: scrollView.center.x - ((scrollView.width - 70) / 2),
                                      y: loginButton.bottom + 10,
                                      width: scrollView.width - 70,
                                      height: 50)
        
        biometricLoginButton.frame = CGRect(x: scrollView.center.x - ((scrollView.width - 70) / 2),
                                            y: registerButton.bottom + 10,
                                            width: scrollView.width - 70,
                                            height: 50)
        
        forgotPasswordButton.frame = CGRect(x: scrollView.center.x - ((scrollView.width - 70) / 2),
                                            y: biometricLoginButton.bottom + 10,
                                            width: scrollView.width - 70,
                                            height: 50)
        
    }
    
    @objc private func registerButtonTapped() {
        let vc = RegisterViewController()
        vc.title = "Create new User".uppercased()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func forgotPassword() {
        let vc = ResetPasswordViewController()
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
            
            print ("successfully logged in user: \(user?.user.uid ?? "no user")")
            
            if UserDefaults.standard.value(forKey: Constants.kUserName) == nil {
                //save username
                UserDefaults.standard.set(emailAdress, forKey: Constants.kUserName)
                UserDefaults.standard.synchronize()
                
                
                let passwordItem = KeychainPasswordItem(service: KeychainConfig.serviceName, account: emailAdress, accessGroup: KeychainConfig.accessGroup)
                
                do {
                    try passwordItem.savePassword(password)
                } catch let error {
                    fatalError("Error with Keychain saving password: \(error)")
                }
            }
            
            let vc = EnableBiometricViewController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
        
        
    }
    
    private func alertPopUp() {
        let alert = UIAlertController(title: "Ooops!", message: "Wrong input.\nPlease check your credentials.", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(okayAction)
        present(alert, animated: true)
    }


}

