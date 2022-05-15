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
    var image: String? { get }
    init (article: News)
}

class FeedCellViewModel: FeedCellViewModelProtocol {
    var articleName: String {
        news.title
    }
    
    var decription: String {
        news.shortdesc
    }
    
    var image: String? {
        news.imgsrc.absoluteString
//        ImageManager.shared.fetchImageData(from: news.imgsrc)
    }
    
    private let news: News
    
    required init(article: News) {
        self.news = article
    }
    
    
}
