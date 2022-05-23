//
//  CreatePostViewController.swift
//  FanChatApp
//
//  Created by max on 23.05.2022.
//

import UIKit
import Firebase

class CreatePostViewController: UIViewController {
    
    var post: Post?
    var user: User?
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.text = "Share what you think?"
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textColor = UIColor.purple
        label.textAlignment = .left
        return label
    }()
    
    private let createButton: UIButton = {
        let button = UIButton()
        button.setTitle("Share", for: .normal)
        button.backgroundColor = .purple
        button.setTitleColor(UIColor.lightGreen(), for: .normal)
        button.layer.cornerRadius = 15
        return button
    }()
    
    private let textView: UITextView = {
        let field = UITextView()
        field.layer.cornerRadius = 15
        field.layer.borderWidth = 2
        field.layer.borderColor = UIColor.purple.cgColor
        return field
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Создание поста"
        fetchCurrentUser()
        view.backgroundColor = .systemBackground
        view.addSubview(createButton)
        view.addSubview(textView)
        view.addSubview(questionLabel)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .done, target: self, action: #selector(didTapCloseButton))
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
    }
    
    @objc private func didTapCloseButton() {
        dismiss(animated: true, completion: nil)
    }
    
    private func fetchCurrentUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.fetchUserWithUID(uid: uid) { user in
            self.user = user
        }
    }
    
    @objc func createButtonTapped() {
        
        guard let caption = textView.text, caption.count > 0 else { return }
        
        guard let currentUser = user else { return }
        
        let values = ["username": currentUser.username,
                      "image_URL": currentUser.profileImageUrl,
                      "post_text": caption,
                      "creation_date": Date().timeIntervalSince1970,
                      "uid": currentUser.uid] as [String: Any]
        
        Database.database().reference().child("posts").child(currentUser.uid).childByAutoId().updateChildValues(values) { error, reference in
            if let error = error {
                print ("failed to insert post: \(error)")
            }
            print ("Post created")
            self.textView.text = ""
            self.dismiss(animated: true, completion: nil)
            let updateFeedNotificationName = NSNotification.Name(rawValue: "UpdateFeed")
            
            NotificationCenter.default.post(name: updateFeedNotificationName, object: nil)
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        createButton.frame = CGRect(x: (view.frame.size.width / 2) - 85, y: view.bottom - 200, width: 170, height: 40)
        textView.frame = CGRect(x: 20, y: view.top + 130, width: view.frame.size.width - 40, height: 200)
        questionLabel.frame = CGRect(x: 20, y: view.top + 50, width: textView.frame.size.width, height: 30)
    }
    
}
