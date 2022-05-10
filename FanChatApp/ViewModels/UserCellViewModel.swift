//
//  UserCellViewModel.swift
//  FanChatApp
//
//  Created by max on 10.05.2022.
//

import Foundation

protocol UserCellViewModelProtocol {
    init (user: User)
    var userName: String { get }
    var userImage: String? { get }
    var userSupportedTeam: String { get }
    
}

class UserCellViewModel: UserCellViewModelProtocol {
    
    
    var userName: String {
        receivedUser.username
    }
    
    var userImage: String? {
        receivedUser.profileImageUrl
    }
    
    var userSupportedTeam: String {
        receivedUser.favouriteTeam
    }
    
    private let receivedUser: User
    
    required init(user: User) {
        self.receivedUser = user
    }
    
    
}
