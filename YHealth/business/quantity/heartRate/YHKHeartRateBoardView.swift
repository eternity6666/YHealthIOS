//
//  YHKHeartRateBoardView.swift
//  YHealth
//
//  Created by eternity6666 on 2023/11/6.
//

import SwiftUI
import HealthKit

struct YHKHeartRateData {
    var date: Date
    var value: Double
}

struct YHKHeartRateBoardView: View {
    @State private var start = Date.now.addingTimeInterval(-6*24*3600).zeroTime()
    @State private var end = Date.now.addingTimeInterval(24*3600).zeroTime().addingTimeInterval(-1)
    @State private var isLoading: Bool = true
    @State private var heartRateDataList: [YHKHeartRateData] = []
    
    var body: some View {
        YHKCardView(
            isLoading: $isLoading,
            width: 300.0,
            height: 300.0,
            content: VStack {
                YHKDateSelectorView(startDate: $start, endDate: $end) {
                    loadData()
                }
            }.padding()
        )
        .onAppear {
            loadData()
        }
    }
    
    @ViewBuilder
    private func showHeartRate() -> some View {
        ForEach(heartRateDataList.indices, id: \.self) { index in
            HStack {
                Text(heartRateDataList[index].date.description)
                Spacer()
                Text("\(heartRateDataList[index].value)")
            }
        }
    }
    
    private func loadData() {
        isLoading = true
        heartRateDataList.removeAll()
        YHKManager.shared.fetchHeartRate(start: start, end: end) {
            var values: [YHKHeartRateData] = []
            $0.enumerateStatistics(from: start, to: end) { statistic, stop in
                let statisticsQuantity = statistic.sumQuantity()
                if let value = statisticsQuantity?.doubleValue(for: .count()) {
                    values.append(YHKHeartRateData(date: statistic.startDate, value: value))
                }
            }
            DispatchQueue.main.async {
                heartRateDataList = values
                isLoading = false
            }
        }
    }
}

#Preview {
    YHKHeartRateBoardView()
}
