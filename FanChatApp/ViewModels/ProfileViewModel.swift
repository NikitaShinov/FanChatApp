//
//  ProfileViewModel.swift
//  FanChatApp
//
//  Created by max on 30.03.2022.
//

import Foundation

protocol ProfileViewModelProtocol {
    
    var profileName: String { get }
    var profileImage: Data? { get }
    func getUrl()
    init (profile: User, url: URL)
}

class ProfileViewModel: ProfileViewModelProtocol {
    
    required init(profile: User, url: URL) {
        self.user = profile
        self.imageUrl = url
    }
    
    private let user: User
    
    private var imageUrl: URL
    
    func getUrl() {
        StorageManager.shared.downloadURL(with: user.profilePictureFileName) { result in
            switch result {
            case .success(let url):
                guard let url = url else { return }
                self.imageUrl = url
            case .failure(let error):
                print ("Failed to catch image url: \(error)")
            }
        }
    }
    
    var profileName: String {
        UserDefaults.standard.value(forKey: "name") as? String ?? "No name"
    }
    
    
    var profileImage: Data? {
        ImageManager.shared.fetchImageData(from: imageUrl)
    }
    
}
