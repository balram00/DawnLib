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
        case .closed: return 120
        case .othersFeedback: return 630
        case .feedback: return 430
        case .liked:
            return 250
        case .disliked:
            return 250
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
