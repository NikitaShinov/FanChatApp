//
//  UserFeedViewModel.swift
//  FanChatApp
//
//  Created by max on 23.05.2022.
//

import Foundation
import Firebase

protocol UserFeedProtocol: AnyObject {
    var feed: [Post] { get set }
    func getFeed(completion: @escaping () -> Void)
    func numberOfPosts() -> Int
}

class UserFeedViewModel: UserFeedProtocol {
    var feed: [Post] = []
    
    func getFeed(completion: @escaping () -> Void) {
        Database.database().reference().child("posts").observeSingleEvent(of: .value) { snapshot in
            guard let dictionaries = snapshot.value as? [String:Any] else { return }
            dictionaries.forEach { key, value in
                guard let userDictionary = value as? [String: Any] else { return }
                let post = Post(user: key, dictionary: userDictionary)
                self.feed.append(post)
                print (self.feed[0].caption)
                completion()
            }
        }
    }
    
    func numberOfPosts() -> Int {
        feed.count
    }
    
    
}
