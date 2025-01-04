//
//  File.swift
//  DawnLib
//
//  Created by bitcot on 24/12/24.
//

import UIKit

public class ChatViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    // Outlets
    @IBOutlet public weak var chatInputView: UIView!
    @IBOutlet public weak var inputTextView: UITextView!
    @IBOutlet public weak var sendButton: UIButton!
    @IBOutlet public weak var questionTableView: UITableView!
    @IBOutlet public weak var customInputViewBottomConstraint: NSLayoutConstraint!
    
    // Properties
    var viewModel = ChatViewModel()
    
    // MARK: - Life Cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        questionTableView.isUserInteractionEnabled = true
        setUpNavbar()
        setUpTableView()
        addDoneButtonToKeyboard()
        setUpNotificationObservers()
        setUpHeaderndFooter()
        print("questionTableView.frame.height",self.questionTableView.frame.height)
    }

    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        chatInputView.backgroundColor = .white
        chatInputView.layer.shadowColor = UIColor.black.cgColor
        chatInputView.layer.shadowOpacity = 0.5
        chatInputView.layer.shadowOffset = CGSize(width: 5, height: 5)
        chatInputView.layer.shadowRadius = 10
        chatInputView.layer.cornerRadius = chatInputView.frame.height/2
        chatInputView.clipsToBounds = false
        sendButton.layer.cornerRadius = sendButton.frame.height/2
    }
        
    func setUpTapGuesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
    }
        
    func setUpNavbar() {
        // Use the helper methods to create the navbar components
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            customView: NavbarHelper.createLeftBarButton()
        )
        
        let rightButton = NavbarHelper.createRightBarButton()
        rightButton
            .addTarget(
                self,
                action: #selector(
                    rightButtonTapped
                ),
                for: .touchUpInside
            )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            customView: rightButton
        )
    }
    
 
    
    @objc func rightButtonTapped() {
        // Handle right button tap
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        // Get the location of the tap
        let tapLocation = sender.location(in: self.view)
        // Check if there is an existing popup and remove it
        
        if let existingPopup = self.view.subviews.first(where: { $0.tag == 77 }) {
            existingPopup.removeFromSuperview()
        }
        
        // Create the new popup view
        let popupWidth: CGFloat = view.frame.width - 40
        let popupHeight: CGFloat = 100
        let popupX = max(10, min(tapLocation.x - popupWidth / 2, self.view.bounds.width - popupWidth - 10))
        let popupY = min(self.view.bounds.height - popupHeight - 10, tapLocation.y + 20)
        
        let popupView = PopupView.load(frame: CGRect(x: popupX, y: popupY, width: popupWidth, height: popupHeight))
        popupView.tag = 77
        view.addSubview(popupView)
        

    }
    
    public static func instantiate() -> ChatViewController {
        let storyboard = UIStoryboard(
            name: "Main",
            bundle: nil
        )
        guard let viewController = storyboard.instantiateViewController(
            withIdentifier: "ChatViewController"
        ) as? ChatViewController else {
            fatalError(
                "ChatViewController not found in Main.storyboard"
            )
        }
        return viewController
    }
    
    func setUpHeaderndFooter() {
        let tableViewHeader = ChatHeaderView.load(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 150))
           questionTableView.tableHeaderView = tableViewHeader

           // Configure footer
           let tableViewFooter = ChatFooterView.load(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
           questionTableView.tableFooterView = tableViewFooter
    }
    
    func setUpTableView() {
        inputTextView.delegate = self
        // Register cells
        
        
        questionTableView
            .register(
                UINib(
                    nibName: ChatHeaderCell.identifier,
                    bundle: nil
                ),
                forCellReuseIdentifier: ChatHeaderCell.identifier
            )
        questionTableView
            .register(
                UINib(
                    nibName: ChatFooterCell.identifier,
                    bundle: nil
                ),
                forCellReuseIdentifier: ChatFooterCell.identifier
            )
        questionTableView
            .register(
                UINib(
                    nibName: QuestionTableViewCell.identifier,
                    bundle: nil
                ),
                forCellReuseIdentifier: QuestionTableViewCell.identifier
            )
        questionTableView
            .register(
                UINib(
                    nibName: AnswerTableViewCell.identifier,
                    bundle: nil
                ),
                forCellReuseIdentifier: AnswerTableViewCell.identifier
            )
        questionTableView
            .register(
                UINib(
                    nibName: ResponseTableViewCell.identifier,
                    bundle: nil
                ),
                forCellReuseIdentifier: ResponseTableViewCell.identifier
            )
        questionTableView
            .register(
                UINib(
                    nibName: FeedbackTableViewCell.identifier,
                    bundle: nil
                ),
                forCellReuseIdentifier: FeedbackTableViewCell.identifier
            )
        questionTableView
            .register(
                UINib(
                    nibName: LoaderTableViewCell.identifier,
                    bundle: nil
                ),
                forCellReuseIdentifier: LoaderTableViewCell.identifier
            )
    }
    
    func addDoneButtonToKeyboard() {
         // Create a toolbar
         let toolbar = UIToolbar()
         toolbar.sizeToFit() // Adjust the size to fit the screen width
         
         // Create a flexible space to align the button to the right
         let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
         
         // Create a "Done" button
         let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
         
         // Add the flexible space and "Done" button to the toolbar
         toolbar.items = [flexibleSpace, doneButton]
         
         // Assign the toolbar to the inputAccessoryView of the UITextView
         inputTextView.inputAccessoryView = toolbar
     }
     
     @objc func doneButtonTapped() {
         inputTextView.resignFirstResponder() // Dismiss the keyboard
     }
    
    func setUpNotificationObservers() {
        // Observers for keyboard events
        NotificationCenter.default
            .addObserver(
                self,
                selector: #selector(keyboardWillShow(_:)),
                name: UIResponder.keyboardWillShowNotification,
                object: nil
            )
        NotificationCenter.default
            .addObserver(
                self,
                selector: #selector(keyboardWillHide(_:)),
                name: UIResponder.keyboardWillHideNotification,
                object: nil
            )
        
        // Gesture recognizer to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
        tapGesture.cancelsTouchesInView = false // Allow other interactions
        view.addGestureRecognizer(tapGesture)
    }

       
       // MARK: - Actions
       
       @objc func dismissKeyboard() {
           view.endEditing(true)
       }
       
       @objc func keyboardWillShow(_ notification: Notification){
           scrollToBottom() // Ensure it scrolls to the bottom
           if let keyboardFrame = (
               notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
           )?.cgRectValue {
               let keyboardHeight = keyboardFrame.height
               
               // Adjust the bottom constraint of the custom input view
               customInputViewBottomConstraint.constant = -keyboardHeight
               print("questionTableView.frame.height",self.questionTableView.frame.height)
               // Animate the layout change
               UIView
                   .animate(
                       withDuration: 0.3
                   ) {
                       self.view
                           .layoutIfNeeded()
                   }
           }
       }
       
       @objc func keyboardWillHide(_ notification: Notification){
           // Reset the bottom constraint of the custom input view
           customInputViewBottomConstraint.constant = 0
           print("questionTableView.frame.height",self.questionTableView.frame.height)

           // Animate the layout change
           DispatchQueue.main.async {
               self.questionTableView.reloadData()
           }
           UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
       }
   
    func scrollToBottom() {
        DispatchQueue.main.async {
                let lastRow = self.questionTableView.numberOfRows(inSection: 0) - 1
                if lastRow >= 0 {
                    let indexPath = IndexPath(
                        row: lastRow,
                        section: 0
                    )
                    self.questionTableView
                        .scrollToRow(
                            at: indexPath,
                            at: .bottom,
                            animated: true
                        )
                }
            }
    }
    
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        let questionText = inputTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let questionText else { return }
        
        
        viewModel.addingLoader()
        DispatchQueue.main.async {
            self.questionTableView.reloadData()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.viewModel.fetchDataAndDisplay(question: questionText)
            if let index = self.viewModel.jsonResponse?.firstIndex(where: { $0.type == .loader }) {
                self.inputTextView.text = ""
                self.viewModel.jsonResponse?.remove(at: index)
                self.questionTableView.reloadData()
            }
        }
    }
    
    // MARK: - Table View DataSource & Delegate
    
    public func tableView(_ tableView: UITableView,numberOfRowsInSection section: Int) -> Int {
        return viewModel.jsonResponse?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView,cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chatItem = viewModel.jsonResponse?[indexPath.row]
        switch chatItem?.type {
        case .question:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: QuestionTableViewCell.identifier
            ) as? QuestionTableViewCell else {
                return UITableViewCell()
            }
            cell.delagate = self
            cell.configure(with: chatItem?.question ?? "")
            return cell
        case .answer:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AnswerTableViewCell.identifier) as? AnswerTableViewCell else {
                return UITableViewCell()
            }
            cell.jsonResponse = viewModel.jsonResponse?[indexPath.row]
            cell.dataSetUp()
            cell.anwerLabel.text = chatItem?.question ?? ""
            return cell
        case .bulletPoints:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ResponseTableViewCell.identifier) as? ResponseTableViewCell else {return UITableViewCell()}
            cell.delegate = self
            cell.index = indexPath
            cell.ResponseIndexDict = viewModel.ResponseIndexDict
            cell.jsonResponse = viewModel.jsonResponse?[indexPath.row]
            cell.configure(
                with: chatItem?.bulletPoints ?? [String](),
                    underlineWords: chatItem?.underlineWords ?? [String]())

            return cell
        case .loader:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LoaderTableViewCell.identifier) as? LoaderTableViewCell else {
                return UITableViewCell()
            }
            cell.startWaveAnimation()
            return cell
        case .feedback:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedbackTableViewCell.identifier) as? FeedbackTableViewCell else {
                return UITableViewCell()
            }
            cell.index = indexPath
            if viewModel.feedBackIndexDict[indexPath.row] == nil {
                  // Initialize with .closed if not present
                  viewModel.feedBackIndexDict[indexPath.row] = .closed
              }
            cell.feedBackIndexDict = viewModel.feedBackIndexDict
            cell.screenSetup()
            cell.delegate = self

            return cell
            
        case .empty:
            let cell = UITableViewCell() // Create a new UITableViewCell
                let spacerView = UIView() // Create a spacer view
                spacerView.backgroundColor = .clear // Set background color to clear

                cell.selectionStyle = .none
                spacerView.translatesAutoresizingMaskIntoConstraints = false
                cell.contentView.addSubview(spacerView)
            return cell
        case .none:
            return UITableViewCell()
        case .some(_):
            return UITableViewCell()
        }
    }
        
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
         let spacerView = UIView()
        spacerView.backgroundColor = .clear
         return spacerView
     }
     
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
         return 50
     }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let chatItem = viewModel.jsonResponse?[indexPath.row]
        
        // Your existing logic follows
        switch chatItem?.type {
        case .question:
                print("Question selected")
            viewModel.addingLoader()
            DispatchQueue.main.async {
                self.questionTableView.reloadData()
            }
            questionTableView.isUserInteractionEnabled = false
            scrollToBottom()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.viewModel.fetchDataAndDisplay(question: chatItem?.question)
                if let index = self.viewModel.jsonResponse?.firstIndex(where: { $0.type == .loader }) {
                    self.viewModel.jsonResponse?.remove(at: index)
                    self.questionTableView.isUserInteractionEnabled = true
                    self.questionTableView.reloadData()
                }
            }
        case .answer:
                print("Answer selected")
        case .bulletPoints:
                print("Bullet points selected")
                // Existing code to create and show a popup
            // Check if there is an existing popup and remove it
            default:
                break
        }
    }

    
    public func tableView(_ tableView: UITableView,heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let item = viewModel.jsonResponse?[indexPath.row]
        
        switch item?.type {
        case .question:
        
            let width = tableView.frame.width - 40
            let height = calculateHeight(
                forText: item?.question ?? "",
                width: width
            )
            return height
            
        case .answer:
            
            let width = tableView.frame.width - 40
            let height = calculateHeight(
                forText: item?.question ?? "",
                width: width
            )
            return height
            
        case .bulletPoints:
            guard let bulletPoints = item?.bulletPoints else {
                print("bulletPoints is nil")
                return 50.0
            }
            let width = tableView.frame.width - 40
            let height = calculateHeight(
                forText: bulletPoints.joined(separator: "\n"),
                width: width
            )
            print("height",height)
            return height
            
        case .loader:
            return 50.0
            
        case .feedback:
            if viewModel.feedBackIndexDict.contains(where: {$0.value == .othersFeedback && $0.key == indexPath.row}) {
                return FeedbackType.othersFeedback.height
            }else if viewModel.feedBackIndexDict.contains(where: {$0.value == .feedback && $0.key == indexPath.row}) {
                return FeedbackType.feedback.height
            }else if viewModel.feedBackIndexDict.contains(where: {$0.value == .liked && $0.key == indexPath.row}) {
                return FeedbackType.liked.height
            }else if viewModel.feedBackIndexDict.contains(where: {$0.value == .disliked && $0.key == indexPath.row}) {
                return FeedbackType.liked.height
            }else {
                return 120.0
            }
        case .empty:
            return 0.0
        case .none:
            return 0
        case .some(_):
            return 0
        }
    }
    
    func calculateHeight(forText text: String, width: CGFloat, font: UIFont? = UIFont.systemFont(ofSize: 16), lineHeight: CGFloat? = 23) -> CGFloat {
        // Define the maximum size constraint
        let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)

        // Create a paragraph style to set the line height
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = lineHeight ?? 0.0
        paragraphStyle.maximumLineHeight = lineHeight ?? 0.0

        // Define the attributes for the text, including the font and paragraph style
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font as Any,
            .paragraphStyle: paragraphStyle
        ]

        // Calculate the bounding rect based on the text, font, and max size
        let boundingRect = (text as NSString).boundingRect(
            with: maxSize,
            options: .usesLineFragmentOrigin, // Ensures multi-line text wrapping is considered
            attributes: attributes,
            context: nil
        )

        // Return the height of the bounding rect with additional padding if necessary
        return max(boundingRect.height , 80)
    }


}

extension ChatViewController: UITextViewDelegate {
    
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        scrollToBottom()
        DispatchQueue.main
            .async {
                self.chatInputView.layer.borderWidth = 1
                self.chatInputView.layer.borderColor = UIColor(
                    hex: "#9d2872"
                ).cgColor
                self.sendButton.layer.backgroundColor = UIColor(
                    hex: "#9d2872"
                ).cgColor
            }
        
        if textView.text == "Ask a question here" {
            textView.text = ""
            textView.textColor = .black
        }
        return true
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        print(
            "Did end editing: \(textView.text ?? "")"
        )
        chatInputView.layer.borderColor = UIColor.clear.cgColor
        sendButton.layer.backgroundColor = UIColor.systemGray4.cgColor
        
        if textView.text.isEmpty {
            textView.text = "Ask a question here"
            textView.textColor = .darkGray
        }
    }
    
    public func textViewShouldReturn(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    public func textView(_ textView: UITextView,shouldChangeTextIn range: NSRange,replacementText text: String) ->Bool {
        let currentText = textView.text ?? ""
        let updatedText = (
            currentText as NSString
        ).replacingCharacters(
            in: range,
            with: text
        )
        print(
            "Updated text: \(updatedText)"
        )
        return true
    }
}

extension ChatViewController: FeedbackTableViewCellDelegate,ResponseTableViewDelegate,QuestionTableViewCellDelegate {
    func didSelectQuestion(_ cell: QuestionTableViewCell) {

        viewModel.addingLoader()
        DispatchQueue.main.async {
            self.questionTableView.reloadData()
        }
        self.scrollToBottom()
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            self.viewModel.fetchDataAndDisplay(question: cell.questionLabel.text ?? "")
            if let index = self.viewModel.jsonResponse?.firstIndex(where: { $0.type == .loader }) {
                self.viewModel.jsonResponse?.remove(at: index)
                self.questionTableView.reloadData()
            }
        }
    }
    
    func labelTapped(in cell: ResponseTableViewCell, tappedWord: String,at location: CGPoint) {
        print(tappedWord)
//        showPopup(at: location)
    }
    
    func animationCompleted(in cell: ResponseTableViewCell) {
        if let row = cell.index?.row    {
            if !viewModel.ResponseIndexDict.keys.contains(row) {
                viewModel.ResponseIndexDict[row] = true
               }
         }
    }
    
    func didTapFeedbackButton(in cell: FeedbackTableViewCell, newStatus: FeedbackType) {
         // Update the feedback status
         if let index = cell.index?.row {
             viewModel.feedBackIndexDict[index] = newStatus
         }
         
         if let indexPath = cell.index {
             questionTableView.reloadRows(at: [indexPath], with: .automatic)
         }
     }
    
//    func didTapFeedbackButton(in cell: FeedbackTableViewCell) {
//
//        if let index = cell.index?.row {
//            viewModel.feedBackIndexDict[index] = newStatus
//            }
//            
//            // Reload the affected row to reflect the new height based on feedback status
//            if let indexPath = cell.index {
//                questionTableView.reloadRows(at: [indexPath], with: .automatic)
//            }
//        self.viewModel.feedbackIndex = cell.index
//        let sortedFeedBackIndexDict = cell.feedBackIndexDict.sorted(by: { $0.key < $1.key })
//        let sortedDict = Dictionary(uniqueKeysWithValues: sortedFeedBackIndexDict)
//
//        viewModel.feedBackIndexDict = sortedDict
//
//        DispatchQueue.main.async {
//            self.questionTableView.reloadData()
//        }
//        
//    }
    
    func showPopup(at location: CGPoint) {
           // Remove any existing popup
           view.subviews.filter { $0.tag == 1 }.forEach { $0.removeFromSuperview() }
           // Popup size
           let popupHeight: CGFloat = 200
           // Calculate Y position
           let popupY: CGFloat
        let content = "Once you have created a new password, return to the myAir app and enter it on the Sign in to myAir screen. For assistance with myAir, please contact our support team."
        let width = self.view.frame.width - 40
        let contentHeight = calculateHeight(
            forText: content,
            width: width
        )
        
        if location.y + contentHeight + 50 > view.bounds.height {
               popupY = location.y - 250
           } else {
               popupY = location.y + 50
           }

           // Ensure the popup is within the screen bounds
        let safePopupY = max(0, min(popupY,view.bounds.height - popupHeight))
        print("safePopupY",safePopupY)

      
        DispatchQueue.main.async {
            let popupView = PopupView.load(frame: CGRect(x: 20, y: safePopupY + contentHeight, width: self.view.frame.width - 40, height: contentHeight + 40))
            print(location.y)
            print("safePopupY + height",safePopupY + contentHeight)
            popupView.contentLabel.text = content
            popupView.tag = 1
            self.view.addSubview(popupView)

            }
       }
}

