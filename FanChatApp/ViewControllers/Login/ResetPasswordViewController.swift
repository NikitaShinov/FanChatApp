//
//  ResetPasswordViewController.swift
//  FanChatApp
//
//  Created by max on 27.03.2022.
//

import UIKit
import Firebase

class ResetPasswordViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let emailField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.cornerRadius = 15
        field.layer.borderWidth = 5
        field.layer.borderColor = UIColor.systemPurple.cgColor
        field.placeholder = "Enter your e-mail"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .secondarySystemBackground
        return field
    }()
    
    private let resetButton: UIButton = {
        
        let button = UIButton()
        button.setTitle("Reset", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "RESET PASSWORD"
        
        view.backgroundColor = UIColor.lightGreen()
        view.addSubview(scrollView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(resetButton)
        
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds
        
        emailField.frame = CGRect(x: 30,
                                  y: 20,
                                  width: scrollView.width - 70,
                                  height: 50)
        
        resetButton.frame = CGRect(x: 30,
                                   y: scrollView.bottom - 450,
                                   width: scrollView.width - 70,
                                   height: 50)
    }
    
    @objc private func resetButtonTapped() {
        guard let emailAddress = emailField.text, !emailAddress.isEmpty else {
            alertPopUp(title: "Input Error",
                       message: "Please provide your email address for password reset.")
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: emailAddress) { error in
            let title = (error == nil) ? "Password Reset Follow-up": "Password Reset Error"
            let message = (error == nil) ? "We have just sent you a password reset email. Please check your inbox and follow the instructions to reset your password.": error?.localizedDescription
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .cancel) { action in
                if error == nil {
                    self.view.endEditing(true)
                    if let navController = self.navigationController {
                        navController.popToRootViewController(animated: true)
                    }
                }
            }
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func alertPopUp(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    
}
