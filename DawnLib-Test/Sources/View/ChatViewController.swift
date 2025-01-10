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
    var activeIndexPath: IndexPath?
    var feedbackItems: [FeedbackItem] = []
    var activeTextView: UITextView?
    // MARK: - Life Cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        inputTextView.tag = 0
        setUpNavbar()
        setUpTableView()
        //        addDoneButtonToKeyboard()
        setUpNotificationObservers()
        setUpHeaderndFooter()
        print("questionTableView.frame.height",self.questionTableView.frame.height)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        inputTextView.returnKeyType = .done
        questionTableView.keyboardDismissMode = .onDrag
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
    
    @objc func doneButtonTapped() {
        inputTextView.resignFirstResponder()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    public static func instantiate() -> ChatViewController? {
        let storyboard = UIStoryboard(name: StoryboardConstants.mainStoryboardName, bundle: nil)
        
        guard let viewController = storyboard.instantiateViewController(withIdentifier: StoryboardConstants.chatViewControllerIdentifier) as? ChatViewController else {
            return nil
        }
        return viewController
    }
    
    
    func setUpHeaderndFooter() {
        let tableViewHeader = ChatHeaderView.load(frame: CGRect(x: 0, y: 0, width: questionTableView.frame.width, height: 150))
        questionTableView.tableHeaderView = tableViewHeader
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.questionTableView.frame.width, height: 150))
        footerView.backgroundColor = .clear
        
        let footerLabel = UILabel(frame: footerView.bounds)
        footerLabel.textAlignment = .center
        footerLabel.numberOfLines = 0
        footerLabel.configureFooterText(
            text: FooterText.description,
            underlinedText: FooterText.underlinedText,
            fontFamily: FontConstants.robotoRegular,
            fontSize: FontSize.small.rawValue,
            lineHeight: 23,
            alignment: .center
        )
        footerView.addSubview(footerLabel)
        self.questionTableView.tableFooterView = footerView
    }
    
    func setUpTableView() {
        inputTextView.delegate = self
        
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
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: ButtonTitles.doneButtonTitle, style: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.items = [flexibleSpace, doneButton]
        inputTextView.inputAccessoryView = toolbar
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
    
    func scrollToBottom() {
        DispatchQueue.main.async {
            self.questionTableView.layoutIfNeeded()
            let lastRow = self.questionTableView.numberOfRows(inSection: 0) - 1
            if lastRow >= 0 {
                let indexPath = IndexPath(row: lastRow, section: 0)
                self.questionTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        fetchChatData()
    }
    
    func fetchChatData(text:String? = nil) {
        let questionText = text != nil ? text : inputTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        inputTextView.text == PlaceholderText.askAQuestionPlaceholder
        inputTextView.textColor = .systemGray4
        viewModel.addingAnswer(selectedQuestion: questionText ?? "")
        view.isUserInteractionEnabled = false
        DispatchQueue.main.async {
            self.scrollToBottom()
            self.questionTableView.reloadData()
        }
        //        if chatItem?.pre_defined == false || chatItem?.pre_defined == nil {
        //            viewModel.jsonResponse?.remove(at: indexPath.row)
        //        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.viewModel.fetchDataAndDisplay(question: questionText)
            if let index = self.viewModel.jsonResponse?.firstIndex(where: { $0.type == .loader }) {
                self.viewModel.jsonResponse?.remove(at: index)
                self.view.isUserInteractionEnabled = true
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
            cell.configure(with:chatItem?.bulletPoints ?? [String]())
            
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
            cell.feedbackselectedButton = viewModel.feedbackselectedButton
            cell.addFeedBackIndexDict = viewModel.addFeedBackIndexDict
            cell.feedBackIndexDict = viewModel.feedBackIndexDict
            //            cell.additionalFeedbackTextView.delegate = self
            cell.screenSetup()
            cell.delegate = self
            
            return cell
        case .none:
            return UITableViewCell()
        case .some(_):
            return UITableViewCell()
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let chatItem = viewModel.jsonResponse?[indexPath.row]
        
        switch chatItem?.type {
        case .question:
            fetchChatData(text: chatItem?.question)
        case .answer:
            print("efsgdb")
        case .bulletPoints:
            print("ffffffff")
            if let visibleIndexPaths = questionTableView.indexPathsForVisibleRows, visibleIndexPaths.contains(indexPath) {
                let cellFrame = questionTableView.rectForRow(at: indexPath)
                let cellFrameInVC = questionTableView.convert(cellFrame, to: self.view)
                let popupLocation = CGPoint(x: cellFrameInVC.midX, y: cellFrameInVC.maxY)
                showPopup(at: popupLocation)
            }
            
        default:
            break
        }
    }
    
    
    public func tableView(_ tableView: UITableView,heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let item = viewModel.jsonResponse?[indexPath.row]
        
        switch item?.type {
        case .question:
            let height = viewModel.calculateCellHeight(
                forText: item?.question ?? "")
            return height
            
        case .answer:
            
            let height = viewModel.calculateCellHeight(
                forText: item?.question ?? ""
            )
            return height
            
        case .bulletPoints:
            guard let bulletPoints = item?.bulletPoints else {
                return 50.0
            }
            let markdownText = bulletPoints.joined(separator: "\n")
            let containerWidth = tableView.frame.width - 40 // Adjust for padding/margins
            return viewModel.calculateMarkdownHeight(
                markdownText: markdownText,
                containerWidth: containerWidth
            )
            
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
                return FeedbackType.disliked.height
            }else {
                return 60.0
            }
        case .none:
            return 0
        case .some(_):
            return 0
        }
    }
    
    func convertMarkdownToAttributedString(markdown: String, attributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        // Convert markdown string to HTML format
        let htmlString = markdown.replacingOccurrences(of: "\n", with: "<br>") // Handle line breaks for HTML
        
        // Wrap the HTML in basic formatting to ensure markdown elements (like links) are rendered correctly
        let wrappedHTML = "<html><body style=\"font-family: \(attributes[.font] as? UIFont ?? UIFont.systemFont(ofSize: 16)).fontName; font-size: 16px;\">\(htmlString)</body></html>"
        
        // Convert the wrapped HTML to data
        guard let data = wrappedHTML.data(using: .utf8) else {
            return NSAttributedString(string: markdown, attributes: attributes) // Return plain attributed string if parsing fails
        }
        
        do {
            // Try to convert the HTML data to an attributed string
            let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ]
            
            let attributedString = try NSAttributedString(data: data, options: options, documentAttributes: nil)
            return attributedString
        } catch {
            // If conversion fails, return plain attributed string
            return NSAttributedString(string: markdown, attributes: attributes)
        }
    }
    
    
}

extension ChatViewController: UITextViewDelegate {
    
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.tag == 0 {
            // Scroll to the bottom when editing begins
            scrollToBottom()
            
            // Highlight the input area for the active text view
            DispatchQueue.main.async {
                self.chatInputView.layer.borderWidth = 1
                self.chatInputView.layer.borderColor = UIColor.palette.primaryColor.cgColor
                self.sendButton.layer.backgroundColor = UIColor.palette.primaryColor.cgColor
            }
            
            // Clear placeholder text
            if textView.text == PlaceholderText.askAQuestionPlaceholder {
                textView.text = ""
                textView.textColor = .black
            }
            
            return true
        }
        
        return true
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        activeTextView = textView
        
        switch textView.tag {
        case 0:
            scrollToBottom()
            handleKeyboardVisibility(for: textView, isKeyboardShowing: true, notification: nil)
        default:
            break
        }
        
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        if textView.tag == 0 {
            print(textView.text)
            
            if textView.text != "\n" && textView.text != "" {
                fetchChatData()
            }else {
                textView.resignFirstResponder()
            }
            
            // Reset the appearance for the input area
            chatInputView.layer.borderColor = UIColor.clear.cgColor
            sendButton.layer.backgroundColor = UIColor.systemGray4.cgColor
            textView.text = PlaceholderText.askAQuestionPlaceholder
            textView.textColor = .darkGray
        }
        
        
        activeTextView = nil
        
        handleKeyboardVisibility(for: textView, isKeyboardShowing: false, notification: nil)
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        if let text = textView.text, text.hasSuffix("\n") {
            textView.resignFirstResponder()
        }
    }
    
    // Function to handle keyboard appearance/disappearance based on active text view
    private func handleKeyboardVisibility(for textView: UITextView, isKeyboardShowing: Bool, notification: Notification?) {
        if let textView = activeTextView {
            switch textView.tag {
            case 0:
                // Handle first text view keyboard appearance
                if isKeyboardShowing {
                    scrollToBottom()  // Scroll to the bottom when keyboard appears
                    if let keyboardFrame = (notification?.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                        let keyboardHeight = keyboardFrame.height
                        customInputViewBottomConstraint.constant = -keyboardHeight
                        UIView.animate(withDuration: 0.3) {
                            self.view.layoutIfNeeded()
                        }
                    }
                } else {
                    // Reset input view when keyboard hides
                    customInputViewBottomConstraint.constant = 0
                    UIView.animate(withDuration: 0) {
                        self.view.layoutIfNeeded()
                    }
                }
                
                
            default:
                break
            }
        }
        questionTableView.reloadData()
    }
    
    @objc public func keyboardWillShow(_ notification: Notification) {
        // Handle keyboard appearance globally
        if let textView = activeTextView {
            handleKeyboardVisibility(for: textView, isKeyboardShowing: true, notification: notification)
        }
    }
    
    @objc public func keyboardWillHide(_ notification: Notification) {
        // Handle keyboard disappearance globally
        if let textView = activeTextView {
            handleKeyboardVisibility(for: textView, isKeyboardShowing: false, notification: notification)
        }
    }
    
}

extension ChatViewController: FeedbackTableViewCellDelegate,ResponseTableViewDelegate {
    func didUpdateAdditionalFeedback(in cell: FeedbackTableViewCell, newFeedback: String) {
        guard let indexPath = questionTableView.indexPath(for: cell) else { return }
        
        viewModel.addFeedBackIndexDict[indexPath.row] = newFeedback
    }
    
    
    func labelTapped(in cell: ResponseTableViewCell, tappedWord: String,at location: CGPoint) {
        print(tappedWord)
        //        showPopup(at: location)
        showPopup(at: location)
    }
    
    func animationCompleted(in cell: ResponseTableViewCell) {
        if let row = cell.index?.row    {
            if !viewModel.ResponseIndexDict.keys.contains(row) {
                viewModel.ResponseIndexDict[row] = true
            }
        }
    }
    
    func didTapFeedbackButton(in cell: FeedbackTableViewCell, newStatus: FeedbackType,selectButtonIndex: Int) {
        guard let indexPath = cell.index else { return }
        viewModel.feedbackselectedButton = selectButtonIndex

        if cell.isTextViewOpen == false {
            viewModel.feedBackIndexDict[indexPath.row] = newStatus
            
            questionTableView.reloadRows(at: [indexPath], with: .none)
        } else {
            viewModel.feedBackIndexDict[indexPath.row] = newStatus
            
            print("TextView is open, status updated in the model only.")
        }
    }
    
    
    func showPopup(at location: CGPoint) {
        // Remove any existing popup
        view.subviews.filter { $0.tag == 1 }.forEach { $0.removeFromSuperview() }
        // Popup size
        let popupHeight: CGFloat = 200
        // Calculate Y position
        let popupY: CGFloat
        let content = PopupMessages.passwordCreationMessage
        let width = self.view.frame.width - 40
        let contentHeight = viewModel.calculateCellHeight(
            forText: content
        )
        
        if location.y + contentHeight + 50 > view.bounds.height {
            popupY = location.y - 250
        } else {
            popupY = location.y + 50
        }
        
        // Ensure the popup is within the screen bounds
        let safePopupY = max(0, min(popupY,view.bounds.height - popupHeight))
        
        
        DispatchQueue.main.async {
            let popupView = PopupView.load(frame: CGRect(x: 20, y: safePopupY + contentHeight + 30, width: self.view.frame.width - 40, height: contentHeight + 40))
            popupView.contentLabel.text = content
            popupView.tag = 1
            self.view.addSubview(popupView)
            
        }
    }
}

