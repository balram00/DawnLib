//
//  ResponseTableViewCell.swift
//  Sample POC
//
//  Created by bitcot on 23/12/24.
//

import UIKit


protocol ResponseTableViewDelegate: AnyObject {
    func labelTapped(in cell: ResponseTableViewCell, tappedWord: String,at location: CGPoint)
}

class ResponseTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: ResponseTableViewCell.self)
    weak var delegate :ResponseTableViewDelegate?
    
    @IBOutlet weak var responseTextLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        responseTextLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
        responseTextLabel.addGestureRecognizer(tapGesture)
    }
    
    
    @objc func labelTapped(_ sender: UITapGestureRecognizer) {
        // You can use this method to handle the tap event
        print("Label tapped!")
        
        let location = sender.location(in: responseTextLabel)
            
        if let tappedWord = getTappedWord(at: location) {
                print("Tapped word: \(tappedWord)")

            print(tappedWord)
            
            let location = sender.location(in: self)
            delegate?.labelTapped(in: self, tappedWord: tappedWord, at: location)
        }
    }
    
    func vgjhb(view:PopupView) {
        let popupView = view
        self.addSubview(popupView)
    }

    
    func configure(with textArray: [String], underlineWords: [String],boldWords: [String]) {

        // Add bullet points and spacing
        let formattedText = textArray
            .flatMap { $0.components(separatedBy: "\n") } // Split each element by \n
            .map { "• \($0.trimmingCharacters(in: .whitespaces))" } // Add bullet points and trim whitespace
            .joined(separator: "\n\n")
        
        // Assuming `formattedText` is your Markdown text
        responseTextLabel.text = formattedText
        responseTextLabel.applyCustomStyle(
            fontFamily: FontConstants.robotoLight,
                    fontSize: FontSize.regular.rawValue,
                    lineHeight: 23,
                    alignment: .left,
                    underlineText: underlineWords,
                    boldPoints: []
        )
        
//        responseTextLabel.attributedText = convertMarkdownToAttributedString(formattedText)

    }
    
    func getTappedWord(at point: CGPoint) -> String? {
        guard let attributedText = responseTextLabel.attributedText else { return nil }

        let textStorage = NSTextStorage(attributedString: attributedText)
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: responseTextLabel.bounds.size)
        
        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)

        // Convert the tapped point to the label's coordinate system
        let locationOfTouchInLabel = responseTextLabel.convert(point, from: responseTextLabel.superview)
        
        // Find the character index at the tapped point
        let characterIndex = layoutManager.characterIndex(for: locationOfTouchInLabel, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)

        // Make sure the character index is valid
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
