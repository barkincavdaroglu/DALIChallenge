//
//  NewsItemVM.swift
//  Stock Bento
//
//  Created by Barkin Cavdaroglu on 10/03/20.
//

import Foundation


struct NewsItemVM {
    let news: NewsItem
    
    var category: String {
        return self.news.category
    }
    
    var datetime: Int {
        return self.news.datetime
    }
    
    var headline: String {
        return self.news.headline
    }
    
    var id: Int {
        return self.news.id
    }
    
    var image: String {
        return self.news.image
    }
    
    var related: String {
        return self.news.related
    }
    
    var source: String {
        return self.news.source
    }
    
    var summary: String {
        return self.news.summary
    }
    
    var url: String {
        return self.news.url
    }
    
}

struct News: Decodable {
    let id: Int
    let category: String
    let datetime: Int
    let headline: String
    let image: String
    let related: String
    let source: String
    let summary: String
    let url: String
}
