//
//  NetworkManager.swift
//  FanChatApp
//
//  Created by max on 17.03.2022.
//

import Foundation

class NetworkManager {
    
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
        
        guard let url = URL(string: "https://skysportsapi.herokuapp.com/sky/football/getteamnews/arsenal/v1.0/") else {
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
