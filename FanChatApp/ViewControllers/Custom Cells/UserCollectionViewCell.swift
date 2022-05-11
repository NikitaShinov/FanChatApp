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
            
        }
    }
    
    static let identifier = "UserCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemRed
        contentView.addSubview(userImage)
        contentView.addSubview(userName)
        contentView.addSubview(userTeam)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var userImage: CustomImageView = {
        let image = CustomImageView()
        return image
    }()
    
    lazy var userName: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var userTeam: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        userName.frame = CGRect(x: 5,
                                y: contentView.frame.size.height-50,
                                width: contentView.frame.size.width-10,
                                height: 50)
        
        userImage.frame = CGRect(x: 5,
                                 y: 0,
                                 width: contentView.frame.size.width-10,
                                 height: contentView.frame.size.height-50)
        
    }
}
