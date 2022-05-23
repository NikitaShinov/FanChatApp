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
    func getUserPosts(completion: @escaping () -> Void)
//    func getFeed(completion: @escaping () -> Void)
    func numberOfPosts() -> Int
}

class UserFeedViewModel: UserFeedProtocol {
    
    var feed: [Post] = []
    
    func getUserPosts(completion: @escaping () -> Void) {

        var keys: [String] = []
        Database.database().reference().child("posts").observeSingleEvent(of: .value) { snapshot in
            guard let userIDs = snapshot.value as? [String: Any] else { return }
            print ("Nunber of uids - \(userIDs.count)")
            userIDs.forEach { key, value in
                keys.append(key)
                print (keys.count)
            }
            
            keys.forEach { keyId in
                print ("GETTING KEYS")
                print (keyId)
                Database.database().reference().child("posts").child(keyId).observeSingleEvent(of: .value) { snapshot in
                    guard let dictionaries = snapshot.value as? [String:Any] else { return }
                    print ("Number of posts inside uid: \(dictionaries.count)")
                    dictionaries.forEach { key, value in
                        guard let dictionary = value as? [String: Any] else { return }
                        let post = Post(dictionary: dictionary)
                        self.feed.append(post)
                    }
                }
            }
        }
    }
    
    func numberOfPosts() -> Int {
        feed.count
    }
    
    
}
