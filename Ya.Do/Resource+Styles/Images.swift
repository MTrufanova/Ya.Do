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
   static let arrowImage = UIImage(systemName: "arrow.down", withConfiguration: boldConfig)?.withTintColor(#colorLiteral(red: 0.5568627451, green: 0.5568627451, blue: 0.5764705882, alpha: 1), renderingMode: .alwaysOriginal)
   static let markImage = UIImage(systemName: "exclamationmark.2", withConfiguration: boldConfig)?.withTintColor(UIColor(named: "redTitle") ?? UIColor(), renderingMode: .alwaysOriginal)
}
