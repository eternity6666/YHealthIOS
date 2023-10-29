//
//  YDateExtension.swift
//  YHealth
//
//  Created by eternity6666 on 2023/10/29.
//

import Foundation

extension Date {
    func zeroTime() -> Date {
        let calendar = Calendar.init(identifier: .chinese)
        let components = calendar.dateComponents([.year, .month, .day], from: self)
        return calendar.date(from: components) ?? self
    }
}
