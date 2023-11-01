//
//  YHKStepCountCardView.swift
//  YHealth
//
//  Created by eternity6666 on 2023/11/1.
//

import SwiftUI
import Charts
import HealthKit

struct YHKStepCountCardView: View {
    @State private var isLoading: Bool = true
    @State private var stepCount: [StepCountData] = []
    
    var body: some View {
        YHKCardView(
            isLoading: $isLoading,
            width: 300.0,
            height: 300.0,
            content: VStack {
                showStepCountBoard()
            }
                .padding()
        )
        .onAppear {
            fetchStepCount()
        }
    }
    
    private func stepCountMessage() -> Int {
        var sum: Double = 0
        stepCount.forEach { item in
            sum += item.stepCount
        }
        return Int(sum)
    }
    
    @ViewBuilder
    private func showStepCountBoard() -> some View {
        let count = stepCountMessage()
        if (count > 0) {
            Text("\(count)")
        }
        Chart(stepCount, id: \.date) { item in
            BarMark(
                x: .value("", "\(item.date.day ?? 0)"),
                y: .value("", item.stepCount)
            )
        }
    }
    
    private func fetchStepCount() {
        isLoading = true
        stepCount.removeAll()
        let option = getStatisticsOptions(for: HKQuantityTypeIdentifier.stepCount.rawValue)
        let start = Date.now.addingTimeInterval(-6*24*3600).zeroTime()
        let end = Date.now.addingTimeInterval(24*3600).zeroTime().addingTimeInterval(-1)
        YHKManager.shared.fetchStepCount(start: start, end: end) {
            var values: [StepCountData] = []
            $0.enumerateStatistics(from: start, to: end) { statistic, stop in
                let statisticsQuantity = getStatisticsQuantity(for: statistic, with: option)
                if let value = statisticsQuantity?.doubleValue(for: .count()) {
                    values.append(StepCountData(date: statistic.startDate, stepCount: value))
                }
            }
            DispatchQueue.main.async {
                values.forEach { item in
                    stepCount.append(item)
                }
                isLoading = false
            }
        }
    }
}

#Preview {
    YHKStepCountCardView()
}
