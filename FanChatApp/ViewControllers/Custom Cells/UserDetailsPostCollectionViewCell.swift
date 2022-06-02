//
//  UserDetailsPostCollectionViewCell.swift
//  FanChatApp
//
//  Created by max on 25.05.2022.
//

import UIKit

class UserDetailsPostCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "UserDetailsPostCell"
    
    let userProfileImageView: CustomImageView = {
        let image = CustomImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    let postLabel: UILabel = {
        let post = UILabel()
        post.numberOfLines = 0
        return post
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
//        label.backgroundColor = .blue
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.borderColor = UIColor.purple.cgColor
        contentView.layer.borderWidth = 3
        contentView.layer.cornerRadius = 10
    
        addSubview(userProfileImageView)
        addSubview(postLabel)
        addSubview(userNameLabel)
        
        userProfileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 30, height: 30)
        userProfileImageView.layer.cornerRadius = 15
        userNameLabel.anchor(top: topAnchor, left: userProfileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 100, height: 30)
        postLabel.anchor(top: userProfileImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 0, height: 0)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
