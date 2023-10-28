//
//  HomeStatisticView.swift
//  CryptoApp
//
//  Created by Tam Nguyen on 08/07/2021.
//

import SwiftUI

struct HomeStatisticView: View {
    
    @EnvironmentObject private var viewModel: HomeViewModel
    @Binding var isShownPortfolio: Bool
    
    var body: some View {
        HStack {
            ForEach(viewModel.stats) { stat in
                StatisticView(stat: stat)
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
        }
        .frame(
            width: UIScreen.main.bounds.width,
            alignment: isShownPortfolio ? .trailing : .leading
        )
    }
}

struct HomeStatisticView_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            HomeStatisticView(isShownPortfolio: .constant(false))
                .environmentObject(dev.homeViewModel)
                .previewLayout(.sizeThatFits)
        }
    }
    
}
