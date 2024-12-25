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
    public var currentKeyboardFrame: CGRect?
    var chatItems: [ChatItem] = [
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
                "Answer may display inaccuracy, please always consult a medical professional for advice. Here are some other Things you should know about Dawn.Answer may display inaccuracy, please always consult a medical professional for advice. Here are some other Things you should know about Dawn.Answer may display inaccuracy, please always consult a medical professional for advice. Here are some other Things you should know about Dawn.Answer may display inaccuracy, please always consult a medical professional for advice. Here are some other Things you should know about Dawn."
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
    
    // MARK: - Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavbar()
        setUpTableView()
        setUpNotificationObservers()
    }
    
    // MARK: - Setup Methods
    
    public func setUpNavbar() {
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
    
    @objc public func rightButtonTapped() {
        // Handle right button tap
    }
    
    public static func instantiate() -> ChatViewController {
        let storyboard = UIStoryboard(
            name: "Main",
            bundle: Bundle.module
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
    
    public func setUpTableView() {
        // Register cells
        questionTableView
            .register(
                UINib(
                    nibName: ChatHeaderCell.identifier,
                    bundle: Bundle.module
                ),
                forCellReuseIdentifier: ChatHeaderCell.identifier
            )
        questionTableView
            .register(
                UINib(
                    nibName: ChatFooterCell.identifier,
                    bundle: Bundle.module
                ),
                forCellReuseIdentifier: ChatFooterCell.identifier
            )
        questionTableView
            .register(
                UINib(
                    nibName: QuestionTableViewCell.identifier,
                    bundle: Bundle.module
                ),
                forCellReuseIdentifier: QuestionTableViewCell.identifier
            )
        questionTableView
            .register(
                UINib(
                    nibName: AnswerTableViewCell.identifier,
                    bundle: Bundle.module
                ),
                forCellReuseIdentifier: AnswerTableViewCell.identifier
            )
        questionTableView
            .register(
                UINib(
                    nibName: ResponseTableViewCell.identifier,
                    bundle: Bundle.module
                ),
                forCellReuseIdentifier: ResponseTableViewCell.identifier
            )
        questionTableView
            .register(
                UINib(
                    nibName: FeedbackTableViewCell.identifier,
                    bundle: Bundle.module
                ),
                forCellReuseIdentifier: FeedbackTableViewCell.identifier
            )
        questionTableView
            .register(
                UINib(
                    nibName: LoaderTableViewCell.identifier,
                    bundle: Bundle.module
                ),
                forCellReuseIdentifier: LoaderTableViewCell.identifier
            )
        
    }
    
    public func setUpNotificationObservers() {
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
    
    @objc public func dismissKeyboard() {
        view
            .endEditing(
                true
            )
    }
    
    @objc public func keyboardWillShow(
        _ notification: Notification
    ) {
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
    
    @objc public func keyboardWillHide(
        _ notification: Notification
    ) {
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
    
    public func scrollToBottom() {
        DispatchQueue.main
            .async {
                let lastRow = self.questionTableView.numberOfRows(
                    inSection: 0
                ) - 1
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
    
    public func numberofsectionInTableView(
        tableView: UITableView
    ) -> Int {
        return 1
    }
    
    // MARK: - Table View DataSource & Delegate
    
    public func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return chatItems.count + 2 // Including header and footer
    }
    
    public func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        if indexPath.row == 0 {
            // Header Cell
            guard let header = tableView.dequeueReusableCell(
                withIdentifier: ChatHeaderCell.identifier
            ) as? ChatHeaderCell else {
                return UITableViewCell()
            }
            return header
        }
        
        if indexPath.row == chatItems.count + 1 {
            // Footer Cell
            guard let footer = tableView.dequeueReusableCell(
                withIdentifier: ChatFooterCell.identifier
            ) as? ChatFooterCell else {
                return UITableViewCell()
            }
            return footer
        }
        
        let chatItem = chatItems[indexPath.row - 1]
        switch chatItem.type {
        case .question(
            let text
        ):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: QuestionTableViewCell.identifier
            ) as? QuestionTableViewCell else {
                return UITableViewCell()
            }
            cell
                .configure(
                    with: text
                )
            return cell
        case .answer(
            let text
        ):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: AnswerTableViewCell.identifier
            ) as? AnswerTableViewCell else {
                return UITableViewCell()
            }
            cell.anwerLabel.text = text
            return cell
        case .bulletPoints(
            let points,
            let underlineWords
        ):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ResponseTableViewCell.identifier
            ) as? ResponseTableViewCell else {
                return UITableViewCell()
            }
            cell
                .configure(
                    with: points,
                    underlineWords: underlineWords
                )
            return cell
        case .loader:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: LoaderTableViewCell.identifier
            ) as? LoaderTableViewCell else {
                return UITableViewCell()
            }
            return cell
        case .feedback:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: FeedbackTableViewCell.identifier
            ) as? FeedbackTableViewCell else {
                return UITableViewCell()
            }
            return cell
        }
    }
    
    public func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        // Handle row selection
    }
    
    public func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        // Calculate height for rows dynamically
        if indexPath.row == 0 {
            return 200.0 // Height for the header
        }
        
        if indexPath.row == chatItems.count + 1 {
            return 80.0 // Height for the footer
        }
        
        let item = chatItems[indexPath.row - 1] // Skip the header row
        
        switch item.type {
        case .question(
            let question
        ):
            let width = tableView.frame.width - 40
            let height = calculateHeight(
                forText: question,
                width: width
            )
            return height + 60
        case .answer(
            let answerText
        ):
            let width = tableView.frame.width - 40
            let height = calculateHeight(
                forText: answerText,
                width: width
            )
            return height + 60
        case .bulletPoints(
            _,
            _
        ):
            return 200.0
        case .loader:
            return 50.0
        case .feedback:
            return 600.0
        }
    }
    
    public func calculateHeight(
        forText text: String,
        width: CGFloat
    ) -> CGFloat {
        let label = UILabel()
        label.numberOfLines = 0  // Allow the label to wrap text
        label.text = text
        label.font = UIFont
            .systemFont(
                ofSize: 16
            ) // Use the same font as in the cell
        
        // Calculate the size based on the text and the provided width
        let maxSize = CGSize(
            width: width,
            height: CGFloat.greatestFiniteMagnitude
        )
        let requiredSize = label.sizeThatFits(
            maxSize
        )
        
        return requiredSize.height
    }
}

extension ChatViewController: UITextViewDelegate {
    
    public func textViewShouldBeginEditing(
        _ textView: UITextView
    ) -> Bool {
        scrollToBottom()
        DispatchQueue.main
            .async {
                self.chatInputView.layer.borderWidth = 2
                self.chatInputView.layer.borderColor = UIColor(
                    hex: "#9d2872"
                ).cgColor
                self.sendButton.layer.backgroundColor = UIColor(
                    hex: "#9d2872"
                ).cgColor
                self.sendButton.layer.cornerRadius = self.sendButton.frame.width / 2
            }
        
        if textView.text == "Ask a question here" {
            textView.text = ""
            textView.textColor = .black
        }
        return true
    }
    
    public func textViewDidEndEditing(
        _ textView: UITextView
    ) {
        print(
            "Did end editing: \(textView.text ?? "")"
        )
        chatInputView.layer.borderColor = UIColor.clear.cgColor
        
        if textView.text.isEmpty {
            textView.text = "Ask a question here"
            textView.textColor = .darkGray
        }
    }
    
    public func textViewShouldReturn(
        _ textView: UITextView
    ) -> Bool {
        // Dismiss the keyboard when the return key is pressed
        textView
            .resignFirstResponder()
        return true
    }
    
    public func textView(
        _ textView: UITextView,
        shouldChangeTextIn range: NSRange,
        replacementText text: String
    ) -> Bool {
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
