//
//  YDateExtension.swift
//  YHealth
//
//  Created by eternity6666 on 2023/10/29.
//

import Foundation

extension Date {
    private var dateComponents: DateComponents {
        return Calendar.current.dateComponents(in: .current, from: self)
    }
    
    var year: Int? {
        return dateComponents.year
    }
    
    var month: Int? {
        return dateComponents.month
    }
    
    var day: Int? {
        return dateComponents.day
    }
    
    func zeroTime() -> Date {
        let calendar = Calendar.init(identifier: .chinese)
        let components = calendar.dateComponents([.year, .month, .day], from: self)
        return calendar.date(from: components) ?? self
    }
}
