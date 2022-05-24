//
//  Post.swift
//  FanChatApp
//
//  Created by max on 13.04.2022.
//

import Foundation


struct Post {
    
    var id: String?
    let imageUrl: String
    let userName: String
    let caption: String
    let creationDate: Date
    
    init(dictionary: [String: Any]) {
        self.userName = dictionary["username"] as? String ?? ""
        self.imageUrl = dictionary["image_URL"] as? String ?? ""
        self.caption = dictionary["post_text"] as? String ?? ""
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
}
