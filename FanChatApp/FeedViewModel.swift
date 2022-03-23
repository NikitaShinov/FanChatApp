//
//  FeedViewModel.swift
//  FanChatApp
//
//  Created by max on 22.03.2022.
//

import Foundation

protocol FeedViewModelProtocol {
    var news: [News] { get }
    func getNews(completion: @escaping() -> Void)
    func refreshNews()
    func numberOfArticles() -> Int
    func cellViewModel(at indexPath: IndexPath) -> FeedCellViewModelProtocol
}

class FeedViewModel: FeedViewModelProtocol {
    
    var news: [News] = []
    
    func getNews(completion: @escaping() -> Void) {
        NetworkManager.shared.getFeed { [weak self] result in
            switch result {
            case .success(let data):
                guard let receivedData = data else { return }
                self?.news = receivedData
                completion()
            case .failure(let error):
                print (error.localizedDescription)
                completion()
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
    
    func cellViewModel(at indexPath: IndexPath) -> FeedCellViewModelProtocol {
        let newsItem = news[indexPath.row]
        return FeedCellViewModel(article: newsItem)
    }
    
    
}
