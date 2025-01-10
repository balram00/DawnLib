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
    func animateTypewriterEffectWithMarkdownAndBullets(
        for markdownText: String,
        fontFamily: String = FontConstants.robotoRegular,
        fontSize: CGFloat = FontSize.regular.rawValue,
        fontWeight: UIFont.Weight = .regular,
        textColor: UIColor = UIColor.palette.textColor,
        bulletColor: UIColor = UIColor.primary,
        lineHeight: CGFloat = 23,
        alignment: NSTextAlignment = .left,
        typingSpeed: TimeInterval = 0.01,
        completion: @escaping (() -> Void) = {}
    ) {
        self.isUserInteractionEnabled = true // Enable interaction for links
        self.attributedText = NSAttributedString(string: "")
        
        // Parse markdown to attributed string with bullets
        let attributedText = parseMarkdownToAttributedStringWithBullets(
            markdownText: markdownText,
            fontFamily: fontFamily,
            fontSize: fontSize,
            fontWeight: fontWeight,
            textColor: textColor,
            bulletColor: bulletColor,
            lineHeight: lineHeight,
            alignment: alignment
        )
        
        var currentIndex = 0
        let characters = Array(attributedText.string)
        let typewriterTimer = Timer.scheduledTimer(withTimeInterval: typingSpeed, repeats: true) { timer in
            if currentIndex < characters.count {
                let currentSubstring = String(characters[0...currentIndex])
                
                // Create a substring of the attributed text
                let substringRange = NSRange(location: 0, length: currentSubstring.utf16.count)
                let currentAttributedSubstring = attributedText.attributedSubstring(from: substringRange)
                
                // Update the label
                self.attributedText = currentAttributedSubstring
                currentIndex += 1
            } else {
                completion()
                timer.invalidate()
            }
        }
        typewriterTimer.fire()
    }

    func parseMarkdownToAttributedStringWithBullets(
        markdownText: String,
        fontFamily: String,
        fontSize: CGFloat,
        fontWeight: UIFont.Weight,
        textColor: UIColor,
        bulletColor: UIColor,
        lineHeight: CGFloat,
        alignment: NSTextAlignment
    ) -> NSAttributedString {
        let attributedString = NSMutableAttributedString()
        
        let regexPattern = "\\[([^\\]]+)\\]\\(([^\\)]+)\\)" // Matches [text](URL)
        let regex = try? NSRegularExpression(pattern: regexPattern, options: [])
        
        let lines = markdownText.split(separator: "\n")
        for line in lines {
            var lineContent = String(line).trimmingCharacters(in: .whitespacesAndNewlines)
            let isBullet = lineContent.starts(with: "-")
            if isBullet {
                lineContent = String(lineContent.dropFirst().trimmingCharacters(in: .whitespaces)) // Remove "- "
            }
            
            // Add bullet point if it's a new line
            if isBullet {
                let bulletAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: fontSize, weight: .bold),
                    .foregroundColor: bulletColor
                ]
                let bullet = NSAttributedString(string: "● ", attributes: bulletAttributes)
                attributedString.append(bullet)
            }
            
            // Setup base attributes
            let font: UIFont
            if let customFont = UIFont(name: fontFamily, size: fontSize), fontFamily != "System" {
                font = customFont
            } else {
                font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
            }
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = alignment
            paragraphStyle.lineHeightMultiple = lineHeight / fontSize
            
            let baseAttributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: textColor,
                .paragraphStyle: paragraphStyle
            ]
            
            if let regex = regex {
                let matches = regex.matches(in: lineContent, options: [], range: NSRange(location: 0, length: lineContent.utf16.count))
                var lastIndex = lineContent.startIndex
                
                for match in matches {
                    // Append normal text before the match
                    let rangeBeforeMatch = lineContent[lastIndex..<lineContent.index(lineContent.startIndex, offsetBy: match.range.lowerBound)]
                    attributedString.append(NSAttributedString(string: String(rangeBeforeMatch), attributes: baseAttributes))
                    
                    // Extract link text and URL
                    if let textRange = Range(match.range(at: 1), in: lineContent),
                       let urlRange = Range(match.range(at: 2), in: lineContent) {
                        let linkText = String(lineContent[textRange])
                        let url = String(lineContent[urlRange])
                        
                        let linkAttributes: [NSAttributedString.Key: Any] = baseAttributes.merging([
                            .link: URL(string: url)!,
                            .foregroundColor: UIColor.primary // Link color
                        ]) { (_, new) in new }
                        
                        attributedString.append(NSAttributedString(string: linkText, attributes: linkAttributes))
                    }
                    
                    lastIndex = lineContent.index(lineContent.startIndex, offsetBy: match.range.upperBound)
                }
                
                // Append remaining text after the last match
                let rangeAfterLastMatch = lineContent[lastIndex...]
                attributedString.append(NSAttributedString(string: String(rangeAfterLastMatch), attributes: baseAttributes))
            } else {
                // Append plain text if no matches
                attributedString.append(NSAttributedString(string: lineContent, attributes: baseAttributes))
            }
            
            // Add newline at the end of each line
            attributedString.append(NSAttributedString(string: "\n"))
        }
        
        return attributedString
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
import UIKit

extension UITextView {
    
    // Function to animate typing with markdown text and apply styling
    func animateTypewriterEffectWithMarkdownAndBullets(
        markdownText: String,
        fontFamily: String = FontConstants.robotoRegular,
        fontSize: CGFloat = FontSize.regular.rawValue,
        fontWeight: UIFont.Weight = .regular,
        textColor: UIColor = UIColor { tc in
               switch tc.userInterfaceStyle {
               case .dark:
                   return .white
               default:
                   return UIColor.palette.textColor
               }
           },
        bulletColor: UIColor = UIColor { tc in
            switch tc.userInterfaceStyle {
            case .dark:
                return .white
            default:
                return .black
            }
        },
        primaryColor: UIColor = UIColor { tc in
              switch tc.userInterfaceStyle {
              case .dark:
                  return .cyan
              default:
                  return .primary
              }
          },
        lineHeight: CGFloat = 1.5,
        alignment: NSTextAlignment = .left,    // Text alignment
        typingSpeed: TimeInterval = 0.0001,   // Typing speed
        animate: Bool = true,                 // New parameter to toggle animation
        completion: @escaping (() -> Void) = {} // Completion closure
    ) {
        self.attributedText = NSAttributedString(string: "")
        
        // Parse the markdown into an attributed string with bullets and links
        let attributedText = parseMarkdownToAttributedStringWithBulletsAndLinks(
            markdownText: markdownText,
            fontFamily: fontFamily,
            fontSize: fontSize,
            fontWeight: fontWeight,
            textColor: textColor,
            bulletColor: bulletColor,
            primaryColor: primaryColor,
            lineHeight: lineHeight,
            alignment: alignment
        )
        
        // If animation is disabled, set the text immediately and call the completion closure
        guard animate else {
            self.attributedText = attributedText
            completion()
            return
        }
        
        var currentIndex = 0
        let characters = Array(attributedText.string)
        
        // Timer to animate typing effect
        let typewriterTimer = Timer.scheduledTimer(withTimeInterval: typingSpeed, repeats: true) { timer in
            if currentIndex < characters.count {
                let currentSubstring = String(characters[0...currentIndex])
                let substringRange = NSRange(location: 0, length: currentSubstring.utf16.count)
                let currentAttributedSubstring = attributedText.attributedSubstring(from: substringRange)
                self.attributedText = currentAttributedSubstring
                currentIndex += 1
            } else {
                completion()
                timer.invalidate()
            }
        }
        typewriterTimer.fire()
    }

    
    // Helper method to parse markdown text with bullets and links
    private func parseMarkdownToAttributedStringWithBulletsAndLinks(
        markdownText: String,
        fontFamily: String,
        fontSize: CGFloat,
        fontWeight: UIFont.Weight,
        textColor: UIColor,
        bulletColor: UIColor,
        primaryColor: UIColor,
        lineHeight: CGFloat,
        alignment: NSTextAlignment
    ) -> NSAttributedString {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        paragraphStyle.lineSpacing = lineHeight
        
        let bulletAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: bulletColor,
            .font: UIFont.systemFont(ofSize: 10, weight: fontWeight)
        ]
        
        let textAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: textColor,
            .font: UIFont(name: fontFamily, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: fontWeight),
            .paragraphStyle: paragraphStyle
        ]
        
        let linkAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: primaryColor, // Primary color for the link text
            .underlineStyle: NSUnderlineStyle.single.rawValue, // Underline the link text
            .font: UIFont(name: fontFamily, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: fontWeight),
            .link: "https://www.example.com" // Dummy link - actual link will be parsed later
        ]
        
        let attributedString = NSMutableAttributedString()
        
        markdownText.enumerateLines { line, _ in
            if line.starts(with: "- ") {
                let bulletPoint = "●  "
                let bulletAttributedString = NSAttributedString(string: bulletPoint, attributes: bulletAttributes)
                attributedString.append(bulletAttributedString)
                
                let trimmedLine = line.dropFirst(2)
                let textAttributedString = NSAttributedString(string: String(trimmedLine) + "\n\n", attributes: textAttributes)
                attributedString.append(textAttributedString)
            } else {
                // Detect and apply link formatting
                let regex = try! NSRegularExpression(pattern: "\\[([^)]+)\\]\\(([^)]+)\\)", options: [])
                let range = NSRange(location: 0, length: line.utf16.count)
                
                var lastRangeEnd = 0
                regex.enumerateMatches(in: line, options: [], range: range) { match, _, _ in
                    guard let matchRange = match?.range else { return }
                    
                    // Append regular text before the link
                    let normalText = (line as NSString).substring(with: NSRange(location: lastRangeEnd, length: matchRange.location - lastRangeEnd))
                    attributedString.append(NSAttributedString(string: normalText, attributes: textAttributes))
                    
                    // Extract the link text (e.g., "SelfieScreener") and add it with link style
                    if let match = match {
                        let linkTextRange = match.range(at: 1) // Text of the link
                        let linkText = (line as NSString).substring(with: linkTextRange)
                        let urlRange = match.range(at: 2) // Link URL
                        
                        let urlString = (line as NSString).substring(with: urlRange)
                        let linkAttributedString = NSAttributedString(
                            string: linkText,
                            attributes: [
                                .foregroundColor: primaryColor, // Primary color for the link text
                                .underlineStyle: NSUnderlineStyle.single.rawValue, // Underline style for the link
                                .font: UIFont(name: fontFamily, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: fontWeight), // Ensure the font is consistent

                                .link: URL(string: urlString) ?? URL(string: "https://www.example.com")! // Actual link URL
                            ]
                        )
                        attributedString.append(linkAttributedString)
                    }
                    
                    lastRangeEnd = matchRange.location + matchRange.length
                }
                
                // Append any remaining text after the last link
                let remainingText = (line as NSString).substring(from: lastRangeEnd)
                attributedString.append(NSAttributedString(string: remainingText + "\n", attributes: textAttributes))
            }
        }
        
        return attributedString
    }

}



//
//
//extension UITextView {
//    func convertMarkdownToAttributedText(
//        markdownText: String,
//        fontFamily: String = FontConstants.robotoRegular,
//        fontSize: CGFloat = FontSize.regular.rawValue,
//        fontWeight: UIFont.Weight = .regular,
//        textColor: UIColor = UIColor.palette.textColor,
//        bulletColor: UIColor = .black,
//        lineHeight: CGFloat = 1.5,
//        alignment: NSTextAlignment = .left,
//        typingSpeed: TimeInterval = 0.01,
//        completion: @escaping (() -> Void) = {}
//    ) -> NSAttributedString {
//        
//        // Prepare the paragraph style for line spacing and alignment
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.alignment = alignment
//        paragraphStyle.lineSpacing = lineHeight
//
//        // Attributes for bullet points
//        let bulletAttributes: [NSAttributedString.Key: Any] = [
//            .foregroundColor: bulletColor,
//            .font: UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
//        ]
//        
//        // Default text attributes
//        let textAttributes: [NSAttributedString.Key: Any] = [
//            .foregroundColor: textColor,
//            .font: UIFont(name: fontFamily, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: fontWeight),
//            .paragraphStyle: paragraphStyle
//        ]
//
//        // Create a mutable attributed string
//        let attributedString = NSMutableAttributedString()
//
//        // Parse the markdown text
//        markdownText.enumerateLines { line, _ in
//            // Detect bullet points
//            if line.starts(with: "- ") {
//                let bulletPoint = "● "
//                let bulletAttributedString = NSAttributedString(string: bulletPoint, attributes: bulletAttributes)
//                attributedString.append(bulletAttributedString)
//                let trimmedLine = line.dropFirst(2)
//                let textAttributedString = NSAttributedString(string: String(trimmedLine) + "\n", attributes: textAttributes)
//                attributedString.append(textAttributedString)
//            }
//            // Detect links (e.g., [text](url))
//            else if let regex = try? NSRegularExpression(pattern: "\\[([^\\]]+)\\]\\(([^\\)]+)\\)", options: .caseInsensitive) {
//                let range = NSRange(location: 0, length: line.utf16.count)
//                if let match = regex.firstMatch(in: line, options: [], range: range) {
//                    // Safely unwrap the ranges for the link text and URL
//                    guard let linkTextRange = Range(match.range(at: 1), in: line),
//                          let urlRange = Range(match.range(at: 2), in: line) else {
//                        return
//                    }
//
//                    // Extract the link text and URL as strings
//                    let linkText = String(line[linkTextRange])
//                    let urlString = String(line[urlRange])
//
//                    // Now you can create the link
//                    let url = URL(string: urlString)!
//                    
//                    let textWithLink = NSMutableAttributedString(string: linkText, attributes: textAttributes)
//                    textWithLink.addAttribute(.link, value: url, range: NSRange(location: 0, length: linkText.count))
//
//                    attributedString.append(textWithLink)
//                }
//            }
//            // Default case for plain text
//            else {
//                let textAttributedString = NSAttributedString(string: line + "\n", attributes: textAttributes)
//                attributedString.append(textAttributedString)
//            }
//        }
//
//        return attributedString
//    }
//    
//    // This is the animateTypewriterEffect method, which can be used to animate the text typing
//    func animateTypewriterEffect(
//        markdownText: String,
//        fontFamily: String = FontConstants.robotoRegular,
//        fontSize: CGFloat = FontSize.regular.rawValue,
//        fontWeight: UIFont.Weight = .regular,
//        textColor: UIColor = UIColor.palette.textColor,
//        bulletColor: UIColor = .black,
//        lineHeight: CGFloat = 1.5,
//        alignment: NSTextAlignment = .left,
//        typingSpeed: TimeInterval = 0.01,
//        completion: @escaping (() -> Void) = {}
//    ) {
//        // Convert the markdown text to normal attributed text
//        let attributedText = convertMarkdownToAttributedText(
//            markdownText: markdownText,
//            fontFamily: fontFamily,
//            fontSize: fontSize,
//            fontWeight: fontWeight,
//            textColor: textColor,
//            bulletColor: bulletColor,
//            lineHeight: lineHeight,
//            alignment: alignment
//        )
//        
//        // Create a mutable copy of the attributed text
//        self.attributedText = NSAttributedString(string: "")
//        var currentIndex = 0
//        let characters = Array(attributedText.string)
//        
//        let typewriterTimer = Timer.scheduledTimer(withTimeInterval: typingSpeed, repeats: true) { timer in
//            if currentIndex < characters.count {
//                // Append the next character to the text
//                let currentText = String(characters[0...currentIndex])
//                
//                // Create an attributed string with the current text
//                let newAttributedString = NSMutableAttributedString(string: currentText)
//                
//                // Update the label with the styled attributed string
//                self.attributedText = newAttributedString
//                
//                currentIndex += 1
//            } else {
//                // Complete animation
//                completion()
//                timer.invalidate()
//            }
//        }
//        typewriterTimer.fire()
//    }
//}
