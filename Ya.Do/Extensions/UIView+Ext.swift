//
//  UIView+Ext.swift
//  Ya.Do
//
//  Created by msc on 19.06.2021.
//

import UIKit

extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
            clipsToBounds = true
            layer.cornerRadius = radius
            layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
    }
}
