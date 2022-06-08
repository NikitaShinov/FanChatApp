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
    func searchUsers(with name: String, completion: @escaping () -> Void)
    func userCellViewModel(at indexPath: IndexPath) -> UserCellViewModelProtocol
    func numberOfUsers() -> Int
}

class UsersViewModel: UsersViewModelProtocol {
    
    var users: [User] = []
    
    private let reference = Database.database().reference().child("users")
    
    func getUsers(completion: @escaping () -> Void) {
        
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
                completion()
            }
        }
    }
    
    func searchUsers(with name: String, completion: @escaping () -> Void) {
        
        self.users.removeAll()
        reference.observeSingleEvent(of: .value) { snapshot in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            dictionaries.forEach { key, value in
                if key == Auth.auth().currentUser?.uid {
                    print ("FOUND MYSELF WHILE SEARCHING")
                    return
                }
                guard let userDictionary = value as? [String: Any] else { return }
                let user = User(uid: key, dictionary: userDictionary)
                if user.username.contains(name) {
                    self.users.append(user)
                }
                completion()
            }
        }
    }
    
    // РЕАЛИЗОВАТЬ ПОИСК ПО ЮЗЕРАМ
    
    func userCellViewModel(at indexPath: IndexPath) -> UserCellViewModelProtocol {
        let userItem = users[indexPath.item]
        return UserCellViewModel(user: userItem)
    }
    
    func numberOfUsers() -> Int {
        users.count
    }
    
}
