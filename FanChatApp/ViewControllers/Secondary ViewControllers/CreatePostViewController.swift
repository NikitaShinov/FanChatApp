//
//  CreatePostViewController.swift
//  FanChatApp
//
//  Created by max on 23.05.2022.
//

import UIKit

class CreatePostViewController: UIViewController {
    
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
        view.backgroundColor = .systemBackground
        view.addSubview(createButton)
        view.addSubview(textView)
        view.addSubview(questionLabel)
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
    }
    
    @objc func createButtonTapped() {
        print ("Post created")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        createButton.frame = CGRect(x: (view.frame.size.width / 2) - 85, y: view.bottom - 200, width: 170, height: 40)
        textView.frame = CGRect(x: 20, y: view.top + 100, width: view.frame.size.width - 40, height: 200)
        questionLabel.frame = CGRect(x: 20, y: view.top + 20, width: textView.frame.size.width, height: 30)
    }
    
}
