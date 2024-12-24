//
//  UILabel+Extension.swift
//  DawnLib
//
//  Created by bitcot on 24/12/24.
//
import UIKit

extension UILabel {
    
    func applyCustomStyle(
        fontFamily: String,
        fontSize: CGFloat,
        fontWeight: UIFont.Weight = .regular,  // New parameter for font weight
        lineHeight: CGFloat? = 0.0,
        textColorHex: UIColor? = UIColor.palette.textColor ,
        alignment: NSTextAlignment
    ) {
        // Set text alignment
        self.textAlignment = alignment
        
        // Set text color
        self.textColor = textColorHex
        
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
        
        // Set attributed text with custom line height, font, and weight
        if let text = self.text {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = (lineHeight ?? 0.0) / fontSize
            paragraphStyle.alignment = alignment
            
            self.attributedText = NSAttributedString(
                string: text,
                attributes: [
                    .font: font,
                    .paragraphStyle: paragraphStyle
                ]
            )
        }
    }
}
