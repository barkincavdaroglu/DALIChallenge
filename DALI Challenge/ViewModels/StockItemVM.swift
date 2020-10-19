//
//  StockItemVM.swift
//  Stock Bento
//
//  Created by Barkin Cavdaroglu on 10/03/20.
//

import Foundation

struct StockItemVM {
    let stock: Quote
    
    var symbol: String {
        return self.stock.symbol.uppercased()
    }
    
    var companyName: String {
        return self.stock.companyName
    }
    
    var high: Double? {
        return self.stock.high
    }
    
    var low: Double? {
        return self.stock.low
    }
    
    var latestPrice: String {
        return String(format: "%.2f", self.stock.latestPrice)
    }
    
    var change: String {
        return String(self.stock.change)
    }
    
    var latestTime: String {
        return self.stock.latestTime
    }
    
    var previousClose: String {
        return String(format: "%.2f", self.stock.previousClose)
    }
    
    var changePercent: String {
        return String(self.stock.changePercent)
    }
    
    var week52High: String {
        return String(self.stock.week52High)
    }
    
    var week52Low: String {
        return String(self.stock.week52Low)
    }
    
}

struct IntradayPricesVM {
    let intradayPrices: Intraday
    
    var minute: String {
        return self.intradayPrices.minute
    }
    
    var prices: Double? {
        return self.intradayPrices.average
    }
}
