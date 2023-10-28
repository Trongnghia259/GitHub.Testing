//
//  PortfolioView.swift
//  CryptoApp
//
//  Created by Tam Nguyen on 08/07/2021.
//

import SwiftUI

struct PortfolioView: View {
    
    @EnvironmentObject private var viewModel: HomeViewModel
    @State private var selectedCoin: CoinModel? = nil
    @State private var quantityText: String = ""
    @State private var isFirstResponder = false
    @State private var isShownCheckmark: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollViewReader { scrollView in
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        
                        SearchBarView(searchText: $viewModel.searchText)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 10) {
                                ForEach(viewModel.searchCoins) { coin in
                                    CoinLogoView(coin: coin)
                                        .frame(width: 75)
                                        .padding(4)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(
                                                    selectedCoin?.id == coin.id ? Color.positive : Color.clear,
                                                    lineWidth: 1
                                                )
                                        )
                                        .onTapGesture {
                                            withAnimation(.easeIn) {
                                                updateSelectedCoin(coin: coin)
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                withAnimation(.linear) {
                                                    scrollView.scrollTo(99, anchor: .bottom)
                                                }
                                            }
                                        }
                                }
                            }
                        }
                        .frame(height: 120)
                        .padding(.leading)
                        
                        if selectedCoin != nil {
                            VStack {
                                portfolioInputSection
                                    .id(99)
                            }
                        }
                    }
                }
                .navigationTitle("Edit Holdings")
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarLeading) {
                        XmarkButton()
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        navigationBarTrailing
                    }
                })
                .onChange(of: viewModel.searchText, perform: { value in
                    if value == "" {
                        removeSelectedCoin()
                    }
                })
            }
        }
    }
    
}

extension PortfolioView {
    
    private var coinLogoList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
                ForEach(viewModel.searchCoins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding(4)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(
                                    selectedCoin?.id == coin.id ? Color.positive : Color.clear,
                                    lineWidth: 1
                                )
                        )
                        .onTapGesture {
                            withAnimation(.easeIn) {
                                updateSelectedCoin(coin: coin)
                            }
                        }
                }
            }
        }
        .frame(height: 120)
        .padding(.leading)
    }
    
    private var portfolioInputSection: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Current price of \(selectedCoin?.symbol.uppercased() ?? ""):")
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrencyWith2Decimals() ?? "")
            }
            Divider()
            HStack {
                Text("Amount holding:")
                Spacer()
                LegacyTextField(text: $quantityText, isFirstResponder: $isFirstResponder)
            }
            Divider()
            HStack {
                Text("Current value:")
                Spacer()
                Text(getCurrentValue().asCurrencyWith2Decimals())
            }
        }
        .animation(.none)
        .padding()
        .font(.headline)
    }
    
    private var navigationBarTrailing: some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark").opacity(
                isShownCheckmark ? 1.0 : 0.0
            )
            Button(action: {
                saveButtonPressed()
            }, label: {
                Text("SAVE")
            })
            .opacity(
                (selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText)) ? 1.0 : 0.0
            )
        }
    }
    
    private func getCurrentValue() -> Double {
        guard let quatity = Double(quantityText) else {
            return 0.0
        }
        return quatity * (selectedCoin?.currentPrice ?? 0)
    }
    
    private func saveButtonPressed() {
        guard let coin = selectedCoin, let amount = Double(quantityText) else { return }
        withAnimation(.easeIn) {
            isShownCheckmark = true
            removeSelectedCoin()
        }
        viewModel.updatePortfolio(coin: coin, amount: amount)
        isFirstResponder = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation(.easeOut) {
                isShownCheckmark = false
            }
        }
    }
    
    private func removeSelectedCoin() {
        selectedCoin = nil
        viewModel.searchText = ""
        isFirstResponder = false
    }
    
    private func updateSelectedCoin(coin: CoinModel) {
        selectedCoin = coin
        isFirstResponder = true
        guard let portfolioCoin = viewModel.portfolioCoins.first(where: { $0.id == coin.id}),
              let amount = portfolioCoin.currentHoldings else {
            quantityText = ""
            return
        }
        quantityText = "\(amount)"
    }
}

struct PortfolioView_Previews: PreviewProvider {
    
    static var previews: some View {
        PortfolioView()
            .environmentObject(dev.homeViewModel)
    }
    
}
