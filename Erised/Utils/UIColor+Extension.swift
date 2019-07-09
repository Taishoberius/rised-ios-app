//
//  UIColor+Extension.swift
//  Erised
//
//  Created by David Linhares on 08/07/2019.
//  Copyright © 2019 David Linhares. All rights reserved.
//

import UIKit

extension UIColor {
    static func primaryColor() -> UIColor {
        return UIColor(red: 23/255, green: 23/255, blue: 56/255, alpha: 1)
    }

    static func secondaryColor() -> UIColor {
        return UIColor(hexString: "#B3AAC5")!
    }

    static func tertiaryColor() -> UIColor {
        return UIColor(hexString: "#EFF9F0")!
    }

    public convenience init?(hexString: String) {
        let a, r, g, b: CGFloat

        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            let hexColor = String(hexString[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    a = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    r = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    b = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            } else if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    b = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: 1.0)
                    return
                }
            }
        }

        return nil
    }
}
