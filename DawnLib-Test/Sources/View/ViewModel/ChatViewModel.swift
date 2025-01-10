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
    var feedbackselectedButton:Int? = 0
    var addFeedBackIndexDict: [Int: String] = [:]

    var texts: [String]?

    required init() {
        jsonResponse = [Response(question: "How I always wake up tired. What should I do?",pre_defined:true, type:.question),Response(question: "What should I do if my CPAP isn\'t working?",pre_defined:true,type: .question),Response(question: "What do I do when I can’t register my device with myAir?",pre_defined:true,type: .question),Response(question: "I’d like to submit a complaint.",pre_defined:true,type: .question)]
    }
    
    
    func addingAnswer(selectedQuestion question: String) {
        jsonResponse?.append(Response(question:question, type:.answer))
        jsonResponse = jsonResponse?.filter { !($0.pre_defined == false && $0.type == .question) }

        print(jsonResponse?.count)
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
            
            // Filter responses based on the question, ignoring punctuation like ' and .
            if let matchedResponse = responses.first(where: {
                let cleanedQuestion = question?.replacingOccurrences(of: "['.]", with: "", options: .regularExpression, range: nil).lowercased()
                let cleanedResponseQuestion = $0.question?.replacingOccurrences(of: "['.]", with: "", options: .regularExpression, range: nil).lowercased()
                return cleanedQuestion == cleanedResponseQuestion
            }) {
                // If a matching question is found, display the response
                displayData(matchedResponse)
            } else {
                guard let notRelatedResponse = responses.first(where: {$0.question == "unrelated question"}) else { return print("No matching question found.") }
                displayData(notRelatedResponse)
                
            }
        } catch {
            print("Error loading or decoding JSON: \(error.localizedDescription)")
        }
    }
    
    func displayData(_ response: Response) {        
        jsonResponse?.append(Response(type: .bulletPoints, bulletPoints: response.response?.message?.text ?? [], underlineWords: response.response?.message?.underLineText ?? [] ))
        jsonResponse?.append(Response(type:.feedback))
        
        response.response?.message?.related_questions?.forEach({ question in
            jsonResponse?.append(Response(question: question.data,pre_defined: false, type:.question))
        })
        
    }
    
    func calculateCellHeight(
        forText text: Any,
        screenWidth: CGFloat? = UIScreen.main.bounds.width, // Fixed width to prevent wrapping issues
        font: UIFont? = UIFont.systemFont(ofSize: 16),
        lineHeight: CGFloat? = 23, // Smaller line height for better fitting
        verticalPadding: CGFloat? = 20
    ) -> CGFloat {
        
        // Convert input into a single string (handle array of strings as well)
        let textString: String
        if let textArray = text as? [String] {
            textString = textArray.joined(separator: "\n")
        } else if let textStringInput = text as? String {
            textString = textStringInput
        } else {
            return 0 // Return 0 if the input type is not supported
        }
        
        // Calculate available width with 30% left padding
        let leftPadding = (screenWidth ?? 0.0) * 0.3
        let availableWidth = (screenWidth ?? 0.0) - leftPadding - 16 // 16 points right padding
        
        let maxSize = CGSize(width: availableWidth, height: CGFloat.greatestFiniteMagnitude)
        
        // Configure paragraph style for line breaks and word wrapping
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.alignment = .left
        
        // Apply custom line height if provided
        if let lineHeight = lineHeight {
            paragraphStyle.minimumLineHeight = lineHeight
            paragraphStyle.maximumLineHeight = lineHeight
        }
        
        // Define text attributes (for font and paragraph style)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .paragraphStyle: paragraphStyle
        ]
        
        // Calculate bounding rect (i.e., the height of the text)
        let boundingRect = (textString as NSString).boundingRect(
            with: maxSize,
            options: [.usesLineFragmentOrigin, .usesFontLeading, .usesDeviceMetrics],
            attributes: attributes,
            context: nil
        )
        
        // Add vertical padding to the calculated height
        let totalHeight = ceil(boundingRect.height) + (verticalPadding ?? 0.0) * 2
        
        return totalHeight
    }
    
    // Function to calculate the height for markdown text
       func calculateMarkdownHeight(
           markdownText: String,
           fontFamily: String = FontConstants.robotoRegular,
           fontSize: CGFloat = FontSize.regular.rawValue,
           fontWeight: UIFont.Weight = .regular,
           lineHeight: CGFloat = 1.5,
           containerWidth: CGFloat,
           alignment: NSTextAlignment = .left
       ) -> CGFloat {
           
           // Parse markdown text to attributed string with the required attributes
           let attributedText = parseMarkdownToAttributedStringWithBulletsAndLinks(
               markdownText: markdownText,
               fontFamily: fontFamily,
               fontSize: fontSize,
               fontWeight: fontWeight,
               textColor: .black,  // Text color (you can change this as needed)
               bulletColor: .black, // Bullet color (you can change this as needed)
               primaryColor: .blue, // Primary color for links (you can change this as needed)
               lineHeight: lineHeight,
               alignment: alignment
           )
           
           // Calculate the bounding rect for the text
           let boundingRect = attributedText.boundingRect(with: CGSize(width: containerWidth, height: CGFloat.greatestFiniteMagnitude),
                                                          options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                          context: nil)
           
           return boundingRect.height
       }
       
       // Helper function to parse markdown text with bullets and links
       private func parseMarkdownToAttributedStringWithBulletsAndLinks(
           markdownText: String,
           fontFamily: String,
           fontSize: CGFloat,
           fontWeight: UIFont.Weight,
           textColor: UIColor,
           bulletColor: UIColor,
           primaryColor: UIColor,
           lineHeight: CGFloat,
           alignment: NSTextAlignment
       ) -> NSAttributedString {
           
           let paragraphStyle = NSMutableParagraphStyle()
           paragraphStyle.alignment = alignment
           paragraphStyle.lineSpacing = lineHeight
           
           let bulletAttributes: [NSAttributedString.Key: Any] = [
               .foregroundColor: bulletColor,
               .font: UIFont.systemFont(ofSize: 10, weight: fontWeight)
           ]
           
           let textAttributes: [NSAttributedString.Key: Any] = [
               .foregroundColor: textColor,
               .font: UIFont(name: fontFamily, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: fontWeight),
               .paragraphStyle: paragraphStyle
           ]
           
           let linkAttributes: [NSAttributedString.Key: Any] = [
               .foregroundColor: primaryColor,
               .underlineStyle: NSUnderlineStyle.single.rawValue,
               .font: UIFont(name: fontFamily, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: fontWeight),
               .link: "https://www.example.com"
           ]
           
           let attributedString = NSMutableAttributedString()
           
           markdownText.enumerateLines { line, _ in
               if line.starts(with: "- ") {
                   let bulletPoint = "●  "
                   let bulletAttributedString = NSAttributedString(string: bulletPoint, attributes: bulletAttributes)
                   attributedString.append(bulletAttributedString)
                   
                   let trimmedLine = line.dropFirst(2)
                   let textAttributedString = NSAttributedString(string: String(trimmedLine) + "\n\n", attributes: textAttributes)
                   attributedString.append(textAttributedString)
               } else {
                   let regex = try! NSRegularExpression(pattern: "\\[([^)]+)\\]\\(([^)]+)\\)", options: [])
                   let range = NSRange(location: 0, length: line.utf16.count)
                   
                   var lastRangeEnd = 0
                   regex.enumerateMatches(in: line, options: [], range: range) { match, _, _ in
                       guard let matchRange = match?.range else { return }
                       
                       let normalText = (line as NSString).substring(with: NSRange(location: lastRangeEnd, length: matchRange.location - lastRangeEnd))
                       attributedString.append(NSAttributedString(string: normalText, attributes: textAttributes))
                       
                       if let match = match {
                           let linkTextRange = match.range(at: 1)
                           let linkText = (line as NSString).substring(with: linkTextRange)
                           let urlRange = match.range(at: 2)
                           
                           let urlString = (line as NSString).substring(with: urlRange)
                           let linkAttributedString = NSAttributedString(
                               string: linkText,
                               attributes: [
                                   .foregroundColor: primaryColor,
                                   .underlineStyle: NSUnderlineStyle.single.rawValue,
                                   .font: UIFont(name: fontFamily, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: fontWeight),
                                   .link: URL(string: urlString) ?? URL(string: "https://www.example.com")!
                               ]
                           )
                           attributedString.append(linkAttributedString)
                       }
                       
                       lastRangeEnd = matchRange.location + matchRange.length
                   }
                   
                   let remainingText = (line as NSString).substring(from: lastRangeEnd)
                   attributedString.append(NSAttributedString(string: remainingText + "\n", attributes: textAttributes))
               }
           }
           
           return attributedString
       }
}



