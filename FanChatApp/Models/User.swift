//
//  UserProfile.swift
//  FanChatApp
//
//  Created by max on 08.02.2022.
//

import Foundation

struct User {
    
    let uid: String
    let username: String
    let favouriteTeam: String
    let profileImageUrl: String
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.username = dictionary["username"] as? String ?? ""
        self.favouriteTeam = dictionary["favourite_team"] as? String ?? ""
        self.profileImageUrl = dictionary["profile_image"] as? String ?? ""
    }
}
