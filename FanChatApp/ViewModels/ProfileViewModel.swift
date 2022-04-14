//
//  ProfileViewModel.swift
//  FanChatApp
//
//  Created by max on 30.03.2022.
//

import Foundation
import Firebase

protocol ProfileViewModelProtocol {
    
    var profileName: String { get }
    var profileImage: Data? { get }
    func getUrl()

}

class ProfileViewModel: ProfileViewModelProtocol {
    
    private var imageUrl: URL?
    
    func getUrl() {

        let reference = Storage.storage().reference().child("profile_avatars")
        reference.downloadURL { url, error in
            guard error == nil, let url = url else {
                print ("error getting profile avatar url")
                return
            }
            self.imageUrl = url
        }
    }
    
    var profileName: String {
        UserDefaults.standard.value(forKey: "name") as? String ?? "No name"
    }
    
    
    var profileImage: Data? {
        ImageManager.shared.fetchImageData(from: imageUrl)
    }
    
}
