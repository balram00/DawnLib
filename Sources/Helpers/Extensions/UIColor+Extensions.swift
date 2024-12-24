//
//  UIColor+Extensions.swift
//  Dawn
//
//  Created by bitcot on 17/12/24.
//

import Foundation
import UIKit

extension UIColor {
    // Convenience initializer to create UIColor from hex string
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    // Grouped Static Colors (refactored)
    static let palette = ColorPalette()
}

struct ColorPalette {
    // Predefined Colors
    let predefinedTextColor = UIColor(hex: "#424243")
    let predefinedBGColor = UIColor(hex: "#F5F6FA")
    let black = UIColor(hex: "#000000")
    let white = UIColor(hex: "#ffffff")
    
    // Primary Colors
    let primaryColor = UIColor(hex: "#9d2872")
    let primaryColorDisable = UIColor(hex: "#c86e9e")
    
    // Text Colors
    let textColor = UIColor(hex: "#424243")
    
    // Feedback Colors
    let feedBackBGColor = UIColor(hex: "#FFFDEF")
    let feedBackButtonColor = UIColor(hex: "#F3F8FC")
    
    // Accent Colors
    let lightBlueColor = UIColor(hex: "#0b95d3")
    let purpleColor = UIColor(hex: "#653894")
    let darkPinkColor = UIColor(hex: "#ae285f")
    
}
