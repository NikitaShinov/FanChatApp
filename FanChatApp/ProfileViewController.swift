//
//  ProfileViewController.swift
//  FanChatApp
//
//  Created by max on 22.03.2022.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        view.backgroundColor = .brown
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(nameLabel)
        scrollView.addSubview(logoutButton)
        scrollView.isUserInteractionEnabled = true
        logoutButton.addTarget(self, action: #selector(logOutButtonPressed), for: .touchUpInside)
    }
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.fill.badge.plus")
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        if let currentUser = Auth.auth().currentUser {
            label.text = currentUser.displayName
        }
        return label
    }()
    
    private let logoutButton: UIButton = {
        
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.8017725994, green: 0.1414930071, blue: 0.1230983969, alpha: 1)
        button.setTitle("Log Out", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.titleLabel?.textColor = .white
        
        return button
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        let size = scrollView.width / 3
        
        imageView.frame = CGRect(x: (scrollView.width - size)/2,
                               y: 20,
                               width: size,
                               height: size)
        
        nameLabel.frame = CGRect(x: 30,
                                      y: imageView.bottom + 10,
                                      width: scrollView.width - 70,
                                      height: 50)
        
        
        
        logoutButton.frame = CGRect(x: 30,
                                   y: scrollView.bottom - 350,
                                   width: scrollView.width - 70,
                                   height: 50)
        
        
    }
    
    @objc private func logOutButtonPressed() {
        do {
            
            try Auth.auth().signOut()
            
        } catch {
            
            alertPopUp(title: "Error!", message: "Something went wrong when logging out.\nPlease try again.")
            return
            
        }
        tabBarController?.dismiss(animated: true, completion: nil)
        let vc = WelcomeViewController()
        present(vc, animated: true, completion: nil)
        
        
    }
    
    private func alertPopUp(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(okAction)
        present(alert,animated: true)
    }
    


}
