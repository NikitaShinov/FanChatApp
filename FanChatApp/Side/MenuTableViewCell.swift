//
//  MenuTableViewCell.swift
//  FanChatApp
//
//  Created by max on 17.05.2022.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    
    var viewModel: MenuCellViewModel? {
        didSet {
            configure()
        }
    }
    
    static let cellId = "cellId"
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        guard let viewModel = viewModel else { return }
        imageView?.image = UIImage(systemName: viewModel.imageName)?.withTintColor(UIColor.lightGreen(),
                                                                                   renderingMode: .alwaysOriginal)
        imageView?.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 40, height: 30)
        
        textLabel?.anchor(top: topAnchor, left: imageView?.rightAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 100, height: 30)
        textLabel?.text = viewModel.menuOption.rawValue
        textLabel?.textColor = .white
        imageView?.tintColor = .white
        backgroundColor = .purple
        contentView.backgroundColor = .purple
    }
}
