//
//  ProfileViewController.swift
//  FanChatApp
//
//  Created by max on 22.03.2022.
//

import UIKit
import Firebase
import SideMenu


class ProfileViewController: UIViewController {
    
    
    var profileViewModel: ProfileViewModelProtocol!
    
    var menu: SideMenuNavigationController!
    
    private let imageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .gray
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center

        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Profile"
        view.backgroundColor = .white
        setupScrollView()
        setupNavBarItem()
        setupProfile()
        
    }
    
    private func setupScrollView() {
        view.addSubview(imageView)
        view.addSubview(nameLabel)
    }
    
    private func setupNavBarItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "sidebar.leading"), style: .done, target: self, action: #selector(didTapMenuButton))
        navigationItem.leftBarButtonItem?.tintColor = .purple
        menu = SideMenuNavigationController(rootViewController: MenuListController())
        menu?.leftSide = true
        menu?.setNavigationBarHidden(true, animated: false)
        SideMenuManager.default.leftMenuNavigationController = menu
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "gear"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(logOutButtonPressed))
        
        
        navigationItem.rightBarButtonItem?.tintColor = .purple
        
    }
    
    private func setupProfile() {
        profileViewModel = ProfileViewModel()
        profileViewModel.getUser { user in
            self.nameLabel.text = user.username
            self.imageView.loadImage(urlString: user.profileImageUrl)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let size = view.width / 3
        
        guard let navBarBottom = navigationController?.navigationBar.bottom else { return }
        
        imageView.frame = CGRect(x: (view.width - size)/2,
                                 y: navBarBottom + 20,
                                 width: size,
                                 height: size)
        
        imageView.layer.cornerRadius = size / 2
        
        nameLabel.frame = CGRect(x: 30,
                                 y: imageView.bottom + 10,
                                 width: view.width - 70,
                                 height: 50)

        
    }
    
    @objc private func didTapMenuButton() {
        present(menu, animated: true)
    }
    
    @objc private func logOutButtonPressed() {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { _ in
            do {
                
                try Auth.auth().signOut()
                
                self.navigationController?.dismiss(animated: true, completion: nil)
                
            } catch {
                
                self.alertPopUp(title: "Error!", message: "Something went wrong when logging out.\nPlease try again.")
                return
                
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
        
    
    }
    
    private func alertPopUp(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(okAction)
        present(alert,animated: true)
    }
}
