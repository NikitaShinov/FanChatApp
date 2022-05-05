//
//  ProfileViewModel.swift
//  FanChatApp
//
//  Created by max on 30.03.2022.
//

import Foundation
import Firebase

protocol ProfileViewModelProtocol {

    var user: User? { get }
    func getUser(completion: @escaping(User) -> Void)

}

class ProfileViewModel: ProfileViewModelProtocol {

    var user: User?
    
    func getUser(completion: @escaping (User) -> Void) {
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        print (currentUser)
        Database.fetchUserWithUID(uid: currentUser) { user in
            self.user = user
            completion(user)
        }
        
    }
    
}
