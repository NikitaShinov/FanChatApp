//
//  FeedCellViewModel.swift
//  FanChatApp
//
//  Created by max on 23.03.2022.
//

import Foundation

protocol FeedCellViewModelProtocol {
    var articleName: String { get }
    var decription: String { get }
    var image: Data? { get }
    init (article: News)
}

class FeedCellViewModel: FeedCellViewModelProtocol {
    var articleName: String {
        news.title
    }
    
    var decription: String {
        news.shortdesc
    }
    
    var image: Data? {
        ImageManager.shared.fetchImageData(from: news.imgsrc)
    }
    
    private let news: News
    
    required init(article: News) {
        self.news = article
    }
    
    
}
