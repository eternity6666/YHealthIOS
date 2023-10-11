//
//  YHealthChatiUtils.swift
//  YHealth
//
//  Created by eternity6666 on 2023/10/11.
//

import Foundation
import HealthKit

extension HKBloodType {
    var name: String {
        switch(self) {
        case .aPositive: "A+"
        case .aNegative: "A-"
        case .bPositive: "B+"
        case .bNegative: "B-"
        case .abPositive: "AB+"
        case .abNegative: "AB-"
        case .oPositive: "O+"
        case .oNegative: "O-"
        default:"未设置"
        }
    }
}

