//
//  ChatViewModel.swift
//  DawnLib-Test
//
//  Created by bitcot on 29/12/24.
//

import Foundation


class ChatViewModel {
    var currentKeyboardFrame: CGRect?
    var chatItems: [ChatItem] = ChatData.chatItems
    var feedbackIndex: IndexPath?
    var feedbackOthersSelected = false
    var isFeedbackViewIsOpened: Bool = false
    var feedBackIndexDict: [Int: FeedbackType] = [:]
    
    required init() {}
    
    func addingAnswerItem(answer: String) {
        chatItems.append(ChatItem( type: .answer(answer)))
        chatItems.append(ChatItem( type: .loader))
        chatItems.append(ChatItem(type: .bulletPoints(points:  ["Air escaping from your mask or tubing can affect your therapy. If you notice this happening, don't worry 2014small adjustments or a different mask myAir can usually solve the problem.\n A breathing therapy device that delivers air to a mask worn over the nose and/or mouth to help consistent breathing.\n It's used primarily for sleep apnea.\n Air escaping from your mask or tubing can affect your therapy. If you notice this happening, don't worry 2014small adjustments or a different mask can usually solve the problem.\n A breathing therapy device that delivers air to a mask worn over the nose and/or mouth to help consistent breathing.\n It's used primarily for sleep apnea. contact our support team"], underlineWords: [  "myAir","contact our support team","apnea"],boldWords:["breathing","2014small"])))
        chatItems.append(ChatItem(type: .feedback))
    }
}



//MARK: - markDown text 


//chatItems.append(ChatItem( type: .answer(answer)))
//chatItems.append(ChatItem( type: .loader))
//chatItems.append(ChatItem(type: .bulletPoints(points:  ["Air escaping from your mask or tubing can affect your therapy. If you notice this happening, don't worry, **small adjustments** or a different mask *can usually solve the problem*.  A breathing therapy device that delivers air to a mask worn over the nose and/or mouth to help consistent breathing.It's used primarily for sleep apnea.Air escaping from your mask or tubing can affect your therapy. If you notice this happening, don't worry, **small adjustments** or a different mask *can usually solve the problem*.A breathing therapy device that delivers air to a mask worn over the nose and/or mouth to help consistent breathing.It's used primarily for sleep apnea.[Contact our support team](#)"], underlineWords: [  "myAir","contact our support team","apnea"],boldWords:["breathing","2014small"])))
//chatItems.append(ChatItem(type: .feedback))
