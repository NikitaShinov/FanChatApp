//
//  UserCollectionViewCell.swift
//  FanChatApp
//
//  Created by max on 10.05.2022.
//

import Foundation
import UIKit

class UserCollectionViewCell: UICollectionViewCell {
    
    var viewModel: UserCellViewModelProtocol! {
        didSet {
            userName.text = viewModel.userName
            guard let image = viewModel.userImage else { return }
            userImage.loadImage(urlString: image)
            userTeam.text = viewModel.userSupportedTeam
        }
    }
    
    static let identifier = "UserCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(userImage)
        contentView.addSubview(userName)
        contentView.addSubview(userTeam)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var userImage: CustomImageView = {
        let image = CustomImageView()
        image.clipsToBounds = true
        image.layer.borderWidth = 2
        image.layer.borderColor = CGColor.init(_colorLiteralRed: 105, green: 105, blue: 105, alpha: 0)
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    lazy var userName: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = label.font.withSize(14)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var userTeam: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .lightGray
        label.font = label.font.withSize(10)
        label.numberOfLines = 0
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        userImage.frame = CGRect(x: contentView.center.x - (contentView.width / 4),
                                 y: 0,
                                 width: contentView.frame.size.width / 2,
                                 height: contentView.frame.size.height / 2)
        
        userImage.layer.cornerRadius = userImage.frame.size.height / 2
        
        userName.frame = CGRect(x: 5,
                                y: userImage.bottom + 1,
                                width: contentView.frame.size.width / 1.1,
                                height: 25)
        
        userTeam.frame = CGRect(x: 5,
                                y: userName.bottom + 1,
                                width: contentView.frame.size.width / 1.1,
                                height: 25)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userName.text = nil
        userTeam.text = nil
        userImage.image = nil
    }
}
