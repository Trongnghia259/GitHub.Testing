//
//  HomeView.swift
//  CryptoApp
//
//  Created by Tam Nguyen on 06/07/2021.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var viewModel: HomeViewModel
    @State private var isShownPortfolio: Bool = false // animate right
    @State private var isShownPortfolioView: Bool = false // new sheet
    @State private var selection: String? = nil
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
                .sheet(isPresented: $isShownPortfolioView, content: {
                    PortfolioView()
                        .environmentObject(viewModel)
                })
            
            VStack {
                headerView
                HomeStatisticView(isShownPortfolio: $isShownPortfolio)
                SearchBarView(searchText: $viewModel.searchText)
                sectionTitles
                if isShownPortfolio {
                    portfolioCoinsList
                        .transition(.move(edge: .trailing))
                }
                
                if !isShownPortfolio {
                    searchCoinsList
                        .transition(.move(edge: .leading))
                }
                Spacer(minLength: 0)
            }
        }
    }
    
}

extension HomeView {
    
    private var headerView: some View {
        HStack {
            if isShownPortfolio {
                CircleButtonView(iconName: "plus")
                    .animation(.none)
                    .onTapGesture {
                        isShownPortfolioView.toggle()
                    }
            } else {
                Text("")
                    .frame(width: 75, height: 50)
            }
            
            Spacer()
            Text(isShownPortfolio ? "In " : "All")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(.accent)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: isShownPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring()) {
                        isShownPortfolio.toggle()
                    }
                }
        }
    }
    
    private var sectionTitles: some View {
        HStack {
            HStack(spacing: 4) {
                Text("Coins")
                Image(systemName: "chevron.down")
                    .opacity(
                        (viewModel.sortOption == .rank || viewModel.sortOption == .rankReveresd) ? 1.0 : 0.0
                    )
                    .rotationEffect(
                        Angle(
                            degrees: viewModel.sortOption == .rank ? 0 : 180
                        )
                    )
            }
            .onTapGesture {
                withAnimation(.default) {
                    viewModel.sortOption = viewModel.sortOption == .rank ? .rankReveresd : .rank
                }
            }
            
            Spacer()
            
            if isShownPortfolio {
                HStack(spacing: 4) {
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .opacity(
                            (viewModel.sortOption == .holding || viewModel.sortOption == .holdingReversed) ? 1.0 : 0.0
                        )
                        .rotationEffect(
                            Angle(
                                degrees: viewModel.sortOption == .holding ? 0 : 180
                            )
                        )
                }
                .onTapGesture {
                    withAnimation(.default) {
                        viewModel.sortOption = viewModel.sortOption == .holding ? .holdingReversed : .holding
                    }
                }
            }
            
            HStack(spacing: 4) {
                Text("Prices")
                Image(systemName: "chevron.down")
                    .opacity(
                        (viewModel.sortOption == .price || viewModel.sortOption == .priceReveresd) ? 1.0 : 0.0
                    )
                    .rotationEffect(
                        Angle(
                            degrees: viewModel.sortOption == .price ? 0 : 180
                        )
                    )
            }
            .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
            .onTapGesture {
                withAnimation(.default) {
                    viewModel.sortOption = viewModel.sortOption == .price ? .priceReveresd : .price
                }
            }
            
            Button(action: {
                withAnimation(.linear(duration: 2.0)) {
                    viewModel.reloadData()
                }
            }, label: {
                Image(systemName: "goforward")
            })
            .rotationEffect(
                Angle(degrees: viewModel.isReloading ? 360 : 0), anchor: .center
            )
        }
        .font(.caption)
        .foregroundColor(.secondaryText)
        .padding(.horizontal)
        
    }
    
    private var portfolioCoinsList: some View {
        List {
            ForEach(viewModel.portfolioCoins, id: \.id) { coin in
                VStack(spacing: 0) {
                    CoinRowView(coin: coin, isShownPortfolioColumn: true)
                        .listRowInsets(
                            .init(top: 10, leading: 0, bottom: 10, trailing: 0)
                        )
                        .onTapGesture(count: 1) {
                            selection = coin.id
                        }
                    NavigationLink(
                        destination: NavigationLazyView(DetailView(coin: coin)),
                        tag: coin.id,
                        selection: $selection) {
                        EmptyView()
                    }
                    .frame(width: 0, height: 0)
                    .hidden()
                    .buttonStyle(PlainButtonStyle())
                }
                .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                .offset(x: -16)
            }
            .onDelete(perform: delete)
        }
        .listStyle(PlainListStyle())
    }
    
    private var searchCoinsList: some View {
        List {
            ForEach(viewModel.searchCoins, id: \.id) { coin in
                VStack(spacing: 0) {
                    CoinRowView(coin: coin, isShownPortfolioColumn: false)
                        .listRowInsets(
                            .init(top: 10, leading: 0, bottom: 10, trailing: 0)
                        )
                        .onTapGesture {
                            selection = coin.id
                        }
                    NavigationLink(
                        destination: NavigationLazyView(DetailView(coin: coin)),
                        tag: coin.id,
                        selection: $selection) {
                        EmptyView()
                    }
                    .hidden()
                    .buttonStyle(PlainButtonStyle())
                }
                .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                .offset(x: -16)
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private func delete(at offsets: IndexSet) {
        offsets.forEach {
            let coin = viewModel.portfolioCoins[$0]
            viewModel.updatePortfolio(coin: coin, amount: -1)
        }
    }
    
}

struct HomeView_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationView {
            HomeView()
                .navigationBarHidden(true)
                .environmentObject(dev.homeViewModel)
        }
        .preferredColorScheme(.light)
    }
    
}
