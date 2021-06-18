//
//  UILabel+Ext.swift
//  Ya.Do
//
//  Created by msc on 17.06.2021.
//

import UIKit

extension UILabel {
   static func createLabel(font: UIFont, textLabel: String, textAlignment: NSTextAlignment, color: UIColor) -> UILabel {
        let label = UILabel()
        label.text = textLabel
        label.textAlignment = textAlignment
        label.font = font
        label.textColor = color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
