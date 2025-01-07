////
////  ResponseTableViewCell.swift
////  Sample POC
////
////  Created by bitcot on 23/12/24.
////

import UIKit


protocol ResponseTableViewDelegate: AnyObject {
    func labelTapped(in cell: ResponseTableViewCell, tappedWord: String,at location: CGPoint)
    func animationCompleted(in cell: ResponseTableViewCell)
}

class ResponseTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: ResponseTableViewCell.self)
    weak var delegate :ResponseTableViewDelegate?
    
    @IBOutlet weak var responseTextLabel: UILabel!
    var index: IndexPath?
    var ResponseIndexDict: [Int: Bool] = [:]
    var jsonResponse: Response?


    override func awakeFromNib() {
        super.awakeFromNib()
        responseTextLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(bulletPointTapped(_:)))
        responseTextLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc func bulletPointTapped(_ sender: UITapGestureRecognizer) {
            guard let label = sender.view as? UILabel else { return }
            let tapLocation = sender.location(in: label)
            
            // Calculate the word tapped using tap location
            if let tappedWord = findWord(at: tapLocation, in: label) {
                delegate?.labelTapped(in: self, tappedWord: tappedWord, at: tapLocation)
            }
        }

        // Helper to find the word at tap location
        func findWord(at location: CGPoint, in label: UILabel) -> String? {
            guard let text = label.text else { return nil }

            // Create a layout manager and text storage
            let layoutManager = NSLayoutManager()
            let textContainer = NSTextContainer(size: label.bounds.size)
            let textStorage = NSTextStorage(string: text)
            
            textStorage.addLayoutManager(layoutManager)
            layoutManager.addTextContainer(textContainer)
            
            // Configure the text container
            textContainer.lineFragmentPadding = 0.0
            textContainer.maximumNumberOfLines = label.numberOfLines
            textContainer.lineBreakMode = label.lineBreakMode
            
            // Adjust location to account for label frame
            let labelPoint = CGPoint(x: location.x, y: location.y)
            let index = layoutManager.characterIndex(for: labelPoint, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
            
            if index < text.count {
                let wordRange = (text as NSString).rangeOfComposedCharacterSequence(at: index)
                return (text as NSString).substring(with: wordRange)
            }
            return nil
        }
    
    func configure(with textArray: [String], underlineWords: [String]) {
        ResponseIndexDict.enumerated().forEach { (index, value) in print("\(index): \(value)") }
       
        guard let row = index?.row else { return }
        
        if !ResponseIndexDict.keys.contains(row) {
               ResponseIndexDict[row] = false
           }
        
        let formattedText = textArray
            .flatMap { $0.components(separatedBy: "\n") } // Split each element by \n
            .map { "● \($0.trimmingCharacters(in: .whitespaces))" } // Add bullet points and trim whitespace
            .joined(separator: "\n\n")
        
        responseTextLabel.applyCustomStyle(
            fontFamily: FontConstants.robotoRegular,
                    fontSize: FontSize.regular.rawValue,
                    lineHeight: 23,
                    alignment: .left,
                    underlineText: underlineWords
        )

        if  ResponseIndexDict[row] == false {
              animateTypewriterEffect(for: formattedText) {
                  self.ResponseIndexDict[row] = true
//                  self.responseTextLabel.attributedText = self.convertMarkdownToAttributedText(markdownText)
              }
          } else {
              responseTextLabel.text = formattedText
          }
    }
    
    func animateTypewriterEffect(for text: String,completion: @escaping (() -> Void)) {
        responseTextLabel.text = ""
        var currentIndex = 0
        let characters = Array(text)
        self.delegate?.animationCompleted(in: self)
        
        // Set up the timer to animate the typewriter effect
        _ = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
            if currentIndex < characters.count {
                self.responseTextLabel.text?.append(characters[currentIndex])
                currentIndex += 1
            } else {
                // Invalidate the timer when the animation is complete
                completion()
                timer.invalidate()
                
            }
        }
    }

    
    func convertMarkdownToAttributedText(_ markdown: String) -> NSAttributedString {
        let markdownToHtml = markdown
            .replacingOccurrences(of: "\\n", with: "<br>")
            .replacingOccurrences(of: "- ", with: "• ")
            .replacingOccurrences(of: "[", with: "<a href='")
            .replacingOccurrences(of: "](https", with: "'>link</a>(https")
            .replacingOccurrences(of: ")", with: "")

        let htmlTemplate = """
        <style>
        body { font-family: -apple-system, Helvetica, Arial, sans-serif; font-size: 16px; }
        </style>
        <body>\(markdownToHtml)</body>
        """

        guard let data = htmlTemplate.data(using: .utf8) else { return NSAttributedString(string: markdown) }

        do {
            let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ]
            return try NSAttributedString(data: data, options: options, documentAttributes: nil)
        } catch {
            print("Error converting markdown to attributed string: \(error)")
            return NSAttributedString(string: markdown)
        }
    }

    
    func getTappedWord(at point: CGPoint) -> String? {
        guard let attributedText = responseTextLabel.attributedText else { return nil }

        let textStorage = NSTextStorage(attributedString: attributedText)
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: responseTextLabel.bounds.size)
        
        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)

        let locationOfTouchInLabel = responseTextLabel.convert(point, from: responseTextLabel.superview)
        let characterIndex = layoutManager.characterIndex(for: locationOfTouchInLabel, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)

        if characterIndex < attributedText.length {
            
            // Find the range of the word that contains the tapped character
            let text = attributedText.string as NSString
            
            // Find the range of the word by looking for whitespace or punctuation
            let wordRange = text.rangeOfCharacter(from: .whitespacesAndNewlines, options: .backwards, range: NSRange(location: 0, length: characterIndex))
            
            // Start of the word
            let startIndex = wordRange.location == NSNotFound ? 0 : wordRange.location + 1
            
            // Find the end of the word
            let endRange = text.rangeOfCharacter(from: .whitespacesAndNewlines, options: .literal, range: NSRange(location: characterIndex, length: text.length - characterIndex))
            
            let endIndex = endRange.location == NSNotFound ? text.length : endRange.location
            
            // Extract the whole word
            let word = text.substring(with: NSRange(location: startIndex, length: endIndex - startIndex))
            
            return word
        }
        return nil
    }
}
//
//import UIKit
//
//protocol ResponseTableViewDelegate: AnyObject {
//    func labelTapped(in cell: ResponseTableViewCell, tappedWord: String, at location: CGPoint)
//    func animationCompleted(in cell: ResponseTableViewCell)
//}
//
//class ResponseTableViewCell: UITableViewCell {
//
//    static let identifier = String(describing: ResponseTableViewCell.self)
//    weak var delegate: ResponseTableViewDelegate?
//
//    @IBOutlet weak var responseTextLabel: UILabel!
//    var index: IndexPath?
//    var ResponseIndexDict: [Int: Bool] = [:]
//    var jsonResponse: Response?
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        responseTextLabel.isUserInteractionEnabled = true
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(bulletPointTapped(_:)))
//        responseTextLabel.addGestureRecognizer(tapGesture)
//    }
//
//    @objc func bulletPointTapped(_ sender: UITapGestureRecognizer) {
//        guard let label = sender.view as? UILabel else { return }
//        let tapLocation = sender.location(in: label)
//
//        if let tappedWord = getTappedWord(at: tapLocation) {
//            if let url = URL(string: tappedWord), UIApplication.shared.canOpenURL(url) {
//                UIApplication.shared.open(url)
//            } else {
//                delegate?.labelTapped(in: self, tappedWord: tappedWord, at: tapLocation)
//            }
//        }
//    }
//
//    func configure(with textArray: [String], underlineWords: [String]) {
//        guard let row = index?.row else { return }
//
//        if !ResponseIndexDict.keys.contains(row) {
//            ResponseIndexDict[row] = false
//        }
//
//        let formattedText = textArray
//            .flatMap { $0.components(separatedBy: "\n") }
//            .map { "● \($0.trimmingCharacters(in: .whitespaces))" }
//            .joined(separator: "\n\n")
//
//        responseTextLabel.applyCustomStyle(
//            fontFamily: FontConstants.robotoRegular,
//            fontSize: FontSize.regular.rawValue,
//            lineHeight: 23,
//            alignment: .left,
//            underlineText: underlineWords
//        )
//
//        if ResponseIndexDict[row] == false {
////            self.ResponseIndexDict[row] = true
//
//            responseTextLabel.animateTypewriterEffect(for: formattedText, underlineWords: underlineWords) {
//                self.delegate?.animationCompleted(in: self)
////              self.displayMarkdownText() // Display markdown text after animation
//            }
//        } else {
//            responseTextLabel.text = formattedText
//        }
//    }
//
//
//
//    func displayMarkdownText() {
//        let markdownText = """
//        For improving your sleep and addressing your tiredness, you may consider the following:
//        
//        - Establish a consistent sleep schedule by going to bed and waking up at the same time each day.
//        - Create a peaceful sleep environment; keep the room dark, cool, and quiet to facilitate better rest.
//        - Limit screen time before bed to reduce blue light exposure and engage in calming activities like reading or meditation.
//        
//        For a holistic view of your sleep health and to identify risk factors, consider taking our [sleep assessment](https://www.resmed.com.au/online-sleep-assessment). Our fun AI [SelfieScreener](https://www.resmed.com.au/selfie-screener) tool can provide insights into your sleep health in just minutes. Always consult with a licensed healthcare professional for medical advice, diagnosis, and treatment options.
//        """
//
//        let attributedMarkdown = convertMarkdownToAttributedText(markdownText)
//        responseTextLabel.attributedText = attributedMarkdown
//    }
//
//    func convertMarkdownToAttributedText(_ markdown: String) -> NSAttributedString {
//        let markdownToHtml = markdown
//            .replacingOccurrences(of: "\\n", with: "<br>")
//            .replacingOccurrences(of: "- ", with: "• ")
//            .replacingOccurrences(of: "[", with: "<a href='")
//            .replacingOccurrences(of: "](https", with: "'>link</a>(https")
//            .replacingOccurrences(of: ")", with: "")
//
//        let htmlTemplate = """
//        <style>
//        body { font-family: -apple-system, Helvetica, Arial, sans-serif; font-size: 16px; }
//        </style>
//        <body>\(markdownToHtml)</body>
//        """
//
//        guard let data = htmlTemplate.data(using: .utf8) else { return NSAttributedString(string: markdown) }
//
//        do {
//            let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
//                .documentType: NSAttributedString.DocumentType.html,
//                .characterEncoding: String.Encoding.utf8.rawValue
//            ]
//            return try NSAttributedString(data: data, options: options, documentAttributes: nil)
//        } catch {
//            print("Error converting markdown to attributed string: \(error)")
//            return NSAttributedString(string: markdown)
//        }
//    }
//
//    func getTappedWord(at point: CGPoint) -> String? {
//        guard let attributedText = responseTextLabel.attributedText else { return nil }
//
//        let textStorage = NSTextStorage(attributedString: attributedText)
//        let layoutManager = NSLayoutManager()
//        let textContainer = NSTextContainer(size: responseTextLabel.bounds.size)
//        
//        textStorage.addLayoutManager(layoutManager)
//        layoutManager.addTextContainer(textContainer)
//
//        let locationOfTouchInLabel = responseTextLabel.convert(point, from: responseTextLabel.superview)
//        let characterIndex = layoutManager.characterIndex(for: locationOfTouchInLabel, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
//
//        if characterIndex < attributedText.length {
//            let text = attributedText.string as NSString
//            let wordRange = text.rangeOfCharacter(from: .whitespacesAndNewlines, options: .backwards, range: NSRange(location: 0, length: characterIndex))
//            let startIndex = wordRange.location == NSNotFound ? 0 : wordRange.location + 1
//            let endRange = text.rangeOfCharacter(from: .whitespacesAndNewlines, options: .literal, range: NSRange(location: characterIndex, length: text.length - characterIndex))
//            let endIndex = endRange.location == NSNotFound ? text.length : endRange.location
//            let word = text.substring(with: NSRange(location: startIndex, length: endIndex - startIndex))
//            return word
//        }
//        return nil
//    }
//}
