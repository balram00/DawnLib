import UIKit
extension  UILabel {
    func applyCustomStyle(
        fontFamily: String = "System",
        fontSize: CGFloat = 14.0,
        fontWeight: UIFont.Weight = .regular,
        lineHeight: CGFloat? = nil,
        textColorHex: UIColor? = UIColor.palette.textColor,
        alignment: NSTextAlignment = .left,
        underlineText: [String] = [],
        links: [(String, String)] = [] // Accepts a list of tuples (text, url) for links
    ) {
        guard let text = self.text else {
            print("No text available to style.")
            return
        }

        // Normalize text and prepare underline words
        let normalizedUnderlineText = underlineText.map { $0.lowercased().trimmingCharacters(in: .whitespaces) }

        // Set up the font and paragraph style
        let font: UIFont
        if let customFont = UIFont(name: fontFamily, size: fontSize), fontFamily != "System" {
            font = customFont
        } else {
            font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        }

        let paragraphStyle = NSMutableParagraphStyle()
        if let lineHeight = lineHeight {
            paragraphStyle.lineHeightMultiple = lineHeight / fontSize
        }
        paragraphStyle.alignment = alignment

        // Create a mutable attributed string for the text
        let attributedString = NSMutableAttributedString(string: text)
        let fullRange = NSRange(location: 0, length: text.utf16.count)

        // Apply base text attributes (font, paragraph style, color)
        attributedString.addAttributes([
            .font: font,
            .paragraphStyle: paragraphStyle,
            .foregroundColor: textColorHex ?? UIColor.palette.textColor
        ], range: fullRange)

        // Loop through the words to underline
        for word in normalizedUnderlineText {
            // Use regex for case-insensitive and exact match
            let regexPattern = "\\b\(NSRegularExpression.escapedPattern(for: word))\\b" // Match whole words
            if let regex = try? NSRegularExpression(pattern: regexPattern, options: [.caseInsensitive]) {
                let matches = regex.matches(in: text, options: [], range: fullRange)
                for match in matches {
                    // Apply underline to the matched range
                    attributedString.addAttributes([
                        .underlineStyle: NSUnderlineStyle.single.rawValue,  // Underline style
                        .foregroundColor: UIColor.primary // Change this color if needed
                    ], range: match.range)
                    print("Underlining word: '\(word)' at range: \(match.range)")
                }
            } else {
                print("Invalid regex pattern for word: '\(word)'")
            }
        }

        // Loop through the links and add clickable links
        for (linkText, urlString) in links {
            let nsRange = (text as NSString).range(of: linkText)
            
            if nsRange.location != NSNotFound {
                // Add link attribute to the detected link text
                attributedString.addAttribute(.link, value: urlString, range: nsRange)
                print("Added link: '\(linkText)' with URL: \(urlString) at range: \(nsRange)")
            } else {
                print("Link text not found: '\(linkText)'")
            }
        }

        // Set the attributed string with styles applied to the label or text view
        self.attributedText = attributedString
    }
    
    func animateTypewriterEffect(
        for text: String,
        fontFamily: String = FontConstants.robotoRegular,
        fontSize: CGFloat = FontSize.regular.rawValue,
        fontWeight: UIFont.Weight = .regular,
        textColor: UIColor = UIColor.palette.textColor,
        underlineWords: [String] = [],
        lineHeight: CGFloat = 23,
        alignment: NSTextAlignment = .left,
        typingSpeed: TimeInterval = 0.01,
        completion: @escaping (() -> Void) = {}
    ) {
        self.attributedText = NSAttributedString(string: "")
        var currentIndex = 0
        let characters = Array(text)
        let underlineWordsLowercased = underlineWords.map { $0.lowercased().trimmingCharacters(in: .whitespaces) }

        // Setup font
        let font: UIFont
        if let customFont = UIFont(name: fontFamily, size: fontSize), fontFamily != "System" {
            font = customFont
        } else {
            font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        }

        // Setup paragraph style
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        paragraphStyle.lineHeightMultiple = lineHeight / fontSize

        let typewriterTimer = Timer.scheduledTimer(withTimeInterval: typingSpeed, repeats: true) { timer in
            if currentIndex < characters.count {
                // Append the next character to the text
                let currentText = String(characters[0...currentIndex])

                // Create an attributed string with the current text
                let attributedString = NSMutableAttributedString(string: currentText)

                // Apply base attributes (font, color, paragraph style)
                let baseAttributes: [NSAttributedString.Key: Any] = [
                    .font: font,
                    .foregroundColor: textColor,
                    .paragraphStyle: paragraphStyle
                ]
                attributedString.addAttributes(baseAttributes, range: NSRange(location: 0, length: currentText.utf16.count))

                // Loop through the words to underline
                for word in underlineWordsLowercased {
                    let regexPattern = "\\b\(NSRegularExpression.escapedPattern(for: word))\\b" // Match whole words
                    if let regex = try? NSRegularExpression(pattern: regexPattern, options: [.caseInsensitive]) {
                        let matches = regex.matches(in: currentText, options: [], range: NSRange(location: 0, length: currentText.utf16.count))
                        for match in matches {
                            // Apply underline and primary color only to the matched word
                            attributedString.addAttributes([
                                .underlineStyle: NSUnderlineStyle.single.rawValue,
                                .foregroundColor: UIColor.primary // Apply primary color for the underlined text
                            ], range: match.range)
                        }
                    }
                }

                // Update the label with the styled attributed string
                self.attributedText = attributedString

                currentIndex += 1
            } else {
                // Complete animation
                completion()
                timer.invalidate()
            }
        }
        typewriterTimer.fire()
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
    
    func configureFooterText(
           text: String? = "Answer may display inaccuracy, please always consult a medical professional for advice. Here are some other Things you should know about Dawn.",
           underlinedText: String? = "Things you should know about Dawn",
           fontFamily: String,
           fontSize: CGFloat,
           lineHeight: CGFloat,
           alignment: NSTextAlignment
       ) {
           // Add new lines after periods
           let textWithNewLines = text?.split(separator: ".").map { $0 + "." }.joined(separator: "\n") ?? ""
           
           // Create attributed string
           let attributedString = NSMutableAttributedString(string: textWithNewLines)
           
           // Underline the specified part of the text
           if let range = textWithNewLines.range(of: underlinedText ?? "") {
               let nsRange = NSRange(range, in: textWithNewLines)
               attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: nsRange)
           }
           
           // Apply custom font, line height, and alignment
           let paragraphStyle = NSMutableParagraphStyle()
           paragraphStyle.lineSpacing = lineHeight - fontSize
           paragraphStyle.alignment = alignment
           
           attributedString.addAttributes([
               .font: UIFont(name: fontFamily, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize),
               .paragraphStyle: paragraphStyle
           ], range: NSRange(location: 0, length: textWithNewLines.count))
           
           // Set the label's attributed text
           self.attributedText = attributedString
       }
    
}

