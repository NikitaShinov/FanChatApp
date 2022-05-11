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
//            guard let image = viewModel.userImage else { return }
//            userImage.loadImage(urlString: image)
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
        image.backgroundColor = .red
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    lazy var userName: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = .yellow
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userName.text = nil
        userImage.image = nil
    }
}
