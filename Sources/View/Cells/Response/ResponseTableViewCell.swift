//
//  ResponseTableViewCell.swift
//  Sample POC
//
//  Created by bitcot on 23/12/24.
//

import UIKit

class ResponseTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: ResponseTableViewCell.self)
    
    @IBOutlet weak var responseTextLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with textArray: [String], underlineWords: [String]) {
        let formattedText = NSMutableAttributedString()
        
        for text in textArray {
            let bullet = "• " // Bullet point
            let bulletPointText = "\(bullet)\(text)\n"
            
            let attributedString = NSMutableAttributedString(string: bulletPointText)
            
            // Apply default font and style to the entire string
            let fullRange = NSRange(location: 0, length: bulletPointText.count)
            attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 14), range: fullRange)
            
            // Underline specific words if found
            for word in underlineWords {
                // Search for word in bulletPointText, consider case sensitivity if needed
                let range = (bulletPointText as NSString).range(of: word)
                
                if range.location != NSNotFound {
                    // Apply underline and color attributes to the found word
                    attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
                    attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: range) // Optional: color the underlined word
                }
            }
            
            // Append the formatted attributed string to the final formattedText
            formattedText.append(attributedString)
        }
        
        // Set the formatted text to the UILabel
        responseTextLabel.attributedText = formattedText
        
        // Apply custom style to the label
        responseTextLabel.applyCustomStyle(
            fontFamily: FontConstants.robotoRegular,
            fontSize: 16,
            lineHeight: 23,
            alignment: .left
        )
    }


}
