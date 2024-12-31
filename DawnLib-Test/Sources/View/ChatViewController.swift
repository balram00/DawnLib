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
        setUpNavbar()
        setUpTableView()
        setUpNotificationObservers()
        setUpTapGuesture()
        setUpHeaderndFooter()
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true) // Dismiss the keyboard
    }
    
    // MARK: - Setup Methods
    
    func setUpTapGuesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        overrideUserInterfaceStyle = .light
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
    
    @objc func rightButtonTapped() {
        // Handle right button tap
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
        let tableViewHeader = ChatHeaderView.load(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 200))
           questionTableView.tableHeaderView = tableViewHeader

           // Configure footer
           let tableViewFooter = ChatFooterView.load(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 90))
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
    
    func setUpNotificationObservers() {
        // Observers for keyboard events
        NotificationCenter.default
            .addObserver(
                self,
                selector: #selector(
                    keyboardWillShow(
                        _:
                    )
                ),
                name: UIResponder.keyboardWillShowNotification,
                object: nil
            )
        NotificationCenter.default
            .addObserver(
                self,
                selector: #selector(
                    keyboardWillHide(
                        _:
                    )
                ),
                name: UIResponder.keyboardWillHideNotification,
                object: nil
            )
        
        // Gesture recognizer to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(
                dismissKeyboard
            )
        )
        view
            .addGestureRecognizer(
                tapGesture
            )
    }
    
    // MARK: - Actions
    
    @objc func dismissKeyboard() {
        view
            .endEditing(
                true
            )
    }
    
    @objc func keyboardWillShow(_ notification: Notification){
        scrollToBottom() // Ensure it scrolls to the bottom
        if let keyboardFrame = (
            notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        )?.cgRectValue {
            let keyboardHeight = keyboardFrame.height
            
            // Adjust the bottom constraint of the custom input view
            customInputViewBottomConstraint.constant = -keyboardHeight
            
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
        // Animate the layout change
        UIView
            .animate(
                withDuration: 0.3
            ) {
                self.view
                    .layoutIfNeeded()
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
    
    // MARK: - Table View DataSource & Delegate
    
    public func tableView(_ tableView: UITableView,numberOfRowsInSection section: Int) -> Int {
        return viewModel.chatItems.count
    }
    
    public func tableView(_ tableView: UITableView,cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chatItem = viewModel.chatItems[indexPath.row]
        switch chatItem.type {
        case .question(let text):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: QuestionTableViewCell.identifier
            ) as? QuestionTableViewCell else {
                return UITableViewCell()
            }
            cell.delagate = self
            cell
                .configure(
                    with: text
                )
            return cell
        case .answer(let text):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AnswerTableViewCell.identifier) as? AnswerTableViewCell else {
                return UITableViewCell()
            }
            cell.anwerLabel.text = text
            return cell
        case .bulletPoints(
            let points,
            let underlineWords,
            let boldWords
        ):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ResponseTableViewCell.identifier) as? ResponseTableViewCell else {return UITableViewCell()}
            cell.delegate = self
            cell.configure(
                    with: points,
                    underlineWords: underlineWords, boldWords: boldWords
                )
            return cell
        case .loader:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LoaderTableViewCell.identifier) as? LoaderTableViewCell else {
                return UITableViewCell()
            }
            return cell
        case .feedback:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedbackTableViewCell.identifier) as? FeedbackTableViewCell else {
                return UITableViewCell()
            }
            cell.feedBackIndexDict = viewModel.feedBackIndexDict
            cell.index = indexPath
            cell.screenSetup()
            cell.delegate = self

            return cell
        }
    }
        
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
         let spacerView = UIView()
         spacerView.backgroundColor = .clear
         return spacerView
     }
     
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
         return 50 // Add spacing
     }

    
    public func tableView(_ tableView: UITableView,didSelectRowAt indexPath: IndexPath) {
        // Handle row selection
    }
    
    public func tableView(_ tableView: UITableView,heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let item = viewModel.chatItems[indexPath.row]
        
        switch item.type {
        case .question(let question):
        
            let width = tableView.frame.width - 40
            let height = calculateHeight(
                forText: question,
                width: width
            )
            return height
            
        case .answer(let answerText):
            
            let width = tableView.frame.width - 40
            let height = calculateHeight(
                forText: answerText,
                width: width
            )
            return height
            
        case .bulletPoints(points: let points,_,_):
            
            let width = tableView.frame.width - 40
            let height = calculateHeight(
                forText: points.joined(separator: "\n"),
                width: width
            )
            print("height",height)
            return height + 120
            
        case .loader:
            return 50.0
            
        case .feedback:
            if viewModel.feedBackIndexDict.contains(where: {$0.value == .othersFeedback && $0.key == indexPath.row}) {
                return 630.0
            }else if viewModel.feedBackIndexDict.contains(where: {$0.value == .feedback && $0.key == indexPath.row}) {
                return 430.0
            }else {
                return 120.0
            }
        }
    }
    
    func calculateHeight(forText text: String, width: CGFloat, font: UIFont? = UIFont.systemFont(ofSize: 18)) -> CGFloat {
        // Define the maximum size constraint
        let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)

        // Define the attributes for the text, including the font
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font as Any
        ]

        // Calculate the bounding rect based on the text, font, and max size
        let boundingRect = (text as NSString).boundingRect(
            with: maxSize,
            options: .usesLineFragmentOrigin, // Ensures multi-line text wrapping is considered
            attributes: attributes,
            context: nil
        )

        // Return the height of the bounding rect, which gives the required height for the text
        if boundingRect.height > 100 {
            return boundingRect.height + 150
        }else {
            return boundingRect.height + 50
        }
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
        viewModel.addingAnswerItem(answer: cell.questionLabel.text ?? "")
        DispatchQueue.main.async {
            self.questionTableView.reloadData()
        }
    }
    
    func labelTapped(in cell: ResponseTableViewCell, tappedWord: String,at location: CGPoint) {
        print(tappedWord)
        showPopup(at: location)
    }
    
    func didTapOthersButton(in cell: FeedbackTableViewCell) {
        print("Feedbackcell Index:",cell.feedBackIndexDict.map({$0.key}))
        print("Feedbackcell value:",cell.feedBackIndexDict.map({$0.value}))
        self.viewModel.feedbackIndex = cell.index
        let sortedFeedBackIndexDict = cell.feedBackIndexDict.sorted(by: { $0.key < $1.key })
        let sortedDict = Dictionary(uniqueKeysWithValues: sortedFeedBackIndexDict)

        viewModel.feedBackIndexDict = sortedDict

        DispatchQueue.main.async {
            self.questionTableView.reloadData()
        }
        
    }
    
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

