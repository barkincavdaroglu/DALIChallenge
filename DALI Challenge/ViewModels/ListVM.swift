//
//  ListVM.swift
//  Stock Bento
//
//  Created by Barkin Cavdaroglu on 10/04/20.
//

import Foundation
import SwiftUI

class ListVM: ObservableObject {
    var networkReq = NetworkRequest()
    @Published var marketSentiment: String = "0"
    @Published var stocks: [StockItemVM] = [StockItemVM]()
    @Published var news: [NewsItemVM] = [NewsItemVM]()
    @Published var intradayPrices: [Intraday] = [Intraday]()
    @Published var IntradayPrices: [Double] = [Double]()
    @Published var companySentiment: [CompanyNewsSentiment] = [CompanyNewsSentiment]()
    
    func load() {
        fetchStocks()
        fetchGeneralNews()
    }
    
    private func fetchStocks() {
        self.networkReq.getPopularTickers { () -> () in
            self.networkReq.fetchDataIEX { stocks in
                if let stocks = stocks {
                    DispatchQueue.main.async {
                        self.stocks = stocks.map(StockItemVM.init)
                    }
                }
            }
        }
    }
    
    func fetchIntradayPrices(ticker: String, completion: @escaping () -> Void) {
        self.networkReq.fetchIntradayPrices(ticker: ticker) { intradayPrices in
            if let intradayPrices = intradayPrices {
                    self.intradayPrices = intradayPrices
                    self.pricesArray(intradayPrices: self.intradayPrices)
                    completion()
            }
        }
    }
    
    func companySentiments(ticker: String, completion: @escaping () -> Void) {
        self.networkReq.companySentiment(ticker: ticker) { sentiments in
            if let sentiments = sentiments {
                self.companySentiment = [sentiments]
                completion()
            }
        }
    }
    
    //Used enumerating for taking the average of the previous and the next of current average if null, change later
    func pricesArray(intradayPrices: [Intraday]) {
        for element in intradayPrices {
            if element.average == nil {
                //let previous = intradayPrices[index-1].average ?? 0.0
                //let next = intradayPrices[index+1].average ?? 0.0
                //let average = (previous + next)/2
                //IntradayPrices.append(average)
                continue
            } else {
                IntradayPrices.append(element.average ?? -100.0)
            }
        }        
    }
    
    
    func fetchGeneralNews() {
        self.networkReq.fetchMarketNews() { news in
                if let news = news {
                    self.networkReq.marketSentiment() { sentiment in
                        if let sentiment = sentiment {
                            DispatchQueue.main.async {
                                self.news = news.map(NewsItemVM.init)
                                self.marketSentiment = sentiment
                            }
                        }
                    }
                    
                }
            }
        
    }
}
