//
//  StockDetailCard.swift
//  Stock Bento
//
//  Created by Barkin Cavdaroglu on 10/13/20.
//

import SwiftUI
import SwiftUICharts

struct StockDetailCard: View {
    @ObservedObject var stockList = ListVM()
    var stock: StockItemVM
    
    
    let chartStyle = ChartStyle(backgroundColor: Color.white, accentColor: Color("CharGradientStart"), secondGradientColor: Color("ChartGradientEnd"), textColor: Color("ChartText"), legendTextColor: Color("ChartText"), dropShadowColor: Color.black )
    
    var body: some View {
        
        ZStack {
            Color(#colorLiteral(red: 0.9725490196, green: 0.9803921569, blue: 1, alpha: 1)).edgesIgnoringSafeArea(.all)
            GradientRect()
            
            
            VStack {
                
                Header(stock: stock)
                    .padding(.bottom, 10)
                
                LineView(data: self.stockList.IntradayPrices, style: chartStyle)
                    .frame(width: 300)
                
                QuoteView(stock: stock)
                
                VStack(alignment: .leading, spacing: 20.0) {
                    if self.stockList.companySentiment.count > 0 {
                        HStack {
                            Text("Bearish Percent: ")
                                .fontWeight(.light)
                                .foregroundColor(Color("LightText"))
                            Text(String(self.stockList.companySentiment[0].sentiment.bearishPercent))
                            Spacer()
                        }
                        HStack {
                            Text("Bullish Percent: ")
                                .fontWeight(.light)
                                .foregroundColor(Color("LightText"))
                            Text(String(self.stockList.companySentiment[0].sectorAverageBullishPercent))
                            Spacer()
                        }
                        
                    }
                }
            }
            .frame(width: UIScreen.main.bounds.width-80, height: 550, alignment: .center)
            .padding([.leading, .bottom, .trailing], 25.0)
            .padding(.top, 25.0)
            .background(Color.white)
            .cornerRadius(30.0)
            .shadow(color: Color(#colorLiteral(red: 0.7551975846, green: 0.7855095267, blue: 0.8625398874, alpha: 0.4)), radius:59, x:0, y:4)
            //.offset(y: -20)

        }
        .edgesIgnoringSafeArea(.vertical)
        .onAppear {
            self.stockList.fetchIntradayPrices(ticker: self.stock.symbol) { () -> () in
                self.stockList.companySentiments(ticker: self.stock.symbol) { () -> () in
                }
            }
        }
    }
}

struct Header: View {
    let stock: StockItemVM

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4.0) {
                Text(stock.symbol)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                
                Text(stock.companyName)
                    .fontWeight(.light)
                    .multilineTextAlignment(.leading)
                    .padding(.top, 4)
                
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4.0) {
                Text(stock.latestPrice)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.trailing)
                    .fixedSize(horizontal: true, vertical: false)
                    .padding(.leading)
                
                HStack {
                    Image(systemName: "arrow.up")
                        .padding(.trailing, -6)
                        .font(.system(size: 18.0, weight: .bold))
                        .foregroundColor(Color.green)
                    Text(stock.change)
                        .fontWeight(.light)
                        .multilineTextAlignment(.trailing)
                        .fixedSize(horizontal: true, vertical: false)
                        .padding([.top, .leading, .bottom], 4)
                        
                    
                }
                
            }
        }
    }
}

struct GradientRect: View {
    var body: some View {
        Rectangle()
            .fill(LinearGradient(
                    gradient: Gradient(stops: [
                                        .init(color: Color(#colorLiteral(red: 0.9583333134651184, green: 0.5630208253860474, blue: 0.860615611076355, alpha: 1)), location: 0),
                                        .init(color: Color(#colorLiteral(red: 0.5689235925674438, green: 0.6598365306854248, blue: 0.9416666626930237, alpha: 1)), location: 0.45),
                                        .init(color: Color(#colorLiteral(red: 0.20000000298023224, green: 0.23529411852359772, blue: 0.6117647290229797, alpha: 1)), location: 0.95)]),
                    startPoint: UnitPoint(x: 0, y: -0.09),
                    endPoint: UnitPoint(x: 1.1, y: 1.12)))
            .frame(width: 420, height: 250)
            .offset(y: -320)
    }
}

struct QuoteView: View {
    let stock: StockItemVM

    var body: some View {
        HStack() {
            VStack(alignment: .leading) {
                HStack {
                    Text("High:")
                        .fontWeight(.light)
                        .foregroundColor(Color("LightText"))
                    Text(String(stock.high ?? 0.0))
                    Spacer()
                }.padding(.bottom)
                
                HStack {
                    Text("Low:")
                        .fontWeight(.light)
                        .foregroundColor(Color("LightText"))
                    Text(String(stock.low ?? 0.0))
                    Spacer()
                }
            }
            VStack(alignment: .leading) {
                
                HStack {
                    Text("52W High:")
                        .fontWeight(.light)
                        .foregroundColor(Color("LightText"))
                    Text(stock.week52High)
                    Spacer()
                }.padding(.bottom)
                
                HStack {
                    Text("52W Low:")
                        .fontWeight(.light)
                        .foregroundColor(Color("LightText"))
                    Text(stock.week52Low)
                    Spacer()
                }
            }
        }.offset(y: -40)
    }
}
