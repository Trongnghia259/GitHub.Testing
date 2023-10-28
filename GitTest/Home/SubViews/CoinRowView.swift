//
//  CoinRowView.swift
//  CryptoApp
//
//  Created by Tam Nguyen on 06/07/2021.
//

import SwiftUI

struct CoinRowView: View {
    
    let coin: CoinModel
    let isShownPortfolioColumn: Bool
    
    var body: some View {
        HStack {
            leftColumn
            
            Spacer()
            if isShownPortfolioColumn {
                centerColumn
            }
            rightColumn
        }
        .font(.subheadline)
        .background(Color.background)
    }
    
}

extension CoinRowView {
    
    private var leftColumn: some View {
        HStack {
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundColor(.secondaryText)
                .frame(minWidth: 30, alignment: .center)
            
            AsyncImageView(
                urlString: coin.image,
                placeholder: { ProgressView() },
                image: {
                    Image(uiImage: $0)
                        .resizable()
                }
            )
            .frame(width: 30, height: 30)
            
            Text(coin.symbol.uppercased())
                .font(.headline)
                .padding(.leading, 6)
                .foregroundColor(.accent)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
    }
    
    private var centerColumn: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentHoldingsValue.asCurrencyWith2Decimals())
                .bold()
            Text((coin.currentHoldings ?? 0).asNumberString())
        }
        .foregroundColor(.accent)
    }
    
    private var rightColumn: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentPrice.asCurrencyWith6Decimals())
                .bold()
                .foregroundColor(.accent)
            Text(coin.priceChangePercentage24H?.asPercentString() ?? "")
                .foregroundColor(
                    (coin.priceChangePercentage24H ?? 0) >= 0 ?
                        .positive : .nagative
                )
        }
        .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
        .padding(.trailing, 6)
    }
    
}

struct CoinRowView_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            CoinRowView(coin: dev.coin, isShownPortfolioColumn: false)
                .previewLayout(.sizeThatFits)
            
            CoinRowView(coin: dev.coin, isShownPortfolioColumn: true)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
    
}
