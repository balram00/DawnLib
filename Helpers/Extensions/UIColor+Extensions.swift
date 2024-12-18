//
//  UIColor+Extensions.swift
//  Dawn
//
//  Created by bitcot on 17/12/24.
//

import Foundation
import UIKit

extension UIColor {
    
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
    
    static let predefinedTextColor = UIColor(hex: "#424243")
    static let predefinedBGColor = UIColor(hex: "#F5F6FA")
    static let black = UIColor(hex: "#000000")
    static let white = UIColor(hex: "#ffffff")
    static let primaryColor = UIColor(hex: "#9d2872")
    static let primaryColorDisable = UIColor(hex: "#c86e9e")
    static let textColor = UIColor(hex: "#000000")
    
}
