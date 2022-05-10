//
//  LoginViewController.swift
//  FanChatApp
//
//  Created by max on 02.02.2022.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

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
        scrollView.addSubview(forgotPasswordButton)
        
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        forgotPasswordButton.addTarget(self, action: #selector(forgotPassword), for: .touchUpInside)
        
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
        login.text = "a@mail.ru"
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
        password.text = "arsenal"
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
    
    private let forgotPasswordButton: UIButton = {
       let button =  UIButton()
        button.isOpaque = true
        button.setTitle("Forgot password?", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .thin)
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
                                   y: scrollView.bottom - 450,
                                   width: scrollView.width - 70,
                                   height: 50)
        
        registerButton.frame = CGRect(x: 30,
                                      y: loginButton.bottom + 10,
                                      width: scrollView.width - 70,
                                      height: 50)
        
        forgotPasswordButton.frame = CGRect(x: 30,
                                            y: registerButton.bottom + 10,
                                            width: scrollView.width - 70,
                                            height: 50)
        
    }
    
    @objc private func registerButtonTapped() {
        let vc = RegisterViewController()
        vc.title = "Create new User"
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
            
            
            let tabBarVC = UITabBarController()
            let feedVC = UINavigationController(rootViewController: FeedViewController())
            feedVC.title = "Feed"
            let chatVC = UINavigationController(rootViewController: UsersViewController())
            chatVC.title = "Chat"
            let resultsVC = UINavigationController(rootViewController: ResultsViewController())
            resultsVC.title = "Results"
            let profileVC = UINavigationController(rootViewController: ProfileViewController())
            profileVC.title = "Profile"
            tabBarVC.setViewControllers([feedVC, chatVC, resultsVC, profileVC], animated: true)

            guard let items = tabBarVC.tabBar.items else {
                return
            }

            let images = ["newspaper", "message", "timer.square", "person"]

            for counter in 0..<items.count {
                items[counter].image = UIImage(systemName: images[counter])
            }

            tabBarVC.modalPresentationStyle = .fullScreen
            self.present(tabBarVC, animated: true, completion: nil)
        }
        
        
    }
    
    private func alertPopUp() {
        let alert = UIAlertController(title: "Ooops!", message: "Wrong input.\nPlease check your credentials.", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(okayAction)
        present(alert, animated: true)
    }


}

