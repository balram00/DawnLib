
import UIKit
import Foundation



class ChatViewController: UIViewController {
    
    @IBOutlet weak var chatInputView: UIView!
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var questionTableView: UITableView!
    @IBOutlet weak var customInputViewBottomConstraint: NSLayoutConstraint! // Connect this to the bottom constraint of

    var currentKeyboardFrame: CGRect?

    var chatItems: [ChatItem] = [
        ChatItem(type: .question("What is your name?")),
        ChatItem(type: .question("Answer may display inaccuracy, please always consult a medical professional for advice. Here are some other Things you should know about Dawn.")),
        ChatItem(type: .loader),
        ChatItem(type: .feedback),
        ChatItem(type: .question("What is your favorite color?")),
        ChatItem(type: .question("Answer may display inaccuracy, please always consult a medical professional for advice. Here are some other Things you should know about Dawn.")),
        ChatItem(type: .answer("Blue is my favorite color.")),
        ChatItem(type: .feedback),
        ChatItem(type: .bulletPoints(
               points: [
                   "You might encounter issues registering if myAir services are temporarily unavailable.",
                   "It may be helpful to wait a few hours and then attempt to log in again.",
                   "For further assistance with myAir, please contact our support team."
               ],
               underlineWords: ["myAir", "contact our support team"]
           )),
        ChatItem(type: .question("What is your name?")),
        ChatItem(type: .question("What is your name?")),
        ChatItem(type: .question("What is your favorite color?")),
        ChatItem(type: .question("What is your name?")),
        ChatItem(type: .answer("Blue is my favorite color.")),
        ChatItem(type: .bulletPoints(
               points: [
                   "You might encounter issues registering if myAir services are temporarily unavailable.",
                   "It may be helpful to wait a few hours and then attempt to log in again.",
                   "For further assistance with myAir, please contact our support team."
               ],
               underlineWords: ["myAir", "contact our support team"]
           ))
    ]
    
        public static func instantiate() -> ChatViewController {
            // Ensure Bundle.module contains the storyboard
            guard let _ = Bundle.module.path(forResource: "Main", ofType: "storyboardc") else {
                fatalError("Main.storyboard not found in Bundle.module")
            }
    
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.module)
    
    
            // Instantiate ChatViewController from the storyboard
            guard let viewController = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController else {
                fatalError("ChatViewController not found in Main.storyboard or identifier mismatch")
            }
    
            return viewController
        }

    override func viewDidLoad() {
        super.viewDidLoad()
        for family in UIFont.familyNames {
            print("Family: \(family)")
            for font in UIFont.fontNames(forFamilyName: family) {
                print("Font: \(font)")
            }
        }

     
        
        setUpNavbar()
        inputTextView.delegate = self
        questionTableView.register(UINib(nibName: QuestionTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: QuestionTableViewCell.identifier)
        questionTableView.register(UINib(nibName: AnswerTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: AnswerTableViewCell.identifier)
        questionTableView.register(UINib(nibName: ResponseTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ResponseTableViewCell.identifier)
        questionTableView.register(UINib(nibName: LoaderTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: LoaderTableViewCell.identifier)
        questionTableView.register(UINib(nibName: LoaderTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: LoaderTableViewCell.identifier)
        questionTableView.register(UINib(nibName: ChatHeaderCell.identifier, bundle: nil), forCellReuseIdentifier: ChatHeaderCell.identifier)
        questionTableView.register(UINib(nibName: ChatFooterCell.identifier, bundle: nil), forCellReuseIdentifier: ChatFooterCell.identifier)
        questionTableView.register(UINib(nibName: FeedbackTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: FeedbackTableViewCell.identifier)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sendButton.layer.cornerRadius = sendButton.frame.width / 2
        chatInputView.layer.masksToBounds = false
        chatInputView.backgroundColor = .white
        questionTableView.tintColor = .red // Custom color for the scroll indicator
               // Ensure scroll indicators are visible
        questionTableView.showsVerticalScrollIndicator = true
        questionTableView.showsHorizontalScrollIndicator = false
               // Optional: Adjust the position of the scroll indicator
        questionTableView.scrollIndicatorInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        chatInputView.layer.shadowColor = UIColor.black.cgColor
        chatInputView.layer.shadowOpacity = 0.3
        chatInputView.layer.shadowOffset = CGSize(width: 0, height: 0) // Center shadow
        chatInputView.layer.cornerRadius = chatInputView.frame.height / 2
   }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        scrollToBottom() // Ensure it scrolls to the bottom
        if let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardFrame.height

            // Adjust the bottom constraint of the custom input view
            customInputViewBottomConstraint.constant = -keyboardHeight

            // Animate the layout change
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }

       
       @objc func keyboardWillHide(_ notification: Notification) {
           // Reset the bottom constraint of the custom input view
           customInputViewBottomConstraint.constant = 0
           
           // Animate the layout change
           UIView.animate(withDuration: 0.3) {
               self.view.layoutIfNeeded()
           }
       }
       
       deinit {
           // Unregister from notifications
           NotificationCenter.default.removeObserver(self)
       }


    
    func setUpNavbar() {
        let firstLabel = UILabel()
        firstLabel.text = "Dawn"
        firstLabel.font = UIFont(name: "Barlow-Bold", size: 20)
        firstLabel.textColor = .black
        firstLabel.sizeToFit()
        
        let secondLabel = UILabel()
        secondLabel.text = "BETA"
        secondLabel.font = UIFont(name: "Barlow-Regular", size: 11)
        secondLabel.textColor = .purple
        secondLabel.sizeToFit()

        let secondLabelContainer = UIView()
        secondLabelContainer.backgroundColor = .white
        secondLabelContainer.contentMode = .center
        secondLabelContainer.layer.cornerRadius = 10
        secondLabelContainer.addSubview(secondLabel)

        secondLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            secondLabel.centerXAnchor.constraint(equalTo: secondLabelContainer.centerXAnchor),
            secondLabel.centerYAnchor.constraint(equalTo: secondLabelContainer.centerYAnchor),
            secondLabelContainer.widthAnchor.constraint(equalTo: secondLabel.widthAnchor, constant: 12),
            secondLabelContainer.heightAnchor.constraint(equalTo: secondLabel.heightAnchor, constant: 12)
        ])

        let stackView = UIStackView(arrangedSubviews: [firstLabel, secondLabelContainer])
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .center
        stackView.distribution = .fill
        
        let stackContainer = UIView()
        stackContainer.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: stackContainer.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: stackContainer.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: stackContainer.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: stackContainer.bottomAnchor)
        ])

        let leftBarButton = UIBarButtonItem(customView: stackContainer)
        navigationItem.leftBarButtonItem = leftBarButton


        stackContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackContainer.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width * 0.5),
            stackContainer.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        let rightButton = UIButton(type: .system)
        rightButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        rightButton.tintColor = .white
        rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
    }

    @objc func rightButtonTapped() {
        print("Right button tapped!")
    }
    
   @objc func handleTapGesture() {
//       chatInputView.layer.borderWidth = 2
//       chatInputView.layer.borderColor = UIColor(hex:"#9d2872").cgColor
   }

    @objc func goToChat() {
        let chatViewController = ChatViewController.instantiate()
        chatViewController.title = "Chat Screen" // Update title here
        self.navigationController?.pushViewController(chatViewController, animated: true)
    }
    
}

//extension ChatViewController: UITextViewDelegate {
//    
//    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
//        scrollToBottom()
//        print("Should begin editing")
//        DispatchQueue.main.async {
//            self.chatInputView.layer.borderWidth = 2
//            self.chatInputView.layer.borderColor = UIColor(hex: "#9d2872").cgColor
//            self.sendButton.layer.backgroundColor = UIColor(hex: "#9d2872").cgColor
//            self.sendButton.layer.cornerRadius = self.sendButton.frame.width / 2
//        }
//
//        if textView.text == "Ask a question here" {
//            textView.text = ""
//            textView.textColor = .black
//        }
//        return true
//    }
//
//    func textViewDidEndEditing(_ textView: UITextView) {
//        print("Did end editing: \(textView.text ?? "")")
//        chatInputView.layer.borderColor = UIColor.clear.cgColor
//        
//        if textView.text.isEmpty {
//            textView.text = "Ask a question here"
//            textView.textColor = .darkGray
//        }
//    }
//    
//    func textViewShouldReturn(_ textView: UITextView) -> Bool {
//        // Dismiss the keyboard when the return key is pressed
//        textView.resignFirstResponder()
//        return true
//    }
//
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        let currentText = textView.text ?? ""
//        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
//        print("Updated text: \(updatedText)")
//        return true
//    }
//
//    func scrollToBottom() {
//        DispatchQueue.main.async {
//            let lastRow = self.questionTableView.numberOfRows(inSection: 0) - 1
//            if lastRow >= 0 {
//                let indexPath = IndexPath(row: lastRow, section: 0)
//                self.questionTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
//            }
//        }
//    }
//}

extension ChatViewController : QuestionTableViewCellDelegate {
    func didSelectQuestion(_ cell: QuestionTableViewCell) {
    }
}


//extension ChatViewController: UITableViewDelegate,UITableViewDataSource {
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return chatItems.count + 2 // Add 2 for the header and footer
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        // Check if it's the header or footer row
//        if indexPath.row == 0 {
//            // Return the header cell
//            guard let header = tableView.dequeueReusableCell(withIdentifier: ChatHeaderCell.identifier) as? ChatHeaderCell else {
//                return UITableViewCell()
//            }
//            return header
//        }
//        
//        if indexPath.row == chatItems.count + 1 {
//            // Return the footer cell
//            guard let footerView = tableView.dequeueReusableCell(withIdentifier: ChatFooterCell.identifier) as? ChatFooterCell else {
//                return UITableViewCell()
//            }
//            footerView.configure(with: "Answer may display inaccuracy, please always consult a medical professional for advice. Here are some other Things you should know about Dawn.", underlinedText: " Things you should know about Dawn.")
//            return footerView
//        }
//        
//        // Adjust the index for the items array
//        let item = chatItems[indexPath.row - 1]  // Skip the header row
//        
//        // Handle the content based on the type
//        switch item.type {
//        case .question(let questionText):
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: QuestionTableViewCell.identifier) as? QuestionTableViewCell else {
//                return UITableViewCell()
//            }
//            cell.questionLabel.text = questionText
//            return cell
//            
//        case .answer(let answerText):
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: AnswerTableViewCell.identifier) as? AnswerTableViewCell else {
//                return UITableViewCell()
//            }
//            cell.anwerLabel.text = answerText
//            return cell
//            
//        case .bulletPoints(let points, let underlineWords):
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: ResponseTableViewCell.identifier, for: indexPath) as? ResponseTableViewCell else {
//                return UITableViewCell()
//            }
//            cell.configure(with: points, underlineWords: underlineWords)
//            return cell
//            
//        case .loader:
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: LoaderTableViewCell.identifier, for: indexPath) as? LoaderTableViewCell else {
//                return UITableViewCell()
//            }
//            return cell
//        case .feedback:
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedbackTableViewCell.identifier, for: indexPath) as? FeedbackTableViewCell else {
//                return UITableViewCell()
//            }
//            return cell
//        }
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        // Handle row selection if needed
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.row == 0 {
//            return 200.0 // Height for the header
//        }
//        
//        if indexPath.row == chatItems.count + 1 {
//            return 80.0 // Height for the footer
//        }
//        
//        let item = chatItems[indexPath.row - 1] // Skip the header row
//        
//        switch item.type {
//        case .question(let question):
//            let width = tableView.frame.width - 40
//            let height = calculateHeight(forText: question, width: width)
//                return height + 60
//        case .answer(let answerText):
//             let width = tableView.frame.width - 40
//             let height = calculateHeight(forText: answerText, width: width)
//                return height + 60
//        case .bulletPoints(_, _):
//            return 200.0
//        case .loader:
//            return 50.0
//        case .feedback:
//            return 600.0
//        }
//    }
//
//    func calculateHeight(forText text: String, width: CGFloat) -> CGFloat {
//        let label = UILabel()
//        label.numberOfLines = 0  // Allow the label to wrap text
//        label.text = text
//        label.font = UIFont.systemFont(ofSize: 16) // Use the same font as in the cell
//        
//        // Calculate the size based on the text and the provided width
//        let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
//        let requiredSize = label.sizeThatFits(maxSize)
//        
//        return requiredSize.height
//    }
//
//    
//}
//
