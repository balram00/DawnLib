//
//  Font+Extension.swift
//  DawnLib
//
//  Created by bitcot on 24/12/24.
//

import CoreFoundation
import UIKit

struct FontConstants {
    // Font Names
    static let barlowBold = "Barlow-Bold"
    static let barlowRegular = "Barlow-Regular"
    static let robotoRegular = "Roboto-Regular"
    static let robotoBold = "Roboto-Bold"
    static let arail = "Arial"
    static let robotoLight = "Roboto-Light.ttf"
    // Font Sizes
    static let titleSize: CGFloat = 20
    static let subtitleSize: CGFloat = 11
}



enum FontFamily: String {
    case roboto = "Roboto"
    case barlow = "Barlow"
    
    enum Style: String {
        case regular = "Regular"
        case bold = "Bold"
        case italic = "Italic"
    }

    func font(style: Style, size: FontSize) -> UIFont? {
        let fontName = "\(self.rawValue)-\(style.rawValue)"
        return UIFont(name: fontName, size: size.rawValue)
    }
}

enum FontSize: CGFloat,CaseIterable {
    case small = 12
    case regular = 16
    case large = 20
    case extraLarge = 24
    case header = 40
}
