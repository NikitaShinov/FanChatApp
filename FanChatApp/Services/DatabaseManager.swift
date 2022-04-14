//
//  DatabaseManager.swift
//  FanChatApp
//
//  Created by max on 20.03.2022.
//

import Foundation
import FirebaseDatabase


public enum DatabaseError: Error {
    case failedToFetch
}

class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private init() {}
    
    private let database = Database.database().reference()
    
    static func safeEmail(with email: String) -> String {
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
//    public func insertUser(with user: User, completion: @escaping (Bool) -> Void ) {
//        database.child(user.safeEmail).setValue(["first_name" : user.firstName,
//                                                 "last_name": user.lastName,
//                                                 "favourite_team": user.preferredTeam],
//                                                withCompletionBlock: { [weak self] error, _ in
//            guard error == nil else {
//                print ("Failed to write to database")
//                completion(false)
//                return
//            }
//            
//            self?.database.child("users").observeSingleEvent(of: .value, with: { snapshot in
//                if var usersCollection = snapshot.value as? [[String: String]] {
//                    let newElement = [
//                        "name": user.firstName + " " + user.lastName,
//                        "team": user.preferredTeam,
//                        "email": user.safeEmail
//                    ]
//                    usersCollection.append(newElement)
//                    
//                    self?.database.child("users").setValue(usersCollection, withCompletionBlock: {
//                        error, _ in
//                        guard error == nil else {
//                            completion(false)
//                            return
//                        }
//                        completion(true)
//                    })
//                } else {
//                    let newCollection: [[String: String]] = [
//                        [
//                        "name": user.firstName + " " + user.lastName,
//                        "team": user.preferredTeam,
//                        "email": user.safeEmail
//                        ]
//                    ]
//                    self?.database.child("users").setValue(newCollection, withCompletionBlock: { error, _ in
//                        guard error == nil else {
//                            completion(false)
//                            return
//                        }
//                        completion(true)
//                    })
//                    
//                }
//            })
//            
//        })
//    }
    
    public func userExists(with email: String, completion: @escaping (Bool) -> Void) {
        
        let safeEmail = DatabaseManager.safeEmail(with: email)
        
        database.child(safeEmail).observeSingleEvent(of: .value, with: { snapshot in
            guard snapshot.value as? [String: Any] != nil else {
                completion(false)
                return
            }
            completion(true)
        })
    }
    
    public func getUsers(completion: @escaping (Result<[[String: String]], Error>) -> Void) {
        database.child("users").observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [[String: String]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            completion(.success(value))
        }
    }
    
    public func getDataFor(path: String, completion: @escaping (Result<Any, Error>) -> Void) {
        database.child("\(path)").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            completion(.success(value))
        })
    }
    
}
