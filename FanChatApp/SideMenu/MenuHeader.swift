//
//  MenuHeader.swift
//  FanChatApp
//
//  Created by max on 17.05.2022.
//

import UIKit

class MenuHeader: UITableViewHeaderFooterView {
    
    let profileName: UILabel = {
        let name = UILabel()
        name.font = UIFont.boldSystemFont(ofSize: 20)
        name.textColor = UIColor.white
        name.textAlignment = .left
        return name
    }()
    
    let profileImage: CustomImageView = {
        let image = CustomImageView()
        image.layer.cornerRadius = 30
        image.contentMode = .scaleAspectFill
        image.layer.masksToBounds = true
        image.layer.borderWidth = 2
        image.layer.borderColor = UIColor.lightGreen().cgColor
        return image
    }()
    static let identifier = "header"
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(profileName)
        contentView.addSubview(profileImage)
        contentView.backgroundColor = .purple
        
        profileImage.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 60, height: 60)

        profileName.anchor(top: topAnchor, left: profileImage.rightAnchor, bottom: nil, right: nil, paddingTop: 40, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 150, height: 20)
    }
    
}
