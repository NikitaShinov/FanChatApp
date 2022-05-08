//
//  UsersViewModel.swift
//  FanChatApp
//
//  Created by max on 08.05.2022.
//

import Foundation
import Firebase

protocol UsersViewModelProtocol {
    var users: [User] { get }
    func getUsers(completion: @escaping() -> Void)
}

class UsersViewModel: UsersViewModelProtocol {
    
    var users: [User] = []
    
    func getUsers(completion: @escaping () -> Void) {
        let reference = Database.database().reference().child("users")
        
        reference.observeSingleEvent(of: .value) { snapshot in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            dictionaries.forEach { key, value in
                if key == Auth.auth().currentUser?.uid {
                    print ("FOUND MYSELF")
                    return
                }
                
                guard let userDictionary = value as? [String: Any] else { return }
                let user = User(uid: key, dictionary: userDictionary)
                self.users.append(user)
            }
        }
    }
    
}
