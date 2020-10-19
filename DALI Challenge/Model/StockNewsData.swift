//
//  StockNewsData.swift
//  Stock Bento
//
//  Created by Barkin Cavdaroglu on 10/05/20.
//

import Foundation


//MARK: -Custom Iterator for News Array
struct TickerNewsIterator: IteratorProtocol {
    private var tickerNews: [NewsItem]
    
    init(tickerNews: [NewsItem]) {
        self.tickerNews = tickerNews
    }
    
    mutating func next() -> NewsItem? {
        defer {
            if !tickerNews.isEmpty {
                tickerNews.removeFirst()
            }
        }
        return tickerNews.first
    }
}

extension TickerNews: Sequence {
    func makeIterator() -> TickerNewsIterator {
        return TickerNewsIterator(tickerNews: data)
    }
}

//MARK: -Object Models for News returned from API call to Stocknews
struct TickerNews: Decodable {
    let data: [NewsItem]
}

struct NewsItem: Decodable, Identifiable {
    let category: String
    let datetime: Int
    let headline: String
    let id: Int
    let image: String
    let related: String
    let source: String
    let summary: String
    let url: String
}

struct NewsCorpus: Decodable, Identifiable {
    var id = UUID()
    var corpus: String
}

struct CompanyNewsSentiment: Decodable {
    let buzz: Buzz
    let companyNewsScore: Double
    let sectorAverageBullishPercent: Double
    let sectorAverageNewsScore: Double
    let sentiment: sentiment
    let symbol: String
    
}

struct Buzz: Decodable {
    let articlesInLastWeek: Int
    let buzz: Double
    let weeklyAverage: Double
}

struct sentiment: Decodable {
    let bearishPercent: Double
    let bullishPercent: Double
}
