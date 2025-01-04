//
//  ChatItem.swift
//  DawnLib
//
//  Created by bitcot on 24/12/24.
//

import Foundation

enum ChatItemType: String, Equatable, Codable {
    case question
    case answer
    case bulletPoints
    case loader
    case feedback
    case unknown
    case empty

    // Custom decoding to handle unexpected values
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let typeString = try container.decode(String.self)
        
        // Use a known case or fallback to unknown if the value doesn't match
        self = ChatItemType(rawValue: typeString) ?? .unknown
    }
}


//enum ChatItemType: String, Equatable, Codable {
//    case question
//    case answer
//    case bulletPoints
//    case loader
//    case feedback
//}


//enum ChatItemType: Equatable,Codable {
//    case question(String)
//    case answer(String)
//    case bulletPoints(points: [String], underlineWords: [String],boldWords: [String])
//    case loader
//    case feedback
//}

struct ChatItem {
    let type: ChatItemType
}


struct Message: Codable {
    let text: [String]?
    let underLineText: [String]?
    var related_questions:[RelatedQuestion]?
}

struct ResponseDetails: Codable {
    let message: Message?
    let conversation_id: String?
    let message_id: String?
    let conversation_display_id: Int?
    let in_chat_answer_keyword_definition_pair: [String: String]?
    let e2e_links_keyword_definition_pair: [String: String]?
    let exclusion_probing_questions: [String: String]?
    
    private enum CodingKeys: String, CodingKey {
        case message
        case conversation_id
        case message_id
        case conversation_display_id
        case in_chat_answer_keyword_definition_pair
        case e2e_links_keyword_definition_pair
        case exclusion_probing_questions
    }
}

struct Response: Codable {
    let user_id: String?
    var question: String?
    let text: String?
    let fallback: Bool?
    let origin_name: String?
    let pre_defined: Bool?
    let conversation_id: String?
    var message: MessageLog?
    var response: ResponseDetails?
    let message_log: [MessageLog]?
    let hash: String?
    let timestamp: Date?
    let type: ChatItemType?
    let bulletPoints: [String]?
    let underlineWords: [String]?

    // Full initializer where everything is optional
    init(user_id: String? = nil, question: String? = nil, text: String? = nil, fallback: Bool? = nil, origin_name: String? = nil, pre_defined: Bool? = nil, conversation_id: String? = nil, message: MessageLog? = nil, response: ResponseDetails? = nil, message_log: [MessageLog]? = nil, hash: String? = nil, timestamp: Date? = nil, type: ChatItemType? = nil, bulletPoints: [String]? = nil, underlineWords: [String]? = nil) {
        self.user_id = user_id
        self.question = question
        self.text = text
        self.fallback = fallback
        self.origin_name = origin_name
        self.pre_defined = pre_defined
        self.conversation_id = conversation_id
        self.message = message
        self.response = response
        self.message_log = message_log
        self.hash = hash
        self.timestamp = timestamp
        self.type = type
        self.bulletPoints = bulletPoints
        self.underlineWords = underlineWords
    }
}


struct RelatedQuestions: Codable {
    let text: [RelatedQuestionText]?
}

struct RelatedQuestionText: Codable {
    let type: String?
    let data: String?
    let text: String?
}

struct MessageLog: Codable {
    let role: String?
    let text: String?
}

struct Chunk: Codable {
    let type: String?
    let text: String?
}

struct RelatedQuestion: Codable {
    let type: String?
    let data: String?
    let text: String?
}

struct Wrapup: Codable {
    let type: String?
    let response: WrapupResponse?
}

struct WrapupResponse: Codable {
    let message: Message?
    let conversation_id: String?
    let message_id: String?
    let conversation_display_id: Int?
    let in_chat_answer_keyword_definition_pair: [String: String]?
}

