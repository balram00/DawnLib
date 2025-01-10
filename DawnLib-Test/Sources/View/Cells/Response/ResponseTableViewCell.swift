////
////  ResponseTableViewCell.swift
////  Sample POC
////
////  Created by bitcot on 23/12/24.
////

import UIKit

//
//protocol ResponseTableViewDelegate: AnyObject {
//    func labelTapped(in cell: ResponseTableViewCell, tappedWord: String,at location: CGPoint)
//    func animationCompleted(in cell: ResponseTableViewCell)
//}
//
//class ResponseTableViewCell: UITableViewCell {
//    
//    static let identifier = String(describing: ResponseTableViewCell.self)
//    weak var delegate :ResponseTableViewDelegate?
//    
//    @IBOutlet weak var responseTextLabel: UILabel!
//    var index: IndexPath?
//    var ResponseIndexDict: [Int: Bool] = [:]
//    var jsonResponse: Response?
//
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        responseTextLabel.isUserInteractionEnabled = true
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(bulletPointTapped(_:)))
//        responseTextLabel.addGestureRecognizer(tapGesture)
//    }
//    
//    @objc func bulletPointTapped(_ sender: UITapGestureRecognizer) {
//            guard let label = sender.view as? UILabel else { return }
//            let tapLocation = sender.location(in: label)
//            
//            // Calculate the word tapped using tap location
//            if let tappedWord = findWord(at: tapLocation, in: label) {
//                delegate?.labelTapped(in: self, tappedWord: tappedWord, at: tapLocation)
//            }
//        }
//
//        // Helper to find the word at tap location
//        func findWord(at location: CGPoint, in label: UILabel) -> String? {
//            guard let text = label.text else { return nil }
//
//            // Create a layout manager and text storage
//            let layoutManager = NSLayoutManager()
//            let textContainer = NSTextContainer(size: label.bounds.size)
//            let textStorage = NSTextStorage(string: text)
//            
//            textStorage.addLayoutManager(layoutManager)
//            layoutManager.addTextContainer(textContainer)
//            
//            // Configure the text container
//            textContainer.lineFragmentPadding = 0.0
//            textContainer.maximumNumberOfLines = label.numberOfLines
//            textContainer.lineBreakMode = label.lineBreakMode
//            
//            // Adjust location to account for label frame
//            let labelPoint = CGPoint(x: location.x, y: location.y)
//            let index = layoutManager.characterIndex(for: labelPoint, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
//            
//            if index < text.count {
//                let wordRange = (text as NSString).rangeOfComposedCharacterSequence(at: index)
//                return (text as NSString).substring(with: wordRange)
//            }
//            return nil
//        }
//    
//    func configure(with textArray: [String], underlineWords: [String]) {
//        ResponseIndexDict.enumerated().forEach { (index, value) in print("\(index): \(value)") }
//       
//        guard let row = index?.row else { return }
//        
//        if !ResponseIndexDict.keys.contains(row) {
//               ResponseIndexDict[row] = false
//           }
//        
//        let formattedText = textArray
//            .flatMap { $0.components(separatedBy: "\n") } // Split each element by \n
//            .map { "● \($0.trimmingCharacters(in: .whitespaces))" } // Add bullet points and trim whitespace
//            .joined(separator: "\n\n")
//        
//        responseTextLabel.applyCustomStyle(
//            fontFamily: FontConstants.robotoRegular,
//                    fontSize: FontSize.regular.rawValue,
//                    lineHeight: 23,
//                    alignment: .left,
//                    underlineText: underlineWords
//        )
//
//        if  ResponseIndexDict[row] == false {
//              animateTypewriterEffect(for: formattedText) {
//                  self.ResponseIndexDict[row] = true
////                  self.responseTextLabel.attributedText = self.convertMarkdownToAttributedText(markdownText)
//              }
//          } else {
//              responseTextLabel.text = formattedText
//          }
//    }
//    
//    func animateTypewriterEffect(for text: String,completion: @escaping (() -> Void)) {
//        responseTextLabel.text = ""
//        var currentIndex = 0
//        let characters = Array(text)
//        self.delegate?.animationCompleted(in: self)
//        
//        // Set up the timer to animate the typewriter effect
//        _ = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
//            if currentIndex < characters.count {
//                self.responseTextLabel.text?.append(characters[currentIndex])
//                currentIndex += 1
//            } else {
//                // Invalidate the timer when the animation is complete
//                completion()
//                timer.invalidate()
//                
//            }
//        }
//    }
//
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
//            
//            // Find the range of the word that contains the tapped character
//            let text = attributedText.string as NSString
//            
//            // Find the range of the word by looking for whitespace or punctuation
//            let wordRange = text.rangeOfCharacter(from: .whitespacesAndNewlines, options: .backwards, range: NSRange(location: 0, length: characterIndex))
//            
//            // Start of the word
//            let startIndex = wordRange.location == NSNotFound ? 0 : wordRange.location + 1
//            
//            // Find the end of the word
//            let endRange = text.rangeOfCharacter(from: .whitespacesAndNewlines, options: .literal, range: NSRange(location: characterIndex, length: text.length - characterIndex))
//            
//            let endIndex = endRange.location == NSNotFound ? text.length : endRange.location
//            
//            // Extract the whole word
//            let word = text.substring(with: NSRange(location: startIndex, length: endIndex - startIndex))
//            
//            return word
//        }
//        return nil
//    }
//}

import UIKit

protocol ResponseTableViewDelegate: AnyObject {
    func labelTapped(in cell: ResponseTableViewCell, tappedWord: String, at location: CGPoint)
    func animationCompleted(in cell: ResponseTableViewCell)
}

class ResponseTableViewCell: UITableViewCell, UITextViewDelegate {

    static let identifier = String(describing: ResponseTableViewCell.self)
    weak var delegate: ResponseTableViewDelegate?

    @IBOutlet weak var responseTextView: UITextView!
    var index: IndexPath?
    var ResponseIndexDict: [Int: Bool] = [:]
    var jsonResponse: Response?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupTextView()
        addTapGestureRecognizerToTextView()
      
    }

    
    func setupTextView() {
        responseTextView.isEditable = false
        responseTextView.isSelectable = true
        responseTextView.isUserInteractionEnabled = true
        responseTextView.isScrollEnabled = false
        responseTextView.dataDetectorTypes = [.link]
        responseTextView.delegate = self
    }

    func addTapGestureRecognizerToTextView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTextViewTap(_:)))
        tapGesture.cancelsTouchesInView = false
        responseTextView.addGestureRecognizer(tapGesture)
    }

    @objc func handleTextViewTap(_ sender: UITapGestureRecognizer) {
        guard let textView = sender.view as? UITextView else { return }
        let location = sender.location(in: textView)
        
        if let tappedWord = findWord(at: location, in: textView) {
            // Notify the delegate about the tap
            delegate?.labelTapped(in: self, tappedWord: tappedWord, at: location)
        }
    }

    func findWord(at location: CGPoint, in textView: UITextView) -> String? {
        guard let attributedText = textView.attributedText else { return nil }

        let layoutManager = textView.layoutManager
        let textContainer = textView.textContainer
        let textStorage = NSTextStorage(attributedString: attributedText)
        
        // Convert the tap location to the text container coordinates
        let locationInTextContainer = CGPoint(x: location.x - textView.textContainerInset.left,
                                              y: location.y - textView.textContainerInset.top)
        let characterIndex = layoutManager.characterIndex(for: locationInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)

        if characterIndex < attributedText.length {
            let text = attributedText.string as NSString
            let wordRange = text.rangeOfComposedCharacterSequence(at: characterIndex)
            return text.substring(with: wordRange)
        }
        return nil
    }
    
    func configure(with markdownText: [String]) {
        guard let row = index?.row else { return }
        let text = markdownText.joined(separator: "\n")

        if !ResponseIndexDict.keys.contains(row) {
               ResponseIndexDict[row] = false
           }
        
        if  ResponseIndexDict[row] == false {
            self.delegate?.animationCompleted(in: self)
          responseTextView.animateTypewriterEffectWithMarkdownAndBullets(markdownText: text,animate: true){
                self.ResponseIndexDict[row] = true
            }
          } else {
              responseTextView.animateTypewriterEffectWithMarkdownAndBullets(markdownText: text,animate: false)
          }
    }

    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        return false
    }

}


extension UITextView {
    /// Highlights specific words with a background color and adds a bottom border.
    func highlightWords(_ words: [String], withBackgroundColor color: UIColor = .systemGray, andBottomLineWithColor lineColor: UIColor = .lightGray) {
        guard let text = self.text else { return }
        
        let attributedString = NSMutableAttributedString(string: text)
        
        // Highlight specific words
        for word in words {
            let range = (text as NSString).range(of: word)
            if range.location != NSNotFound {
                attributedString.addAttribute(.backgroundColor, value: color, range: range)
            }
        }
        
        self.attributedText = attributedString
        
        // Add bottom border
        addBottomBorder(color: lineColor, height: 1.0)
    }
    
    /// Adds a bottom border to the UITextView
    private func addBottomBorder(color: UIColor, height: CGFloat) {
        let borderLayer = CALayer()
        borderLayer.backgroundColor = UIColor.palette.primaryColor.cgColor
        borderLayer.frame = CGRect(x: 0, y: self.frame.height - height, width: self.frame.width, height: height)
        
        // Remove existing borders to avoid duplicates
        self.layer.sublayers?.filter { $0.name == "BottomBorderLayer" }.forEach { $0.removeFromSuperlayer() }
        
        borderLayer.name = "BottomBorderLayer"
        self.layer.addSublayer(borderLayer)
    }
}
