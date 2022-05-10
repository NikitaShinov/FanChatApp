//
//  UserCellViewModel.swift
//  FanChatApp
//
//  Created by max on 10.05.2022.
//

import Foundation

protocol UserCellViewModelProtocol {
    init (user: User)
}

class UserCellViewModel: UserCellViewModelProtocol {
    
    private let receivedUser: User
    
    required init(user: User) {
        self.receivedUser = user
    }
    
    
}
