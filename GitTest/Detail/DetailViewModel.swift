//
//  DetailViewModel.swift
//  CryptoApp
//
//  Created by Tam Nguyen on 09/07/2021.
//

import Foundation
import Combine

final class DetailViewModel: ObservableObject {
    
    @Published var overviews: [StatisticModel] = []
    @Published var additions: [StatisticModel] = []
    @Published var detail: CoinDetailModel?
    @Published var coin: CoinModel
    @Published var description: String? = nil
    @Published var webUrl: String? = nil
    @Published var redditUrl: String? = nil
    
    private var cancellables = Set<AnyCancellable>()
    private let urlSession = URLSession.shared
    
    init(coin: CoinModel) {
        self.coin = coin
        getDetail(id: coin.id)
        addSubcribers()
    }
    
    private func getDetail(id: String) {
        let urlString = "https://api.coingecko.com/api/v3/coins/\(id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false"
        urlSession.dataTaskPublisher(with: urlString)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] value in
                self?.detail = value
            }
            .store(in: &cancellables)
    }
}

extension DetailViewModel {
    
    private func addSubcribers() {
        $detail
            .combineLatest($coin)
            .map(mapDataToStatistics)
            .sink { [weak self] result in
                self?.overviews = result.overviews
                self?.additions = result.additions
            }
            .store(in: &cancellables)
        
        $detail
            .sink { [weak self] detail in
                self?.description = detail?.readableDescription
                self?.webUrl = detail?.links?.homepage?.first
                self?.redditUrl = detail?.links?.subredditURL
            }
            .store(in: &cancellables)
    }
    
    private func mapDataToStatistics(
        detailModel: CoinDetailModel?, coinModel: CoinModel
    ) -> (overviews: [StatisticModel], additions: [StatisticModel]) {
        let overviewArray = createOverviewArray(coinModel: coinModel)
        let additionalArray = createAdditionalArray(detailModel: detailModel, coinModel: coinModel)
        return (overviewArray, additionalArray)
    }
    
    private func createOverviewArray(coinModel: CoinModel) -> [StatisticModel] {
        let price = coin.currentPrice.asCurrencyWith6Decimals()
        let pricePercentChange = coin.priceChangePercentage24H
        let priceStat = StatisticModel(title: "Current Price", value: price, percentageChange: pricePercentChange)
        
        let marketCap = "$" + (coin.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = coin.marketCapChangePercentage24H
        let marketCapStat = StatisticModel(
            title: "Market Capitalization", value: marketCap, percentageChange: marketCapPercentChange
        )
        
        let rank = "\(coin.rank)"
        let rankStat = StatisticModel(title: "Rank", value: rank)
        
        let volumn = "$\(coin.totalVolume?.formattedWithAbbreviations() ?? "")"
        let volumnStat = StatisticModel(title: "Volumn", value: volumn)
        
        return [priceStat, marketCapStat, rankStat, volumnStat]
    }
    
    private func createAdditionalArray(detailModel: CoinDetailModel?, coinModel: CoinModel) -> [StatisticModel] {
        let high = coin.high24H?.asCurrencyWith6Decimals() ?? "n/a"
        let highStat = StatisticModel(title: "24h High", value: high)
        
        let low = coin.low24H?.asCurrencyWith6Decimals() ?? "n/a"
        let lowStat = StatisticModel(title: "24h Low", value: low)
        
        let priceChange = coin.priceChange24H?.asCurrencyWith6Decimals() ?? "n/a"
        let pricePercenthange = coin.priceChangePercentage24H
        let priceChangeStat = StatisticModel(
            title: "24h Price Change", value: priceChange, percentageChange: pricePercenthange
        )
        
        let marketCapChange = coin.marketCapChange24H?.asCurrencyWith6Decimals() ?? "n/a"
        let marketCapPercenthange = coin.marketCapChangePercentage24H
        let marketCapChangeStat = StatisticModel(
            title: "24h Market Cap Change", value: marketCapChange, percentageChange: marketCapPercenthange
        )
        
        let blockTime = (detailModel?.blockTimeInMinutes ?? 0)
        let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
        let blockTimeStat = StatisticModel(title: "Block Time", value: blockTimeString)
        
        let hashing = detailModel?.hashingAlgorithm ?? "n/a"
        let hashingStat = StatisticModel(title: "Hashing Algorithm", value: hashing)
        
        return [
            highStat, lowStat, priceChangeStat, marketCapChangeStat, blockTimeStat, hashingStat
        ]
    }
}
