//
//  TeamStandingCell.swift
//  FanChatApp
//
//  Created by max on 16.05.2022.
//

import Foundation
import UIKit

class TeamStandingCell: UITableViewCell {
        
    static let identifier = "StandingCell"
    
    lazy var teamRank: UILabel = {
        let title = UILabel()
        title.font = .boldSystemFont(ofSize: 14)
        title.backgroundColor = .yellow
        title.textAlignment = .center
        return title
    }()
    
    lazy var teamName: UILabel = {
        let title = UILabel()
        title.numberOfLines = 0
        title.textAlignment = .center
        title.textAlignment = .left
        title.backgroundColor = .cyan
        title.font = .systemFont(ofSize: 14, weight: .medium)
        return title
    }()

    lazy var teamSummary: UILabel = {
        let summary = UILabel()
        summary.numberOfLines = 0
        summary.backgroundColor = .red
        summary.font = .systemFont(ofSize: 12)
        return summary
    }()

    lazy var teamImage: CustomImageView = {
        let image = CustomImageView()
        image.backgroundColor = .systemBackground
        image.layer.cornerRadius = 5
        image.layer.masksToBounds = true
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(teamRank)
        contentView.addSubview(teamName)
        contentView.addSubview(teamSummary)
        contentView.addSubview(teamImage)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        teamRank.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        
        teamImage.anchor(top: topAnchor, left: teamRank.rightAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 30, paddingBottom: 0, paddingRight: 0, width: 60, height: 60)
        
        teamName.anchor(top: topAnchor, left: teamImage.rightAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 25, paddingBottom: 0, paddingRight: 0, width: contentView.width / 2, height: 30)
        
        teamSummary.anchor(top: teamName.bottomAnchor, left: teamImage.rightAnchor, bottom: nil, right: nil, paddingTop: 2, paddingLeft: 25, paddingBottom: 0, paddingRight: 0, width: contentView.width / 2, height: 30)
        


    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        teamRank.text = nil
        teamName.text = nil
        teamSummary.text = nil
        teamImage.image = nil
    }
}
