//
//  Images.swift
//  Ya.Do
//
//  Created by msc on 19.06.2021.
//

import UIKit

private let largeConfig = UIImage.SymbolConfiguration(textStyle: .title2)
private let boldConfig = UIImage.SymbolConfiguration(weight: .bold)

enum Images {
    static let plus = UIImage(systemName: "plus.circle.fill")
    static let circle = UIImage(systemName: "circle", withConfiguration: largeConfig)
    static let fillCircle = UIImage(systemName: "checkmark.circle.fill", withConfiguration: largeConfig)
    static let arrowImage = UIImage(systemName: "arrow.down", withConfiguration: boldConfig)?.withTintColor(Colors.grayArrow ?? .clear, renderingMode: .alwaysOriginal)
    static let markImage = UIImage(systemName: "exclamationmark.2", withConfiguration: boldConfig)?.withTintColor(Colors.red ?? .clear, renderingMode: .alwaysOriginal)
    static let calendar = UIImage(systemName: "calendar")
    static let trash = UIImage(systemName: "trash.fill")
}
