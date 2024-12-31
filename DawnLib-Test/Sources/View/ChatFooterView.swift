//
//  ChatFooterView.swift
//  DawnLib-Test
//
//  Created by bitcot on 30/12/24.
//

import UIKit

class ChatFooterView: UIView {
    
    static let identifier = String(describing: ChatHeaderCell.self)
    @IBOutlet weak var footerTextLabel: UILabel!
    
    
    override func awakeFromNib() {
           super.awakeFromNib()
        configure(with: "Answer may display inaccuracy, please always consult a medical professional for advice. Here are some other Things you should know about Dawn.", underlinedText: "Things you should know about Dawn")
       }
    
    class func load(frame: CGRect) -> ChatFooterView {
        let view = Bundle.main.loadNibNamed("ChatFooterView", owner: self, options: nil)?.first as! ChatFooterView
        view.frame = frame
        return view
    }

    func configure(with text: String, underlinedText: String) {
        guard let footerTextLabel = footerTextLabel else {
            print("Error: footerTextLabel is nil")
            return
        }
        
        // Split the text by period and add a new line after each sentence.
        let textWithNewLines = text.split(separator: ".").map { $0 + "." }.joined(separator: "\n")
        
        // Create the attributed string
        let attributedString = NSMutableAttributedString(string: textWithNewLines)
        
        // Find the range of the text to underline
        if let range = text.range(of: underlinedText) {
            let nsRange = NSRange(range, in: text)
            
            // Add underline attribute to the specified range
            attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: nsRange)
        }
        
        // Update the label's attributed text on the main thread
        DispatchQueue.main.async {
            footerTextLabel.attributedText = attributedString
        }
    }
}



 




