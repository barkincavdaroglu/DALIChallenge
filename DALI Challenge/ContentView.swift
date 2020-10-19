//
//  ContentView.swift
//  DALI Challenge
//
//  Created by Barkin Cavdaroglu on 10/19/20.
//

import SwiftUI
import SwiftUICharts

struct ContentView: View {
    @State private var searchTerm: String = ""
    @ObservedObject private var stockList = ListVM()
    
    init() {
        stockList.load()
    }
    
    var body: some View {
        NavigationView {
            ZStack() {
                Color(#colorLiteral(red: 0.9725490196, green: 0.9803921569, blue: 1, alpha: 1)).edgesIgnoringSafeArea(.all)
                StocksLists(stocks: self.stockList.stocks, news: stockList.news, sentiment: stockList.marketSentiment, stockList: stockList)
            }
            .navigationBarTitle("Trending Stocks")
        }
    }
}
