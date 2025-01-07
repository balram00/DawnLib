import UIKit

class ChatFooterView: UIView {
    
    // MARK: - Properties
    @IBOutlet weak var footerTextLabel: UILabel!

    // MARK: - Load Method
    class func load(frame: CGRect) -> ChatFooterView {
        let nib = UINib(nibName: "ChatFooterView", bundle: nil)
        guard let view = nib.instantiate(withOwner: nil, options: nil).first as? ChatFooterView else {
            fatalError("Failed to load ChatFooterView from nib")
        }
        view.frame = frame
        return view
    }

    // MARK: - Configure Method
    func configure(
        with text: String? = "Answer may display inaccuracy, please always consult a medical professional for advice. Here are some other Things you should know about Dawn.",
        underlinedText: String? = "Things you should know about Dawn"
    ) {
        guard let footerTextLabel = footerTextLabel else {
            print("Error: footerTextLabel is nil")
            return
        }
        
        // Add new lines after periods
        let textWithNewLines = text?.split(separator: ".").map { $0 + "." }.joined(separator: "\n") ?? ""
        
        // Create attributed string
        let attributedString = NSMutableAttributedString(string: textWithNewLines)
        
        // Underline the specified part of the text
        if let range = text?.range(of: underlinedText ?? "") {
            let nsRange = NSRange(range, in: text ?? "")
            attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: nsRange)
        }
        
        // Update label's attributed text
        DispatchQueue.main.async {
            footerTextLabel.attributedText = attributedString
        }
    }
}
