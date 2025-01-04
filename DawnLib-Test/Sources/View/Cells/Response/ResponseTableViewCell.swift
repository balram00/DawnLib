//
//  ResponseTableViewCell.swift
//  Sample POC
//
//  Created by bitcot on 23/12/24.
//

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
        // Add bullet points and spacing
        print("ResponseIndexDict count",self.ResponseIndexDict.count)
        ResponseIndexDict.enumerated().forEach { (index, value) in print("\(index): \(value)") }
       
        guard let row = index?.row else { return }
//
        if !ResponseIndexDict.keys.contains(row) {
               ResponseIndexDict[row] = false // Set default state
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
                  // Mark as animated once the animation is complete
                  self.ResponseIndexDict[row] = true
                  print("ResponseIndexDict count",self.ResponseIndexDict.count)
                  print("ResponseIndexDict index",row)
              }
          } else {
              responseTextLabel.text = formattedText // Directly set the text
          }
    }
    

    func animateTypewriterEffect(for text: String,completion: @escaping (() -> Void)) {
        responseTextLabel.text = ""
            var currentIndex = 0
            let characters = Array(text)
        self.delegate?.animationCompleted(in: self)
        _ = Timer.scheduledTimer(withTimeInterval: 0.004, repeats: true) { timer in
                if currentIndex < characters.count {
                    // Append the next character to the label
                    self.responseTextLabel.text?.append(characters[currentIndex])
                    currentIndex += 1
                    completion()
                } else {
                    // Invalidate the timer when the animation is complete
                    completion()
                    timer.invalidate()
                }
            }
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
