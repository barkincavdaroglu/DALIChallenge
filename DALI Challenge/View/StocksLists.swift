//
//  StocksLists.swift
//  Stock Bento
//
//  Created by Barkin Cavdaroglu on 10/09/20.
//

import SwiftUI
import SDWebImageSwiftUI

struct StocksLists: View {
    let stocks: [StockItemVM]
    let news: [NewsItemVM]
    let sentiment: String
    @ObservedObject var stockList: ListVM
    @State private var searchTerm: String = ""
    
    var body: some View {
        
        VStack {
            
            ScrollView {
                VStack {
                    HStack {
                        if Double(sentiment) ?? 0 > 0 {
                            Text("Markets feel positive today")
                                .fontWeight(.regular)
                                .font(.system(size: 18))
                                .foregroundColor(Color(#colorLiteral(red: 0.392475903, green: 0.403211832, blue: 0.5184909105, alpha: 1)))
                        }
                        else if Double(sentiment) ?? 0 < 0 {
                            Text("Markets feel negative today")
                                .fontWeight(.regular)
                                .font(.system(size: 18))
                                .foregroundColor(Color(#colorLiteral(red: 0.392475903, green: 0.403211832, blue: 0.5184909105, alpha: 1)))
                        }
                        else {
                            Text("Markets don't feel like anything today")
                                .fontWeight(.regular)
                                .font(.system(size: 18))
                                .foregroundColor(Color(#colorLiteral(red: 0.392475903, green: 0.403211832, blue: 0.5184909105, alpha: 1)))
                        }
                        Spacer()
                    }
                    .padding(.leading, 20)
                    .padding(.top, 10)
                    
                    
                }
                MarketNews(news: news)
                    
                
                LazyVGrid(columns: [GridItem()], spacing: 1) {
                    ForEach(0..<self.stocks.count, id: \.self) { index in
                        NavigationLink(destination: StockDetailCard(stock: stocks[index])) {
                            StockCard(stock: self.stocks[index])
                        }.buttonStyle(PlainButtonStyle())
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}

struct MarketNews: View {
    let news: [NewsItemVM]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(self.news, id: \.id) { news in
                    ZStack {
                        
                        Rectangle()
                            .fill(LinearGradient(
                                    gradient: Gradient(stops: [
                                                        .init(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2065607538)), location: 0),
                                                        .init(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6973813373)), location: 1)]),
                                    startPoint: UnitPoint(x: 0.4999999999999999, y: -0.06481481349256674),
                                    endPoint: UnitPoint(x: 0.5000000000000001, y: 1.000000011900233)))
                            .frame(width: 180, height: 170)
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        
                        VStack {
                            Text(news.headline)
                                
                                .fontWeight(.semibold)
                                .foregroundColor(Color.white)
                                .padding(.top, 20)
                                .padding([.leading, .trailing], 15)
                            
                            Text(news.summary)
                                .fontWeight(.regular)
                                .font(.system(size: 13))
                                .foregroundColor(Color.white)
                                .padding([.top, .bottom], 5)
                                .padding([.leading, .trailing], 15)
                            SafariNewsView(urlString: news.url)
                        }
                        .frame(width: 180, height: 170, alignment: .center)
                        .lineLimit(2)
                        .padding(.all, 5)
                        
                    }
                    .background(
                        WebImage(url: URL(string: news.image))
                            .resizable()
                            .indicator(.activity)
                            .transition(.fade(duration: 0.5))
                            .frame(width: 180, height: 170, alignment: .center)
                            .scaledToFill()
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                            .shadow(color: Color(#colorLiteral(red: 0.7551975846, green: 0.7855095267, blue: 0.8625398874, alpha: 0.4)), radius:10, x:0, y:6)
                    )
                }
                
            }
            .padding(.leading, 15)
            .frame(height: 180)
        }
    }
}
