//
//  UserDetailsHeader.swift
//  FanChatApp
//
//  Created by max on 25.05.2022.
//

import UIKit

class UserDetailsHeader: UICollectionViewCell {
    
    var user: User?
    
    let userImage: CustomImageView = {
        let image = CustomImageView()
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 50
        image.layer.borderColor = UIColor.purple.cgColor
        image.layer.borderWidth = 2
        image.backgroundColor = .red
        return image
    }()
    
    let detailsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    let divider: UIView = {
        let label = UIView()
        label.backgroundColor = UIColor.systemPurple
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(userImage)
        addSubview(detailsLabel)
        addSubview(divider)
        
        userImage.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: (contentView.width / 2) - 50, paddingBottom: 0, paddingRight: 0, width: 100, height: 100)
        
        detailsLabel.anchor(top: userImage.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: contentView.width, height: 30)
        
        divider.anchor(top: detailsLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: contentView.width, height: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
