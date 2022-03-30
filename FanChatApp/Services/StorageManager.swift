//
//  StorageManager.swift
//  FanChatApp
//
//  Created by max on 20.03.2022.
//

import Foundation
import FirebaseStorage
import UIKit

class StorageManager {
    
    static let shared = StorageManager()
    
    private init() {}
    
    private var storage = Storage.storage().reference()
    
    public enum StorageError: Error {
        case failedToUpload
        case failedToGetDownloadURL
    }
    
    public func pictureUpload(with data: Data,
                              fileName: String,
                              completion: @escaping (Result<String, Error>) -> Void) {
        storage.child("images/\(fileName)").putData(data, metadata: nil, completion: { metadata, error in
            guard error == nil else {
                print ("Failed to upload data to firebase")
                completion(.failure(StorageError.failedToUpload))
                return
            }
            
            self.storage.child("images/\(fileName)").downloadURL { url, error in
                guard let url = url else {
                    print ("Failed to get downlod URL")
                    completion(.failure(StorageError.failedToGetDownloadURL))
                    return
                }
                let urlString = url.absoluteString
                print ("download url returned: \(urlString)")
                completion(.success(urlString))
            }
        })
    }
    
    public func downloadURL(with path: String, completion: @escaping (Result<URL?, Error>) -> Void) {
        let reference = storage.child(path)
        
        reference.downloadURL { url, error in
            guard let url = url, error == nil else {
                completion(.failure(StorageError.failedToGetDownloadURL))
                return
            }
            completion(.success(url))
        }
    }
}
