//
//  UserProfile.swift
//  FanChatApp
//
//  Created by max on 08.02.2022.
//

import Foundation

struct User {
    
    let firstName: String
    let lastName: String
    let emailAddress: String
    let preferredTeam: String
    
    var safeEmail: String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}
