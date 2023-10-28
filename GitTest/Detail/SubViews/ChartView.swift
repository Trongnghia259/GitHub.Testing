//
//  ChartView.swift
//  CryptoApp
//
//  Created by Tam Nguyen on 09/07/2021.
//

import SwiftUI

struct ChartView: View {
    
    @State private var percentChage: CGFloat = 0
    
    private let data: [Double]
    private let maxY: Double
    private let minY: Double
    private let lineColor: Color
    private let startDate: Date
    private let endDate: Date
    
    init(coin: CoinModel) {
        data = coin.sparklineIn7D?.price ?? []
        maxY = data.max() ?? 0
        minY = data.min() ?? 0
        
        let priceChage = (data.last ?? 0) - (data.first ?? 0)
        lineColor = priceChage > 0 ? .positive : .nagative
        
        endDate = Date(coinGeckoString: coin.lastUpdated ?? "")
        startDate = endDate.addingTimeInterval(-7*24*60*60)
    }
    
    var body: some View {
        VStack {
            chartView
                .frame(height: 200)
                .background(chartBackground)
                .overlay(chartYAxis.padding(.horizontal, 4), alignment: .leading)
            chartDateLabels
                .padding(.horizontal, 4)
        }
        .font(.caption)
        .foregroundColor(.secondaryText)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation(.linear(duration: 1.5)) {
                    percentChage = 1.0
                }
            }
        }
    }
    
}

extension ChartView {
    
    private var chartView: some View {
        GeometryReader { geometry in
            Path { path in
                for index in data.indices {
                    let xP = geometry.size.width / CGFloat(data.count) * CGFloat(index + 1)
                    let yAxis = maxY - minY
                    let yP = (1 - CGFloat((data[index] - minY) / yAxis)) * geometry.size.height
                    if index == 0 {
                        path.move(to: CGPoint(x: xP, y: yP))
                    }
                    path.addLine(to: CGPoint(x: xP, y: yP))
                }
            }
            .trim(from: 0.0, to: percentChage)
            .stroke(
                lineColor,
                style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round)
            )
            .shadow(color: lineColor, radius: 10, x: 0.0, y: 10.0)
            .shadow(color: lineColor.opacity(0.5), radius: 10, x: 0.0, y: 20.0)
            .shadow(color: lineColor.opacity(0.2), radius: 10, x: 0.0, y: 30.0)
            .shadow(color: lineColor.opacity(0.1), radius: 10, x: 0.0, y: 40.0)
        }
    }
    
    private var chartBackground: some View {
        VStack {
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        }
    }
    
    private var chartYAxis: some View {
        VStack {
            Text(maxY.formattedWithAbbreviations())
            Spacer()
            Text(((maxY + minY) / 2).formattedWithAbbreviations())
            Spacer()
            Text(minY.formattedWithAbbreviations())
        }
    }
    
    private var chartDateLabels: some View {
        HStack {
            Text(startDate.asShortDateString())
            Spacer()
            Text(endDate.asShortDateString())
        }
    }
    
}

struct ChartView_Previews: PreviewProvider {
    
    static var previews: some View {
        ChartView(coin: dev.coin)
    }
    
}
