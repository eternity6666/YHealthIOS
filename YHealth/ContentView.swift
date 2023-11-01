//
//  ContentView.swift
//  YHealth
//
//  Created by eternity6666 on 2023/10/11.
//

import SwiftUI
import SwiftData
import HealthKit
import Charts

struct StepCountData {
    let date: Date
    let stepCount: Double
}

struct ContentView: View {
    @State private var bloodType: HKBloodType = .notSet
    
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
                    YHKStepCountCardView()
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
