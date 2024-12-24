//
//  ChatItem.swift
//  DawnLib
//
//  Created by bitcot on 24/12/24.
//

import Foundation

enum ChatItemType {
    case question(String)
    case answer(String)
    case bulletPoints(points: [String], underlineWords: [String])
    case loader
    case feedback
}

struct ChatItem {
    let type: ChatItemType
}
