//
//  UIButton+Extension.swift
//  DawnLib
//
//  Created by bitcot on 24/12/24.
//
import UIKit

extension UIButton {
    func applyCustomStyle(
        fontFamily: String,
        fontSize: CGFloat,
        fontWeight: UIFont.Weight = .regular,  // Font weight
        lineHeight: CGFloat,
        textColorHex: String,
        alignment: NSTextAlignment
    ) {
        // Set text color
        self.setTitleColor(UIColor(hex: textColorHex), for: .normal)
        
        // Set text alignment
        self.titleLabel?.textAlignment = alignment
        
        // Create font with specified weight
        let font: UIFont
        
        // If the custom font is available
        if let customFont = UIFont(name: fontFamily, size: fontSize) {
            // Apply weight by modifying the font descriptor
            let fontDescriptor = customFont.fontDescriptor
            let weightedFontDescriptor = fontDescriptor.addingAttributes([.traits: [UIFontDescriptor.TraitKey.weight: fontWeight]])
            font = UIFont(descriptor: weightedFontDescriptor, size: fontSize)
        } else {
            // Fallback to system font with specified weight
            font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        }
        
        // Set attributed title with custom line height, font, and weight
        if let title = self.title(for: .normal) {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = lineHeight / fontSize
            paragraphStyle.alignment = alignment
            
            self.setAttributedTitle(
                NSAttributedString(
                    string: title,
                    attributes: [
                        .font: font,
                        .paragraphStyle: paragraphStyle
                    ]
                ),
                for: .normal
            )
        }
    }

}
