//
//  ContentView.swift
//  YHealth
//
//  Created by eternity6666 on 2023/10/11.
//

import SwiftUI
import SwiftData
import HealthKit

struct StepCountData {
    let date: Date
    let stepCount: Double
}

struct ContentView: View {
    @State private var bloodType: HKBloodType = .notSet
    @State private var stepCount: [StepCountData] = []
    
    var body: some View {
        ScrollView {
            VStack {
                Section {
                    Button {
                        YHKManager.shared.requestAuth()
                    } label: {
                        Text("获取权限")
                    }
                    HStack {
                        Text("血型")
                        Spacer()
                        Text(bloodType.name)
                    }
                    Button {
                        fetchStepCount()
                    } label: {
                        Text("获取步数")
                    }
                    VStack {
                        ForEach(stepCount.indices, id: \.self) { index in
                            HStack {
                                Text("\(stepCount[index].date.formatted(date: .numeric, time: .omitted))")
                                Spacer()
                                Text("\(Int(stepCount[index].stepCount))")
                            }
                        }
                    }
                    
                }
                .padding()
                .task {
                    bloodType = YHKManager.shared.fetchBloodType()
                }
            }
        }
    }
    
    private func fetchStepCount() {
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
            stepCount = values
        }
    }
}

#Preview {
    ContentView()
}
