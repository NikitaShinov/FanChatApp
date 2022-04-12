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
    
    private let emailField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
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
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
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
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
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
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
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
        picker.backgroundColor = .systemBackground
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
        
        view.backgroundColor = .white
        view.addSubview(scrollView)
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
        
//        DatabaseManager.shared.userExists(with: email) { [weak self] exists in
//            guard !exists else {
//                print ("error when logging in (RegisterVC)")
//                return
//            }
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
                                               "favourite_team": team]
                        
                        let values = [uid: userPreferences]
                        
                        Database.database().reference().child("users").updateChildValues(values) { error, reference in
                            if let error = error {
                                print ("Failed to save user info into DB: \(error)")
                            }
                            
                            print ("successfully saved")
                            
                            self.navigationController?.popToRootViewController(animated: true)
                            self.view.endEditing(true)
                            print (team)
                        }
                    }
            }
        }
    }
    //                UserDefaults.standard.setValue(email, forKey: "email")
    //                UserDefaults.standard.setValue("\(name) \(lastName)", forKey: "name")
    //
    //                let newUser = User(firstName: name,
    //                                    lastName: lastName,
    //                                    emailAddress: email,
    //                                    preferredTeam: team
    //                )
    //                DatabaseManager.shared.insertUser(with: newUser) { success in
    //                    if success {
    //                        guard let image = self?.imageView.image,
    //                              let data = image.pngData() else {
    //                                  return
    //                              }
    //                        let fileName = newUser.profilePictureFileName
    //                        StorageManager.shared.pictureUpload(with: data, fileName: fileName) { result in
    //                            switch result {
    //                            case .success(let downloadURL):
    //                                UserDefaults.standard.setValue(downloadURL, forKey: "profile_picture_url")
    //                                print ("Download URL: \(downloadURL)")
    //                            case .failure(let error):
    //                                print ("Error in storing data: \(error)")
    //                            }
    //                        }
    //                    }
    //                }
    
    
        
//        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
//            if let error = error {
//                self?.aletUserLoginError(title: "Registration error.", message: error.localizedDescription)
//                return
//            }
//
//            if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
//                changeRequest.displayName = name
//                changeRequest.commitChanges { error in
//                    if let error = error {
//                        print ("Failed to change the display name:\(error.localizedDescription)")
//                    }
//                }
//            }
//            self?.navigationController?.popToRootViewController(animated: true)
//            self?.view.endEditing(true)
//            print (team)
//        }
    
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
