//
//  TeamCell.swift
//  FanChatApp
//
//  Created by max on 16.03.2022.
//

import UIKit
import DropDown

class TeamCell: DropDownCell {
    
    @IBOutlet var teamImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        teamImage.contentMode = .scaleAspectFit
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
