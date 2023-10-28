//
//  DetailView.swift
//  CryptoApp
//
//  Created by Tam Nguyen on 09/07/2021.
//

import SwiftUI

struct DetailView: View {
    
    @StateObject var viewModel: DetailViewModel
    @State var isShowingFullDes: Bool = false
    
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    init(coin: CoinModel) {
        _viewModel = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
    
    var body: some View {
        ScrollView {
            VStack {
                ChartView(coin: viewModel.coin)
                    .padding(.vertical)
                VStack(spacing: 20) {
                    overviewTitle
                    Divider()
                    desSection
                    overviewGrid
                    
                    additionalTitle
                    Divider()
                    addtionalGrid
                    websiteSection   
                }
                .padding()
            }
        }
        .navigationTitle(viewModel.coin.name)
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Text(viewModel.coin.symbol.uppercased())
                        .font(.headline)
                        .foregroundColor(.secondaryText)
                    AsyncImageView(
                        urlString: viewModel.coin.image,
                        placeholder: { ProgressView() },
                        image: {
                            Image(uiImage: $0)
                                .resizable()
                        }
                    )
                    .frame(width: 30, height: 30)
                }
            }
        })
    }
    
}

extension DetailView {
    
    private var overviewTitle: some View {
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundColor(.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var desSection: some View {
        ZStack {
            if let des = viewModel.description, !des.isEmpty {
                VStack {
                    Text(des)
                        .lineLimit(isShowingFullDes ? nil : 3)
                        .font(.callout)
                        .foregroundColor(.secondaryText)
                    Button(action: {
                        withAnimation(.easeInOut) {
                            isShowingFullDes.toggle()
                        }
                    }, label: {
                        Text(isShowingFullDes ? "Less" : "Read more...")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.vertical, 4)
                    })
                    .accentColor(.blue)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
    
    private var overviewGrid: some View {
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: 20,
            pinnedViews: []
        ) {
            ForEach(viewModel.overviews) { stat in
                StatisticView(stat: stat)
            }
        }
    }
    
    private var additionalTitle: some View {
        Text("Addtitional Details")
            .font(.title)
            .bold()
            .foregroundColor(.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var addtionalGrid: some View {
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: 20,
            pinnedViews: []
        ) {
            ForEach(viewModel.additions) { stat in
                StatisticView(stat: stat)
            }
        }
    }
    
    private var websiteSection: some View {
        HStack {
            if let wedUrl = viewModel.webUrl,
               let url = URL(string: wedUrl) {
                Link("Website", destination: url)
            }
            Spacer()
            if let redditUrl = viewModel.redditUrl,
               let url = URL(string: redditUrl) {
                Link("Reddit", destination: url)
            }
        }
        .accentColor(.blue)
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.headline)
    }
    
}

struct DetailView_Previews: PreviewProvider {
    
    static var previews: some View {
        DetailView(coin: dev.coin)
    }
    
}
