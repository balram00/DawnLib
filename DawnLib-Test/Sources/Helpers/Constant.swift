//
//  Constants.swift
//  DawnLib-Test
//
//  Created by bitcot on 30/12/24.
//

import Foundation
import UIKit

enum FeedbackType: CaseIterable {
    case closed
    case othersFeedback
    case feedback
    case liked
    case disliked
    var height: CGFloat {
        switch self {
        case .closed: return 80.0
        case .othersFeedback: return 630.0
        case .feedback: return 430.0
        case .liked:
            return 150.0
        case .disliked:
            return 150.0
        }
    }
}

enum ButtonState {
    case like
    case dislike
}

struct ConstantImage {
    static let likeWhite = UIImage(named: "likeWhite")
    static let likeBlack = UIImage(named: "likeBlack")
    static let dislikeWhite = UIImage(named: "disLikeWhite")
    static let dislikeBlack = UIImage(named: "disLikeBlack")
}

func convertMarkdownToAttributedString(_ markdown: String) -> NSAttributedString {
    let boldPattern = "\\*\\*(.*?)\\*\\*" // Matches **bold** text
    let italicPattern = "\\*(.*?)\\*"    // Matches *italic* text
    
    let attributedString = NSMutableAttributedString(string: markdown)
    
    // Bold parsing
    if let boldRegex = try? NSRegularExpression(pattern: boldPattern, options: .dotMatchesLineSeparators) {
        let matches = boldRegex.matches(in: markdown, options: [], range: NSRange(location: 0, length: markdown.count))
        for match in matches {
            attributedString.addAttributes([.font: UIFont.boldSystemFont(ofSize: 14)], range: match.range(at: 1))
        }
    }
    
    // Italic parsing
    if let italicRegex = try? NSRegularExpression(pattern: italicPattern, options: .dotMatchesLineSeparators) {
        let matches = italicRegex.matches(in: markdown, options: [], range: NSRange(location: 0, length: markdown.count))
        for match in matches {
            attributedString.addAttributes([.font: UIFont.italicSystemFont(ofSize: 14)], range: match.range(at: 1))
        }
    }
    
    return attributedString
}


enum FooterText {
    static let description = "Answer may display inaccuracy, please always consult a medical professional for advice. Here are some other Things you should know about Dawn."
    static let underlinedText = "Things you should know about Dawn"
}

enum ButtonTitles {
    static let doneButtonTitle = "Done"
}

enum PlaceholderText {
    static let askAQuestionPlaceholder = "Ask a question here"
}

enum PopupMessages {
    static let passwordCreationMessage = "Once you have created a new password, return to the myAir app and enter it on the Sign in to myAir screen. For assistance with myAir, please contact our support team."
}

enum StoryboardConstants {
    static let mainStoryboardName = "Main"
    static let chatViewControllerIdentifier = "ChatViewController"
}
