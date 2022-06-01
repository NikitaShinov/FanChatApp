//
//  MenuCellViewModel.swift
//  FanChatApp
//
//  Created by max on 17.05.2022.
//

import Foundation

struct MenuCellViewModel {
    
    let menuOption: MenuListController.MenuOptions
    
    var imageName: String {
        switch menuOption {
        case .news:
            return "newspaper"
        case .userFeed:
            return "eyes.inverse"
        case .users:
            return "person.2"
        case .results:
            return "timer.square"
        case .profile:
            return "person"
        case .shareApp:
            return "message"
            
        }
    }
    
    init(menuOption: MenuListController.MenuOptions) {
        self.menuOption = menuOption
    }
}
