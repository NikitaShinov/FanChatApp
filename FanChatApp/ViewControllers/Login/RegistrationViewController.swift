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
        setupUI()
        addSubviews()
        
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        configureSpinnerView()
        showSpinnerLoadingView(isShowing: false)
        
        teamChooseOption.delegate = self
        teamChooseOption.dataSource = self
        
        
        view.isUserInteractionEnabled = true
        imageView.isUserInteractionEnabled = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(addTapped))
        
        
        let gesture = UITapGestureRecognizer(target: self,
                                             action: #selector(didTapChangeProfileImage))
        imageView.addGestureRecognizer(gesture)
        initializeHideKeyboard()
    }
    
    private func addSubviews() {
        view.addSubview(imageView)
        view.addSubview(teamChooseOption)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(firstNameField)
        view.addSubview(lastNameField)
        view.addSubview(chooseTeamLabel)
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
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
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
                
                self.saveUserCredentials(username: email, password: password)
                
                guard let image = self.imageView.image else { return }
                guard let imageData = image.jpegData(compressionQuality: 0.3) else { return }
                
                let storage = Storage.storage().reference()
                
                let fileName = NSUUID().uuidString
                
                
                self.showSpinnerLoadingView(isShowing: true)
                
                storage.child("profile_avatars").child(fileName).putData(imageData, metadata: nil) { _, error in
                    guard error == nil else {
                        print ("failed to upload profile image")
                        return
                }
                    

                    storage.child("profile_avatars").child(fileName).downloadURL { url, error in
                        guard error == nil, let url = url else {
                            return
                        }
                        
                        
                        let urlString = url.absoluteString

                        
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
                            self.navigationController?.popToRootViewController(animated: true)
                            self.view.endEditing(true)
                        }
                    }
            }
        }
    }
    
    func saveUserCredentials(username: String, password: String) {
        UserDefaults.standard.set(username, forKey: Constants.kUserName)
        UserDefaults.standard.synchronize()
        
        
        let passwordItem = KeychainPasswordItem(service: KeychainConfig.serviceName, account: username, accessGroup: KeychainConfig.accessGroup)
        
        do {
            try passwordItem.savePassword(password)
        } catch let error {
            fatalError("Error with Keychain saving password: \(error)")
        }
    }
    
    func aletUserLoginError(title: String = "Ooops", message: String = "Please enter correct information") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Got it!", style: .cancel))
        present(alert, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let size = view.width / 3
        
        guard let navBarBottom = navigationController?.navigationBar.bottom else { return }
        
        imageView.frame = CGRect(x: (view.width - size)/2,
                                 y: navBarBottom + 10,
                                 width: size,
                                 height: size)
        
        imageView.layer.cornerRadius = size / 2
        
        emailField.frame = CGRect(x: view.center.x - ((view.width - 70) / 2),
                                  y: imageView.bottom + 20,
                                  width: view.width - 70,
                                  height: 50)
        
        passwordField.frame = CGRect(x: view.center.x - ((view.width - 70) / 2),
                                     y: emailField.bottom + 10,
                                     width: view.width - 70,
                                     height: 50)
        
        firstNameField.frame = CGRect(x: view.center.x - ((view.width - 70) / 2),
                                      y: passwordField.bottom + 10,
                                      width: view.width - 70,
                                      height: 50)
        
        lastNameField.frame = CGRect(x: view.center.x - ((view.width - 70) / 2),
                                     y: firstNameField.bottom + 10,
                                     width: view.width - 70,
                                     height: 50)
        
        
        chooseTeamLabel.frame = CGRect(x: view.center.x - ((view.width - 70) / 2),
                                       y: lastNameField.bottom + 20,
                                       width: view.width - 70,
                                       height: 70)
        
        teamChooseOption.frame = CGRect(x: view.center.x - ((view.width - 70) / 2),
                                        y: chooseTeamLabel.bottom + 20,
                                        width: view.width - 70,
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
