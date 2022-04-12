//
//  NetworkManager.swift
//  FanChatApp
//
//  Created by max on 17.03.2022.
//

import Foundation
import Firebase

class NetworkManager {
    
    var team: String?
    
    static let shared = NetworkManager()
    
    private init () {}
    
    public func getResults(completion: @escaping (Result<DataClass?, Error>) -> Void) {
        
        guard let url = URL(string: "https://api-football-standings.azharimm.site/leagues/eng.1/standings?season=2021&sort=asc") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            
            guard let data = data else {
                return
            }
            
            let decodedData = try? JSONDecoder().decode(JSONResponse.self, from: data)
            
            if let data = decodedData {
                DispatchQueue.main.async {
                    completion(.success(data.data))
                }
            }
        } .resume()
    }
    
    public func getFeed(completion: @escaping (Result<[News]?, Error>) -> Void) {
        
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        
        Database.database().reference().child("users").child(userUID).getData { error, snapshot in
            guard error == nil else {
                return
            }
            
            print ("getting snapshot")
            
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            self.team = dictionary["favourite_team"] as? String
            
            guard let searchedTeam = self.team?.lowercased() else { return }
            
            guard let url = URL(string: "https://skysportsapi.herokuapp.com/sky/football/getteamnews/\(searchedTeam)/v1.0/") else {
                return
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                }
                
                guard let data = data else {
                    return
                }
                
                let decodedData = try? JSONDecoder().decode([News].self, from: data)
                
                if let data = decodedData {
                    DispatchQueue.main.async {
                        completion(.success(data))
                    }
                }
            } .resume()
        }
    }
}
