//
//  UserDetailsViewModel.swift
//  FanChatApp
//
//  Created by max on 25.05.2022.
//

import Foundation
import Firebase

protocol UserDetailsViewModelProtocol: AnyObject {
    var userPosts: [Post] { get }
    func numberOfItems() -> Int
    func fetchUserPosts(user: String, completion: @escaping () -> Void)
}

class UserDetailsViewModel: UserDetailsViewModelProtocol {
    
    var userPosts: [Post] = []
    
    func fetchUserPosts(user: String, completion: @escaping () -> Void) {
        Database.database().reference().child("posts").child(user).observeSingleEvent(of: .value) { snapshot in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            print ("NUMBER OF USER'S POSTS - \(dictionaries.count)")
            dictionaries.forEach { key, value in
                guard let dictionary = value as? [String: Any] else { return }
                let userPost = Post(dictionary: dictionary)
                self.userPosts.append(userPost)
                completion()
            }
        }
    }
    
    func numberOfItems() -> Int {
        userPosts.count
    }
    
    

}
