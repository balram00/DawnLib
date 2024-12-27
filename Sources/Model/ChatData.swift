//
//  File.swift
//  DawnLib
//
//  Created by bitcot on 27/12/24.
//


import Foundation

struct ChatData {
    static let chatItems: [ChatItem] = [
        ChatItem(
            type: .question(
                "What is your name?"
            )
        ),
        ChatItem(
            type: .question(
                "Answer may display inaccuracy, please always consult a medical professional for advice. Here are some other Things you should know about Dawn."
            )
        ),
        ChatItem(
            type: .loader
        ),
        ChatItem(
            type: .feedback
        ),
        ChatItem(
            type: .question(
                "What is your favorite color?"
            )
        ),
        ChatItem(
            type: .question(
                "Answer may display inaccuracy, please always consult a medical professional for advice. Here are some other Things you should know about Dawn.Answer may display inaccuracy, please always consult a medical professional"
            )
        ),
        ChatItem(
            type: .answer(
                "Blue is my favorite color."
            )
        ),
        ChatItem(
            type: .feedback
        ),
        ChatItem(
            type: .bulletPoints(
                points: [
                    "You might encounter issues registering if myAir services are temporarily unavailable.",
                    "It may be helpful to wait a few hours and then attempt to log in again.",
                    "For further assistance with myAir, please contact our support team."
                ],
                underlineWords: [
                    "myAir",
                    "contact our support team"
                ]
            )
        ),
        ChatItem(
            type: .question(
                "What is your name?"
            )
        ),
        ChatItem(
            type: .question(
                "What is your name?"
            )
        ),
        ChatItem(
            type: .question(
                "What is your favorite color?"
            )
        ),
        ChatItem(
            type: .question(
                "What is your name?"
            )
        ),
        ChatItem(
            type: .answer(
                "Blue is my favorite color."
            )
        ),
        ChatItem(
            type: .bulletPoints(
                points: [
                    "You might encounter issues registering if myAir services are temporarily unavailable.",
                    "It may be helpful to wait a few hours and then attempt to log in again.",
                    "For further assistance with myAir, please contact our support team."
                ],
                underlineWords: [
                    "myAir",
                    "contact our support team"
                ]
            )
        )
    ]
}
