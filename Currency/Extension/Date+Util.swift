//
//  Date+Util.swift
//  Currency
//
//  Created by Saffi on 2022/1/28.
//

import Foundation

enum DateFormat: String {
    case yyyyMMdd = "yyyy-MM-dd"
    case Md = "M/d"
}

extension String  {

    func toDate(format: DateFormat) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        return formatter.date(from: self) ?? Date()
    }
}

extension Date {

    func toString(format: DateFormat) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        return formatter.string(from: self)
    }

    // MARK: Calculate
    func lastWeek() -> Date {
        return Calendar.current.date(byAdding: .day, value: -7, to: self) ?? self
    }

    func lastMonth() -> Date {
        return Calendar.current.date(byAdding: .month, value: -1, to: self) ?? self
    }

    func yesterday() -> Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self) ?? self
    }

    func tomorrow() -> Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self) ?? self
    }
}
