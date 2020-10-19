//
//  IEXStockData.swift
//  Stock Bento
//
//  Created by Barkin Cavdaroglu on 10/06/20.
//

import Foundation

struct Quote: Decodable {
    let symbol: String
    let companyName: String
    let high: Double?
    let low: Double?
    let latestPrice: Double
    let latestTime: String
    let previousClose: Double
    let change: Double
    let changePercent: Double
    let week52High: Double
    let week52Low: Double
}

struct Intraday: Decodable {
    let minute: String
    let average: Double?
}

