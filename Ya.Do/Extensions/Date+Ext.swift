//
//  FunctionForLite.swift
//  Ya.Do
//
//  Created by msc on 13.06.2021.
//

import Foundation
import UIKit
extension Date {
    // сделать фабрику форматтеров
static func stringDateFormatter(from date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter.string(from: date)
}
}

extension Date {
    static var tomorrow: Date { return Date().dayAfter }
    var dayAfter: Date {
       return Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
    }
}
