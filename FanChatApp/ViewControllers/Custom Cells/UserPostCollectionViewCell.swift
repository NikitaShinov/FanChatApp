//
//  UserPostCollectionViewCell.swift
//  FanChatApp
//
//  Created by max on 18.05.2022.
//

import UIKit

class UserPostCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PostCell"
    
    let userProfileImageView: CustomImageView = {
        let image = CustomImageView()
        image.backgroundColor = .yellow
        return image
    }()
    
    let postLabel: UILabel = {
        let post = UILabel()
        post.backgroundColor = .red
        return post
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .blue
        return label
    }()
    
    let likeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .green
        return button
    }()
    
    let commentButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .brown
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .purple
        
        let buttonsStackView = UIStackView(arrangedSubviews: [likeButton, commentButton])
        buttonsStackView.distribution = .fillEqually
        
        addSubview(userProfileImageView)
        addSubview(postLabel)
        addSubview(userNameLabel)
        addSubview(buttonsStackView)
        
        userProfileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 30, height: 30)
        userNameLabel.anchor(top: topAnchor, left: userProfileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 100, height: 30)
        postLabel.anchor(top: userProfileImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: 0, height: 100)
        buttonsStackView.anchor(top: postLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 120, height: 30)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
