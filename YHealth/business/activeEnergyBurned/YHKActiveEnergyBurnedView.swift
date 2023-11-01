//
//  YHKActiveEnergyBurned.swift
//  YHealth
//
//  Created by eternity6666 on 2023/11/2.
//

import SwiftUI
import HealthKit
import Charts

struct YHKActiveEnergyBurnedData {
    var date: Date
    var value: Double
}

struct YHKActiveEnergyBurnedView: View {
    
    @State private var isLoading: Bool = true
    @State private var activeEnergyBurned: [YHKActiveEnergyBurnedData] = []
    
    var body: some View {
        YHKCardView(
            isLoading: $isLoading,
            width: 300.0,
            height: 300.0,
            content: VStack {
                showActiveEnergyBurnedData()
            }.padding()
        )
        .onAppear {
            loadData()
        }
    }
    
    @ViewBuilder
    private func showActiveEnergyBurnedData() -> some View {
        Chart(activeEnergyBurned, id: \.date) { item in
            BarMark(
                x: .value("", "\(item.date.day ?? 0)"),
                y: .value("", item.value)
            )
        }
    }
    
    private func loadData() {
        isLoading = true
        activeEnergyBurned.removeAll()
        let option = HKStatisticsOptions.cumulativeSum
        let start = Date.now.addingTimeInterval(-6*24*3600).zeroTime()
        let end = Date.now.addingTimeInterval(24*3600).zeroTime().addingTimeInterval(-1)
        YHKManager.shared.fetchActiveEnergyBurned(start: start, end: end) {
            var values: [YHKActiveEnergyBurnedData] = []
            $0.enumerateStatistics(from: start, to: end) { statistic, stop in
                let statisticsQuantity = statistic.sumQuantity()
                if let value = statisticsQuantity?.doubleValue(for: .kilocalorie()) {
                    values.append(YHKActiveEnergyBurnedData(date: statistic.startDate, value: value))
                }
            }
            DispatchQueue.main.async {
                values.forEach { item in
                    activeEnergyBurned.append(item)
                }
                isLoading = false
            }
        }
    }
}

#Preview {
    YHKActiveEnergyBurnedView()
}
