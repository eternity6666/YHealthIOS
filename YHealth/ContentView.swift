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
    @State private var stepCount2: [StepCountData] = []
    
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
                        let option = getStatisticsOptions(for: HKQuantityTypeIdentifier.stepCount.rawValue)
                        YHKManager.shared.fetchStepCount {
                            var values: [StepCountData] = []
                            var values2: [StepCountData] = []
                            let oneDay = 24 * 60 * 60
                            $0.statistics().forEach { statistic in
                                let statisticsQuantity = getStatisticsQuantity(for: statistic, with: option)
                                if let value = statisticsQuantity?.doubleValue(for: .count()) {
                                    values.append(StepCountData(date: statistic.startDate, stepCount: value))
                                    values2.append(StepCountData(date: statistic.endDate, stepCount: value))
                                }
                            }
                            stepCount = values
                            stepCount2 = values2
                        }
                    } label: {
                        Text("获取步数")
                    }
                    VStack {
                        ForEach(stepCount.indices, id: \.self) { index in
                            HStack {
                                Text("\(stepCount[index].date.formatted())")
                                Spacer()
                                Text("\(stepCount[index].stepCount)")
                            }
                        }
                        Spacer(minLength: 20)
                        ForEach(stepCount2.indices, id: \.self) { index in
                            HStack {
                                Text("\(stepCount2[index].date.formatted())")
                                Spacer()
                                Text("\(stepCount2[index].stepCount)")
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
}

#Preview {
    ContentView()
}
