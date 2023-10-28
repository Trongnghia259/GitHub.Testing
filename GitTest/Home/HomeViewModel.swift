//
//  HomeViewModel.swift
//  CryptoApp
//
//  Created by Tam Nguyen on 06/07/2021.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    
    @Published var isReloading: Bool = false
    @Published var searchText: String = ""
    @Published var sortOption: SortOption = .rank
    @Published var stats: [StatisticModel] = []
    @Published var searchCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var marketDataModel: MarketDataModel.Data?
    @Published private var allCoins: [CoinModel] = [] {
        didSet {
            searchCoins = allCoins
        }
    }
    
    enum SortOption {
        case rank, rankReveresd, holding, holdingReversed, price, priceReveresd
    }
    
    private let portfolioService = PortfolioDataService()
    private var cancellables = Set<AnyCancellable>()
    private let urlSession = URLSession.shared
    
    private let allCoinsUrl = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h"
    private let marketUrl = "https://api.coingecko.com/api/v3/global"
    
    init() {
        reloadData()
        addSubcribers()
    }
    
    func reloadData() {
        isReloading = true
        urlSession.dataTaskPublisher(with: allCoinsUrl)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] value in
                self?.allCoins = value
            }
            .store(in: &cancellables)
        
        urlSession.dataTaskPublisher(with: marketUrl)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] data in
                self?.marketDataModel = data
            }
            .store(in: &cancellables)
    }
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioService.updatePortfolio(coin: coin, amount: amount)
    }
}

extension HomeViewModel {
    
    private func addSubcribers() {
        $searchText
            .combineLatest($allCoins, $sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .sink { [weak self] returnedCoins in
                self?.searchCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        portfolioService.$savedEnttities
            .combineLatest($searchCoins, $sortOption)
            .receive(on: DispatchQueue.main)
            .map(updatePortfolioCoins)
            .sink { [weak self] returnedCoins in
                self?.portfolioCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        $portfolioCoins
            .combineLatest($marketDataModel)
            .map(updateStatistics)
            .sink { [weak self] returnedStats in
                self?.stats = returnedStats
                self?.isReloading = false
            }
            .store(in: &cancellables)
    }
    
    private func filterAndSortCoins(text: String, coins: [CoinModel], sort: SortOption) -> [CoinModel] {
        var filteredCoins = filterCoins(text: text, coins: coins)
        sortCoins(sort: sort, coins: &filteredCoins)
        return filteredCoins
    }
    
    private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else {
            return coins
        }
        
        let lowerCaseText = text.lowercased()
        return coins.filter {
            return $0.name.lowercased().contains(lowerCaseText) ||
                $0.symbol.lowercased().contains(lowerCaseText) ||
                $0.id.lowercased().contains(lowerCaseText)
        }
    }
    
    private func sortCoins(sort: SortOption, coins: inout [CoinModel]) {
        switch sort {
        case .rank, .holding:
            coins.sort(by: { $0.rank < $1.rank })
        case .rankReveresd, .holdingReversed:
            coins.sort(by: { $0.rank > $1.rank })
        case .price:
            coins.sort(by: { $0.currentPrice > $1.currentPrice })
        case .priceReveresd:
            coins.sort(by: { $0.currentPrice < $1.currentPrice })
        }
    }
    
    private func updateStatistics(portfolioCoins: [CoinModel], marketData: MarketDataModel.Data?) -> [StatisticModel] {
        guard let marketDataModel = marketData?.data else { return [] }
        
        let portfolioValue = portfolioCoins
            .map({ $0.currentHoldingsValue })
            .reduce(0, +)
        
        let previousValueChange24H = portfolioCoins.compactMap({ $0.previousValueChange24H })
            .reduce(0, +)
        
        let percentageChange = (previousValueChange24H * 100) / portfolioValue
        
        return [
            StatisticModel(
                title: "Market Cap",
                value: marketDataModel.marketCap,
                percentageChange: marketDataModel.marketCapChangePercentage24HUsd
            ),
            StatisticModel(title: "24h Volumn", value: marketDataModel.volume),
            StatisticModel(title: "BTC Dominance", value: marketDataModel.btcDominance),
            StatisticModel(
                title: "Holding Value",
                value: portfolioValue.asCurrencyWith2Decimals(),
                percentageChange: percentageChange
            )
        ]
    }
    
    private func updatePortfolioCoins(entities: [PortfolioEntity], coins: [CoinModel], sort: SortOption) -> [CoinModel] {
        var portfolioCoins = coins
            .compactMap { coin -> CoinModel? in
                guard let entity = entities.first(where: { $0.coinID == coin.id }) else { return nil }
                return coin.updateHoldings(amount: entity.amount)
            }
        sortCoins(sort: sort, coins: &portfolioCoins)
        return portfolioCoins
    }
    
}
