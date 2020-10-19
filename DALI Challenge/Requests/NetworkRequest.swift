//
//  NetworkRequest.swift
//  Stock Bento
//
//  Created by Barkin Cavdaroglu on 10/03/20.
//

import Foundation
import Alamofire
import NaturalLanguage

class NetworkRequest: ObservableObject {
    var symbolsArray = [String]()
    var namesArray = [String]()
    var newscorpus = NewsCorpus(corpus: "")
    
    //MARK: -Get news of the market
    func fetchMarketNews(completion: @escaping (([NewsItem]?) -> Void)) {
        _ = AF.request("https://finnhub.io/api/v1/news?category=general&token=bu5j1sn48v6qku33vlig")
                .responseDecodable(of: [NewsItem].self) { (response) in
                    guard let data = response.value else { return }
                    var marketNews = [NewsItem]()
                    for news in data {
                        let newsItem = NewsItem(category: news.category, datetime: news.datetime, headline: news.headline, id: news.id, image: news.image, related: news.related, source: news.source, summary: news.summary, url: news.url)
                        marketNews.append(newsItem)
                    }
                    for news in marketNews {
                        self.newscorpus.corpus += news.summary
                    }
                    completion(marketNews)
                }
    }
    
    func marketSentiment(completion: @escaping ((String?) -> Void)) {
        let tagger = NLTagger(tagSchemes: [.sentimentScore])
        tagger.string = self.newscorpus.corpus
        let (sentiment, _) = tagger.tag(at: self.newscorpus.corpus.startIndex, unit: .paragraph, scheme: .sentimentScore)
        let score = (sentiment?.rawValue ?? "0")
        completion(score)
    }
    
    func fetchIntradayPrices(ticker: String, completion: @escaping (([Intraday]?) -> Void)) {
        _ = AF.request("https://cloud.iexapis.com/stable/stock/"+ticker+"/intraday-prices?token=pk_67f3433c071f4436a63a849f80c418bf&chartInterval=15")
            .responseDecodable(of: [Intraday].self) { (response) in
                guard let data = response.value else { return }
                let intradayPrices = data
                completion(intradayPrices)
            }
    }
    
    func companySentiment(ticker: String, completion: @escaping ((CompanyNewsSentiment?) -> Void)) {
        _ = AF.request("https://finnhub.io/api/v1/news-sentiment?symbol="+ticker+"&token=bu5j1sn48v6qku33vlig")
            .responseDecodable(of: CompanyNewsSentiment.self) { (response) in
                guard let data = response.value else { return }
                completion(data)
            }
    }
    
    //MARK: - Get Data from IEXCloud
    func fetchDataIEX(completion: @escaping (([Quote]?) -> Void)) {
        var stocks = [Quote]()
        for each in self.symbolsArray {
            _ = AF.request("https://cloud.iexapis.com/stable/stock/"+each+"/quote?token=pk_67f3433c071f4436a63a849f80c418bf").validate()
                .responseDecodable(of: Quote.self) { (response) in
                    guard let data = response.value else { return }
                    let currentQuote = Quote(symbol: data.symbol, companyName: data.companyName, high: data.high, low: data.low, latestPrice: data.latestPrice, latestTime: data.latestTime, previousClose: data.previousClose, change: data.change, changePercent: data.changePercent, week52High: data.week52High, week52Low: data.week52Low)
                    stocks.append(currentQuote)
                    completion(stocks)
                }
        }
    }
    
    
    //MARK: - Get Popular Symbols from Yahoo Finance
    func getPopularTickers(completion: @escaping () -> Void) {
        let url = URL(string: "https://finance.yahoo.com/trending-tickers/")!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                print("error with the data")
                return
            }
            
            guard let htmlString = String(data: data, encoding: .utf8) else {
                print("error with html string")
                return
            }
            
            let leftSideString = """
        <tbody data-reactid="54">
        """
            
            let rightSideString = """
        </tbody>
        """
            
            guard
                let leftSideRange = htmlString.range(of: leftSideString)
            else {
                print("error with the left range")
                return
            }
            guard
                let rightSideRange = htmlString.range(of: rightSideString)
            else {
                print("error with the right range")
                return
            }
            
            let rangeOfTheData = leftSideRange.upperBound..<rightSideRange.lowerBound
            let tableOfTickers = htmlString[rangeOfTheData]
            let abaa = Array(tableOfTickers)
            var line = ""
            var lines = [""]
            var wearein = false
            for (index, character) in tableOfTickers.enumerated() {
                if abaa[index] == "<" && abaa[index+1] == "t" && abaa[index+2] == "r" && abaa[index+3] == " " {
                    wearein = true
                }
                
                if abaa[index] == ">" {
                    wearein = false
                    lines.append(line)
                    line = ""
                }
                
                if wearein {
                    line += String(character)
                }
            }
            var newLines = [""]
            
            for lineIndex in 0..<lines.count {
                if lines[lineIndex] != "" {
                    newLines.append(lines[lineIndex])
                }
            }
            
            var wearin2 = false
            var symbolz = ""
            var symbolls = [""]
            for each in newLines {
                let aki = Array(each)
                for (index, _) in each.enumerated() {
                    if aki[index] == "-" && aki[index+1] == "r" && aki[index+2] == "o" && aki[index+3] == "w" {
                        wearin2 = true
                    }
                    
                    if aki[index] == " " && aki[index+1] == "B" && aki[index+2] == "g" && aki[index+3] == "c" {
                        wearin2 = false
                        if symbolz.count > 0 {
                            symbolls.append(symbolz[0..<symbolz.count-4])
                        }
                        symbolz = ""
                    }
                    
                    if wearin2 {
                        symbolz += String(aki[index+4])
                    }
                }
            }
                        
            self.symbolsArray = symbolls
            
            completion()
            
        }
        task.resume()
        
    }
}

extension String {
    subscript(_ range: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
        let end = index(start, offsetBy: min(self.count - range.lowerBound,
                                             range.upperBound - range.lowerBound))
        return String(self[start..<end])
    }

    subscript(_ range: CountablePartialRangeFrom<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
         return String(self[start...])
    }
}

