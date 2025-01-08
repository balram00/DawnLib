//
//  ChatViewModel.swift
//  DawnLib-Test
//
//  Created by bitcot on 29/12/24.
//

import Foundation
import UIKit


class ChatViewModel {
    var currentKeyboardFrame: CGRect?
    var chatItems: [ChatItem] = ChatData.chatItems
    var feedbackIndex: IndexPath?
    var feedbackOthersSelected = false
    var isFeedbackViewIsOpened: Bool = false
    var feedBackIndexDict: [Int: FeedbackType] = [:]
    var ResponseIndexDict: [Int: Bool] = [:]
    var jsonResponse: [Response]?
    
    var texts: [String]?
    
    required init() {
        jsonResponse = [Response(question: "How I always wake up tired. What should I do?",type:.question),Response(question: "What should I do if my CPAP isn\'t working?",type: .question),Response(question: "What do I do when I can’t register my device with myAir?",type: .question),Response(question: "I’d like to submit a complaint.",type: .question)]
    }
    
    func addingLoader() {
        jsonResponse?.append(Response( type: .loader))
    }
    
    func loadJSONFile() -> URL? {
        if let url = Bundle.main.url(forResource: "JsonData", withExtension: "json") {
            return url
        }
        
        let filePath = "/Users/bitcot/Desktop/DawnLib-Test/DawnLib-Test/JsonData.json"
        let fileURL = URL(fileURLWithPath: filePath)
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            return fileURL
        }
        
        return nil
    }
    func text(at index: Int) -> String {
        return texts?[index] ?? ""
    }
    
    func updateText(at index: Int, with text: String) {
        guard index < texts?.count ?? 0 else { return }
        texts?[index] = text
    }
    // Function to fetch and display data
    func fetchDataAndDisplay(question: String?) {
        guard let fileURL = loadJSONFile() else {
            print("JSON file not found.")
            return
        }
        
        do {
            // Read the file data
            let jsonData = try Data(contentsOf: fileURL)
            
            // Decode the JSON data into Response objects
            let responses = try JSONDecoder().decode([Response].self, from: jsonData)
            
            
            // Filter responses based on the question
            if let matchedResponse = responses.first(where: { $0.question?.lowercased() == question?.lowercased() }) {
                // If a matching question is found, display the response
                
                displayData(matchedResponse)
            } else {
                print("No matching question found.")
            }
        } catch {
            print("Error loading or decoding JSON: \(error.localizedDescription)")
        }
    }
    
    func displayData(_ response: Response) {
        
        jsonResponse?.append(Response(question:response.question, type:.answer))
        
        jsonResponse?.append(Response(type: .bulletPoints, bulletPoints: response.response?.message?.text ?? [], underlineWords: response.response?.message?.underLineText ?? [] ))
        jsonResponse?.append(Response(type:.feedback))
        
        if let relatedQuestion = response.response?.message?.related_questions?.first?.data {
            jsonResponse?.append(Response(question:relatedQuestion, type:.question))
        }
        
    }
}



