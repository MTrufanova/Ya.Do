//
//  FunctionForLite.swift
//  Ya.Do
//
//  Created by msc on 13.06.2021.
//

import Foundation
import UIKit

func stringDateFormatter(from date: Date) -> String {
let formatter = DateFormatter()
formatter.dateStyle = .medium
return formatter.string(from: date)
}

let tomorrow: Date = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()

func createViewForStack() -> UIView {
    let view = UIView()
    view.backgroundColor = .white
    view.layer.cornerRadius = 16
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
}
