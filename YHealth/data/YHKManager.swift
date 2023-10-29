//
//  YHealthDataManager.swift
//  YHealth
//
//  Created by eternity6666 on 2023/10/11.
//

import Foundation
import HealthKit

class YHKManager {
    static let shared = YHKManager()
    
    let store = HKHealthStore()
    
    private init() {
        
    }
    
    func requestAuth() {
        var shareSet: [HKSampleType] = []
        var readSet: [HKObjectType] = []
        readSet.append(HKCharacteristicType.init(.bloodType))
        readSet.append(HKQuantityType.init(.stepCount))
        store.requestAuthorization(toShare: Set(shareSet), read: Set(readSet)) { isSuccess, error in
            if let error = error {
                print("\(error)")
            }
            if (isSuccess) {
                print("success")
            } else {
                print("not success")
            }
        }
    }
    
    func fetchBloodType() -> HKBloodType {
        do {
            let bloodType = try store.bloodType().bloodType
            return bloodType
        } catch let error {
            print("\(error)")
        }
        return .notSet
    }
    
    func fetchStepCount(block: @escaping (HKStatisticsCollection) -> Void) {
        let query = HKStatisticsCollectionQuery.init(
            quantityType: HKQuantityType.init(.stepCount),
            quantitySamplePredicate: nil,
            anchorDate: Date.now.zeroTime(),
            intervalComponents: DateComponents(day: 1)
        )
        query.initialResultsHandler = { query, results, error in
            if let collection = results {
                block(collection)
            }
        }
        store.execute(query)
    }
}
