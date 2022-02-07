//
//  UIColor+Hex.swift
//  Currency
//
//  Created by Saffi on 2022/2/1.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1) {
        let components = (red:   CGFloat((hex >> 16) & 0xff) / 255,
                          green: CGFloat((hex >> 08) & 0xff) / 255,
                          blue:  CGFloat((hex >> 00) & 0xff) / 255)
        self.init(red: components.red, green: components.green, blue: components.blue, alpha: alpha)
    }
}
