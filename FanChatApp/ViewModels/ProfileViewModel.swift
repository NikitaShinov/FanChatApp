//
//  ProfileViewModel.swift
//  FanChatApp
//
//  Created by max on 30.03.2022.
//

import Foundation
import Firebase

protocol ProfileViewModelProtocol {
    
//    var profileName: String { get }
//    var profileImage: String { get }
    var userName: String? { get }
    var userPicUrl: String? { get }
//    func getCurrentUser()
    func getUserName(completion: @escaping(String) -> Void)
    func getUserPic(completion: @escaping(String) -> Void)

}

class ProfileViewModel: ProfileViewModelProtocol {
    var userName: String?
    
    var userPicUrl: String?
    
    
    func getUserName(completion: @escaping (String) -> Void) {
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        print (currentUser)
        Database.fetchUserWithUID(uid: currentUser) { user in
            self.userName = user.username
        }

    }
    
    func getUserPic(completion: @escaping (String) -> Void) {
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        print (currentUser)
        Database.fetchUserWithUID(uid: currentUser) { user in
            
        }

    }
//    func getCurrentUser() {
//        guard let currentUser = Auth.auth().currentUser?.uid else { return }
//        print (currentUser)
//        Database.fetchUserWithUID(uid: currentUser) { user in
//            self.user = user
//        }
//
//    }
//
//    var profileName: String {
//        user?.username ?? "NO DATA RECIEVED"
//    }
//
//    var profileImage: String {
//        user?.profileImageUrl ?? "NO DATA RECEIVED"
//    }
//
    
//    var user: User?
//    func getUserName(completion: @escaping() -> Void) {
//        guard let currentUser = Auth.auth().currentUser?.uid else { return }
//
//        print (currentUser)
//
//        Database.fetchUserWithUID(uid: currentUser) { fetchedUser in
//            self.user = fetchedUser
//        }
//      guard let userName = user?.username else { return }
//       print ("Fetched username: \(userName)")
//        completion()
//    }
    
    
//    var fetchedUser: User?
    
//    func getUserName() {
        
        
//        Database.fetchUserWithUID(uid: currentUser) { user in
//            self.user = user
//            print ("FETCHING FOR PROFILE :\(user.username)")
//        }

//        let reference = Storage.storage().reference().child("profile_avatars")
//        reference.downloadURL { url, error in
//            guard error == nil, let url = url else {
//                print ("error getting profile avatar url")
//                return
//            }
//            self.imageUrl = url
//        }
        
//        let reference = Database.database().reference().child("users")
//        reference.observeSingleEvent(of: .value) { snapshot in
//            guard let dictionaries = snapshot.value as? [String: Any] else { return }
//            dictionaries.forEach { key, value in
//                if key == currentUser {
//                    guard let userDictionary = value as? [String: Any] else { return }
//                    self.fetchedUser = User(uid: key, dictionary: userDictionary)
//                    print (self.fetchedUser)
//                } else {
//                    return
//                }
//            }
//
//        }
//    }
    
//    var profileName: String {
//        user?.username ?? "User is absent"
//    }
//
//
//    var profileImage: String {
//        user?.profileImageUrl ?? ""
//    }
    
}
