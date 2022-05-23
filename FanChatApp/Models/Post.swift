//
//  Post.swift
//  FanChatApp
//
//  Created by max on 13.04.2022.
//

import Foundation


struct Post {

    let user: String
    let caption: String
    let creationDate: Date
    
    init(user: String, dictionary: [String: Any]) {
        self.user = user
        self.caption = dictionary["caption"] as? String ?? ""
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
}
