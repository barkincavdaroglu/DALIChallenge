//
//  StockCard.swift
//  Stock Bento
//
//  Created by Barkin Cavdaroglu on 10/11/20.
//

import SwiftUI

struct StockCard: View {
    let stock: StockItemVM

    var body: some View {
        HStack {
        
            VStack(alignment: .leading, spacing: 4.0) {
                Text(stock.symbol)
                    .fontWeight(.bold)
                    .font(.system(size: 17))
                    .foregroundColor(Color(#colorLiteral(red: 0.1838541329, green: 0.1902578175, blue: 0.2405781448, alpha: 1)))
                    .multilineTextAlignment(.leading)
                    
                Text(stock.companyName)
                    .fontWeight(.regular)
                    .font(.system(size: 15))
                    .foregroundColor(Color(#colorLiteral(red: 0.3909621239, green: 0.4030730128, blue: 0.5084071159, alpha: 1)))
                    .multilineTextAlignment(.leading)
                    .padding(.top, 4)
                    
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4.0) {
                Text(stock.latestPrice)
                    .fontWeight(.bold)
                    .foregroundColor(Color(#colorLiteral(red: 0.1838541329, green: 0.1902578175, blue: 0.2405781448, alpha: 1)))
                    .multilineTextAlignment(.trailing)
                    .padding(.leading)
                    
                HStack {
                    if (stock.changePercent.prefix(1) == "-") {
                        Image(systemName: "arrow.down")
                            .padding(.trailing, -6)
                            .font(.system(size: 18.0, weight: .bold))
                            .foregroundColor(Color.red)
                    }
                    else {
                        Image(systemName: "arrow.up")
                            .padding(.trailing, -6)
                            .font(.system(size: 18.0, weight: .bold))
                            .foregroundColor(Color.green)
                    }
                    Text(stock.changePercent)
                        .fontWeight(.light)
                        .foregroundColor(Color(#colorLiteral(red: 0.1838541329, green: 0.1902578175, blue: 0.2405781448, alpha: 1)))
                        .multilineTextAlignment(.trailing)
                        .padding([.top, .leading, .bottom], 4)
                    
                }
                    
            }.frame(width: 100)
        }
        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        .background(Color.white)
        .cornerRadius(18.0)
        .shadow(color: Color(#colorLiteral(red: 0.7551975846, green: 0.7855095267, blue: 0.8625398874, alpha: 0.4)), radius:12, x:0, y:8)
        .frame(width: 350, height: 125, alignment: .center)
        
    }
}


struct StockCard_Previews: PreviewProvider {
    static var previews: some View {
        StockCard(stock: StockItemVM(stock: Quote(symbol: "KNDI", companyName: "Kandi Technologies Group, Inc.", high: 5.5, low: 3.2, latestPrice: 9.32, latestTime: "", previousClose: 1.0, change: 1.40827, changePercent: 1.40827, week52High: 5.8, week52Low: 9.7)))
    }
}
