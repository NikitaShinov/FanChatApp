//
//  RegistrationViewController.swift
//  FanChatApp
//
//  Created by max on 16.03.2022.
//

import UIKit
import FirebaseAuth
import Firebase

class RegisterViewController: UIViewController {
    
    private let spinner = UIActivityIndicatorView(style: .large)
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.fill.badge.plus")
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.systemPurple.cgColor
        return imageView
    }()
    
    private let emailField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 15
        field.layer.borderWidth = 5
        field.layer.borderColor = UIColor.systemPurple.cgColor
        field.placeholder = "Enter your e-mail"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .secondarySystemBackground
        return field
    }()
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.cornerRadius = 15
        field.layer.borderWidth = 5
        field.layer.borderColor = UIColor.systemPurple.cgColor
        field.placeholder = "Enter your password"
        field.isSecureTextEntry = true
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .secondarySystemBackground
        return field
    }()
    
    private let firstNameField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 15
        field.layer.borderWidth = 5
        field.layer.borderColor = UIColor.systemPurple.cgColor
        field.placeholder = "Enter your first name"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .secondarySystemBackground
        return field
    }()
    
    private let lastNameField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 15
        field.layer.borderWidth = 5
        field.layer.borderColor = UIColor.systemPurple.cgColor
        field.placeholder = "Enter your last name"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .secondarySystemBackground
        return field
    }()
    
    private let chooseTeamLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose your favourite team:"
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    
    private let teamChooseOption: UIPickerView = {
        let picker = UIPickerView()
        picker.backgroundColor = UIColor.lightGreen()
        picker.layer.cornerRadius = 15
        picker.layer.borderWidth = 5
        picker.layer.borderColor = UIColor.systemPurple.cgColor
        return picker
    }()
    
    private var viewModel: TeamsViewModelProtocol! {
        didSet {
            viewModel.getResults {
                self.teamChooseOption.reloadAllComponents()
            }
        }
    }
    
    private var favouriteTeamChosen: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = RegistrationViewModel()
        
        view.backgroundColor = UIColor.lightGreen()
        view.addSubview(scrollView)
        configureSpinnerView()
        showSpinnerLoadingView(isShowing: false)
        scrollView.addSubview(imageView)
        scrollView.addSubview(teamChooseOption)
        teamChooseOption.delegate = self
        teamChooseOption.dataSource = self
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(firstNameField)
        scrollView.addSubview(lastNameField)
        scrollView.addSubview(chooseTeamLabel)
        
        scrollView.isUserInteractionEnabled = true
        imageView.isUserInteractionEnabled = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(addTapped))
        
        
        let gesture = UITapGestureRecognizer(target: self,
                                             action: #selector(didTapChangeProfileImage))
        imageView.addGestureRecognizer(gesture)
        
    }
    
    private func showSpinnerLoadingView(isShowing: Bool) {
        if isShowing {
            self.spinner.isHidden = false
            spinner.startAnimating()
        } else if spinner.isAnimating {
            spinner.stopAnimating()
            spinner.isHidden = true
        }
    }
    
    private func configureSpinnerView() {
        
        view.addSubview(spinner)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            spinner.heightAnchor.constraint(equalToConstant: 24),
            spinner.widthAnchor.constraint(equalToConstant: 24)
        ])
        
        spinner.isHidden = true
    }
    
    @objc private func didTapChangeProfileImage() {
        presentPhotoActionSheet()
    }
    
    @objc private func addTapped() {
        
        firstNameField.resignFirstResponder()
        lastNameField.resignFirstResponder()
        
        guard let name = firstNameField.text, !name.isEmpty,
              let lastName = lastNameField.text, !lastName.isEmpty,
              let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty,
              let team = favouriteTeamChosen else {
                  aletUserLoginError(title: "Sign up error!", message: "Please review the information entered.")
                  return
              }

            Auth.auth().createUser(withEmail: email, password: password) { user, error in
                guard user != nil, error == nil else {
                    print ("Error in creation of User")
                    return
                }
                
                guard let image = self.imageView.image else { return }
                guard let imageData = image.jpegData(compressionQuality: 0.3) else { return }
                
                let storage = Storage.storage().reference()
                
                let fileName = NSUUID().uuidString
                
                print ("start uploading image")
                
                self.showSpinnerLoadingView(isShowing: true)
                
                storage.child("profile_avatars").child(fileName).putData(imageData, metadata: nil) { _, error in
                    guard error == nil else {
                        print ("failed to upload profile image")
                        return
                }
                    
                    print ("success in download")
                    storage.child("profile_avatars").child(fileName).downloadURL { url, error in
                        guard error == nil, let url = url else {
                            return
                        }
                        
                        print ("success in download url")
                        
                        let urlString = url.absoluteString
                        print ("Downloaded url: \(urlString)")
                        
                        guard let uid = user?.user.uid else { return }
                        
                        let userPreferences = ["username": name + " " + lastName,
                                               "profile_image": urlString,
                                               "favourite_team": team]
                        
                        let values = [uid: userPreferences]
                        
                        Database.database().reference().child("users").updateChildValues(values) { error, reference in
                            if let error = error {
                                print ("Failed to save user info into DB: \(error)")
                            }
                            
                            self.showSpinnerLoadingView(isShowing: false)
                            print ("successfully saved")
                            
                            self.navigationController?.popToRootViewController(animated: true)
                            self.view.endEditing(true)
                            print (team)
                        }
                    }
            }
        }
    }
    
    func aletUserLoginError(title: String = "Ooops", message: String = "Please enter correct information") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Got it!", style: .cancel))
        present(alert, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds
        let size = scrollView.width / 3
        
        imageView.frame = CGRect(x: (scrollView.width - size)/2,
                                 y: 20,
                                 width: size,
                                 height: size)
        
        imageView.layer.cornerRadius = size / 2
        
        emailField.frame = CGRect(x: 30,
                                  y: imageView.bottom + 20,
                                  width: scrollView.width - 70,
                                  height: 50)
        
        passwordField.frame = CGRect(x: 30,
                                     y: emailField.bottom + 10,
                                     width: scrollView.width - 70,
                                     height: 50)
        
        firstNameField.frame = CGRect(x: 30,
                                      y: passwordField.bottom + 10,
                                      width: scrollView.width - 70,
                                      height: 50)
        
        lastNameField.frame = CGRect(x: 30,
                                     y: firstNameField.bottom + 10,
                                     width: scrollView.width - 70,
                                     height: 50)
        
        
        chooseTeamLabel.frame = CGRect(x: 30,
                                       y: lastNameField.bottom + 20,
                                       width: scrollView.width - 70,
                                       height: 70)
        
        teamChooseOption.frame = CGRect(x: 30,
                                        y: chooseTeamLabel.bottom + 20,
                                        width: scrollView.width - 70,
                                        height: 70)
        
    }

}

extension RegisterViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        viewModel.numberOfItems()
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        favouriteTeamChosen = viewModel.titleForRow(for: row)
        return favouriteTeamChosen
        
    }
}

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: nil,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Take Photo",
                                            style: .default,
                                            handler: { [weak self]_ in
                                                        self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo",
                                            style: .default,
                                            handler: { [weak self]_ in
                                                        self?.presentPhotoLibrary()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel))
        
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
