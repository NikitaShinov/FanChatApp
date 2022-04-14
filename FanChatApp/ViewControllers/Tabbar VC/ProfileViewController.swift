//
//  ProfileViewController.swift
//  FanChatApp
//
//  Created by max on 22.03.2022.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    var user: User? {
        didSet {
            guard let imageUrl = user?.profileImageUrl else { return }
            imageView.loadImage(urlString: imageUrl)
            print (imageUrl)
            nameLabel.text = user?.username
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        view.backgroundColor = .brown
        
        setupScrollView()
//        setupProfile()
        
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(nameLabel)
        scrollView.addSubview(logoutButton)
    }
    
//    private func setupProfile() {
//        viewModel = ProfileViewModel()
//        guard let image = viewModel.profileImage else { return }
//        imageView.image = UIImage(data: image)
//        nameLabel.text = viewModel.profileName
//        print (viewModel.profileName)
//    }
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        scrollView.isUserInteractionEnabled = true
        return scrollView
    }()
    
    private let imageView: CustomImageView = {
        let imageView = CustomImageView()
//        imageView.isUserInteractionEnabled = true
//        let gesture = UITapGestureRecognizer(target: self,
//                                             action: #selector(didTapChangeProfileImage))
//        imageView.addGestureRecognizer(gesture)
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        if let currentUser = Auth.auth().currentUser {
            label.text = UserDefaults.standard.value(forKey: "name") as? String ?? "Name not found"
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
        button.addTarget(self, action: #selector(logOutButtonPressed), for: .touchUpInside)
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
    
    @objc private func didTapChangeProfileImage() {
        presentPhotoActionSheet()
    }
    
    @objc private func logOutButtonPressed() {
        do {
            
            try Auth.auth().signOut()
            
        } catch {
            
            alertPopUp(title: "Error!", message: "Something went wrong when logging out.\nPlease try again.")
            return
            
        }
        tabBarController?.dismiss(animated: true, completion: nil)
        let vc = LoginViewController()
        present(vc, animated: true, completion: nil)
    
    }
    
    private func alertPopUp(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(okAction)
        present(alert,animated: true)
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: nil,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Take photo",
                                            style: .default,
                                            handler: { [weak self] _ in
            self?.presentCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Choose photo",
                                            style: .default,
                                            handler: { [weak self] _ in
            self?.presentPhotoLibrary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        
        present(actionSheet, animated: true)
        
    }
    
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func presentPhotoLibrary() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        self.imageView.image = selectedImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
}
