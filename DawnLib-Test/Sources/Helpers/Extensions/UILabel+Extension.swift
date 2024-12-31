import UIKit
extension  UILabel {

    func applyCustomStyle(
        fontFamily: String = "System",
        fontSize: CGFloat = 14.0,
        fontWeight: UIFont.Weight = .regular,
        lineHeight: CGFloat? = nil,
        textColorHex: UIColor? = UIColor.black,
        alignment: NSTextAlignment = .left,
        underlineText: [String] = [],
        boldPoints: [String] = []
    ) {
        self.textAlignment = alignment
        self.textColor = textColorHex ?? UIColor.black
        
        // Configure font
        let font: UIFont
        if let customFont = UIFont(name: fontFamily, size: fontSize), fontFamily != "System" {
            let fontDescriptor = customFont.fontDescriptor
            let weightedFontDescriptor = fontDescriptor.addingAttributes([
                .traits: [UIFontDescriptor.TraitKey.weight: fontWeight]
            ])
            font = UIFont(descriptor: weightedFontDescriptor, size: fontSize)
        } else {
            font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        }
        
        if let text = self.text {
            // Configure paragraph style
            let paragraphStyle = NSMutableParagraphStyle()
            if let lineHeight = lineHeight {
                paragraphStyle.lineHeightMultiple = lineHeight / fontSize
            }
            paragraphStyle.alignment = alignment
            
            // Create attributed string
            let attributedString = NSMutableAttributedString(string: text)
            let fullRange = NSRange(location: 0, length: text.count)
            
            // Apply base attributes
            attributedString.addAttributes([
                .font: font,
                .paragraphStyle: paragraphStyle,
                .foregroundColor: textColorHex ?? UIColor.black
            ], range: fullRange)
            
            // Apply underline style
            for word in underlineText {
                let wordRange = (text as NSString).range(of: word)
                if wordRange.location != NSNotFound {
                    attributedString.addAttributes([
                        .underlineStyle: NSUnderlineStyle.single.rawValue,
                        .foregroundColor: UIColor.primary // Example color
                    ], range: wordRange)
                }
            }
            // Set the attributed string to the label
            self.attributedText = attributedString
        }
    }

    
    func addGradientLineToWord(_ wordRange: NSRange, text: String) {
        // Create a gradient layer
        let gradientLayer = CAGradientLayer()
        
        // Set gradient colors
        gradientLayer.colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        // Use layout manager to accurately calculate the position of the word in the label
        guard let textStorage = self.attributedText else { return }
        
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize(width: self.frame.width, height: CGFloat.greatestFiniteMagnitude))
        let textStorageForLayout = NSTextStorage(attributedString: textStorage)
        layoutManager.addTextContainer(textContainer)
        textStorageForLayout.addLayoutManager(layoutManager)
        
        // Get the position of the word in the text container
        let range = (text as NSString).range(of: text)
        let boundingRect = layoutManager.boundingRect(forGlyphRange: wordRange, in: textContainer)
        
        // Adjusting position to account for any padding or offsets
        let padding: CGFloat = 2.0  // Padding beneath the word
        let gradientFrame = CGRect(
            x: boundingRect.origin.x,
            y: boundingRect.origin.y + boundingRect.size.height + padding,
            width: boundingRect.size.width,
            height: 2)  // Height of the gradient line
        
        // Remove any previous gradient layers
        self.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        
        // Set the gradient layer frame and add to the label's layer
        gradientLayer.frame = gradientFrame
        self.layer.addSublayer(gradientLayer)
    }
    
}

