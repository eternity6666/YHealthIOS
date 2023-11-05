//
//  YHKDateSelectorView.swift
//  YHealth
//
//  Created by eternity6666 on 2023/11/4.
//

import SwiftUI

struct YHKDateSelectorView: View {
    @Binding var startDate: Date
    @Binding var endDate: Date
    var onDateChange: () -> Void = {}
    
    var body: some View {
        HStack {
            leftButton()
            Spacer()
            centerText
            Spacer()
            rightButton()
        }
    }
    
    @ViewBuilder
    private func leftButton() -> some View {
        Image(systemName: "chevron.left.2")
            .onTapGesture {
                addDay(day: -7)
            }
        Image(systemName: "chevron.left")
            .onTapGesture {
                addDay(day: -1)
            }
    }
    
    private var centerText: some View {
        if let startYear = startDate.year,
           let endYear = endDate.year,
           let startMonth = startDate.month,
           let endMonth = endDate.month,
           let startDay = startDate.day,
           let endDay = endDate.day {
            let text = showText(
                startYear: startYear, startMonth: startMonth, startDay: startDay,
                endYear: endYear, endMonth: endMonth, endDay: endDay
            )
            return AnyView(Text(text))
        } else {
            return AnyView(EmptyView())
        }
    }
    
    @ViewBuilder
    private func rightButton() -> some View {
        Image(systemName: "chevron.right")
            .onTapGesture {
                addDay(day: 1)
            }
        Image(systemName: "chevron.right.2")
            .onTapGesture {
                addDay(day: 7)
            }
    }
    
    private func addDay(day: Int = 1) {
        let timeIntervalValue = Double(day) * TimeInterval.day.magnitude
        let addDayInterval = TimeInterval(timeIntervalValue)
        self.startDate = startDate.addingTimeInterval(addDayInterval)
        self.endDate = endDate.addingTimeInterval(addDayInterval)
        self.onDateChange()
    }
    
    private func showText(
        startYear: Int, startMonth: Int, startDay: Int,
        endYear: Int, endMonth: Int, endDay: Int
    ) -> String {
        var text = ""
        if (startYear == endYear) {
            text = "\(startYear.description)"
            if (startMonth == endMonth && startDay == endDay) {
                text = text + "年\(startMonth.description)月\(startDay.description)日"
            } else {
                let startDateStr = "\(startMonth.description)/\(startDay.description)"
                let endDateStr = "\(endMonth.description)/\(endDay.description)"
                text = text + " \(startDateStr)-\(endDateStr)"
            }
        } else {
            let startDateStr = "\(startYear.description)/\(startMonth.description)/\(startDay.description)"
            let endDateStr = "\(endYear.description)/\(endMonth.description)/\(endDay.description)"
            text = text + "\(startDateStr) - \(endDateStr)"
        }
        return text
    }
}

private struct YHKDateSelectorViewPreview: View {
    @State private var startDate: Date
    @State private var endDate: Date
    
    init(
        startDate: Foundation.Date = Date.now,
        endDate: Foundation.Date = Date.now
    ) {
        var tmpEndDate = endDate
        for _ in 0...30 {
            tmpEndDate = tmpEndDate.addingTimeInterval(TimeInterval.day)
        }
        _startDate = .init(initialValue: startDate)
        _endDate = .init(initialValue: tmpEndDate)
    }
    
    var body: some View {
        
        return YHKDateSelectorView(
            startDate: .init(get: {startDate}, set: {startDate = $0}),
            endDate: .init(get: {endDate}, set: {endDate = $0})
        )
    }
}
#Preview {
    YHKDateSelectorViewPreview()
}
