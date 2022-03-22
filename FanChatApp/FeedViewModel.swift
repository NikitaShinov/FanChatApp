//
//  FeedViewModel.swift
//  FanChatApp
//
//  Created by max on 22.03.2022.
//

import Foundation

protocol FeedViewModelProtocol {
    var news: [News] { get }
    func getNews()
    func refreshNews()
    func numberOfArticles() -> Int
}

class FeedViewModel: FeedViewModelProtocol {
    
    var news: [News] = []
    
    func getNews() {
        NetworkManager.shared.getFeed { [weak self] result in
            switch result {
            case .success(let data):
                guard let receivedData = data else { return }
                self?.news = receivedData
                
            case .failure(let error):
                print (error.localizedDescription)
                
            }
        }
    }
    
    func refreshNews() {
        NetworkManager.shared.getFeed { [weak self] result in
            switch result {
            case .success(let data):
                guard let receivedData = data else { return }
                self?.news = receivedData
                do {
                    let encoder = JSONEncoder()
                    let encodedData = try encoder.encode(self?.news)
                    UserDefaults.standard.set(encodedData, forKey: "news")
                } catch {
                    print ("error while encoding")
                }
            case .failure(let error):
                print (error.localizedDescription)
            }
        }
    }
    
    func numberOfArticles() -> Int {
        news.count
    }
    
    
}
