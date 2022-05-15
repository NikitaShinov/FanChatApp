//
//  FeedTableViewCell.swift
//  FanChatApp
//
//  Created by max on 22.03.2022.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    
    var viewModel: FeedCellViewModelProtocol! {
        didSet {
            title.text = viewModel.articleName
            subtitle.text = viewModel.decription
            guard let image = viewModel.image else { return }
            newsImage.loadImage(urlString: image)
        }
    }

    static let identifier = "FeedCell"
    
    lazy var title: UILabel = {
        let title = UILabel()
        title.numberOfLines = 0
        title.textAlignment = .natural
        title.font = .systemFont(ofSize: 22, weight: .medium)
        return title
    }()

    lazy var subtitle: UILabel = {
        let subtitle = UILabel()
        subtitle.numberOfLines = 0
        subtitle.font = .systemFont(ofSize: 15, weight: .ultraLight)
        return subtitle
    }()

    lazy var newsImage: CustomImageView = {
        let image = CustomImageView()
        image.backgroundColor = .systemBackground
        image.layer.cornerRadius = 7
        image.layer.masksToBounds = true
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(newsImage)
        contentView.addSubview(subtitle)
        contentView.addSubview(title)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        title.frame = CGRect(x: 10,
                             y: 0,
                             width: contentView.frame.size.width - 170,
                             height: 70)

        subtitle.frame = CGRect(x: 10,
                                y: 70,
                                width: contentView.frame.size.width - 170,
                                height: contentView.frame.size.height / 2)

        newsImage.frame = CGRect(x: contentView.frame.size.width - 150,
                                 y: 5,
                                 width: 130,
                                 height: contentView.frame.size.height - 50)

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        title.text = nil
        subtitle.text = nil
        newsImage.image = nil
    }
}

