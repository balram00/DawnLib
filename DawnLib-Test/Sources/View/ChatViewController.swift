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
    // MARK: - Life Cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        inputTextView.tag = 0
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
        questionTableView.sectionHeaderHeight = UITableView.automaticDimension
        questionTableView.sectionFooterHeight = UITableView.automaticDimension
        questionTableView.estimatedSectionHeaderHeight = 0
        questionTableView.estimatedSectionFooterHeight = 0
        
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
    
    @objc func doneButtonTapped() {
        inputTextView.resignFirstResponder() // Dismiss the keyboard
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc public func keyboardWillShow(_ notification: Notification){
        scrollToBottom()
        if let keyboardFrame = (
            notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        )?.cgRectValue {
            let keyboardHeight = keyboardFrame.height
            customInputViewBottomConstraint.constant = -keyboardHeight
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            self.questionTableView.reloadData()
        }
    }
    
    
    @objc public func keyboardWillHide(_ notification: Notification){
        customInputViewBottomConstraint.constant = 0
        UIView
            .animate(
                withDuration: 0
            ) {
                self.view
                    .layoutIfNeeded()
            }
        self.questionTableView.reloadData()
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
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.questionTableView.frame.width, height: 200))
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
    
    func adjustForKeyboardShow(keyboardHeight: CGFloat) {
        customInputViewBottomConstraint.constant = -keyboardHeight
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            self.questionTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
            self.questionTableView.scrollIndicatorInsets = self.questionTableView.contentInset
        }
    }
    
    func adjustForKeyboardHide() {
        customInputViewBottomConstraint.constant = 0
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            self.questionTableView.contentInset = .zero
            self.questionTableView.scrollIndicatorInsets = .zero
        } completion: { _ in
            self.questionTableView.reloadData() // Refresh layout
        }
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
            
            cell.configure(with:"For improving your sleep and addressing your tiredness, you may consider the following:\n\n- Establish a consistent sleep schedule by going to bed and waking up at the same time each day.\n- Create a peaceful sleep environment; keep the room dark, cool, and quiet to facilitate better rest.\n- Limit screen time before bed to reduce blue light exposure and engage in calming activities like reading or meditation.\n\nFor a holistic view of your sleep health and to identify risk factors, consider taking our [sleep assessment](https://www.resmed.com.au/online-sleep-assessment). Our fun AI [SelfieScreener](https://www.resmed.com.au/selfie-screener) tool can provide insights into your sleep health in just minutes. Always consult with a licensed healthcare professional for medical advice, diagnosis and treatment options" )
//            chatItem?.bulletPoints ?? [String]()
            
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
            cell.additionalFeedbackTextView.delegate = self
            cell.screenSetup()
            cell.delegate = self
//            let feedbackItem = feedbackItems[indexPath.row]

//            cell.configure(with: feedbackItem)
            
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
        case .answer: break
        case .bulletPoints: break

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
                return 50.0
            }
            let width = tableView.frame.width - 40
            let height = calculateHeight(
                forText: bulletPoints.joined(separator: "\n"),
                width: width
            )
            return 800
            
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
                return 120.0
            }
        case .none:
            return 0
        case .some(_):
            return 0
        }
    }
    
    func calculateHeight(forText text: String, width: CGFloat, font: UIFont? = UIFont.systemFont(ofSize: 16), lineHeight: CGFloat? = 23) -> CGFloat {
        // Define the maximum size constraint
        let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = lineHeight ?? 0.0
        paragraphStyle.maximumLineHeight = lineHeight ?? 0.0
        
        // Define the attributes for the text, including the font and paragraph style
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font as Any,
            .paragraphStyle: paragraphStyle
        ]
        
        let boundingRect = (text as NSString).boundingRect(
            with: maxSize,
            options: .usesLineFragmentOrigin,
            attributes: attributes,
            context: nil
        )
    
        return max(boundingRect.height , 80)
    }
    
    
}

extension ChatViewController: UITextViewDelegate {
    
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.tag == 0 {
            scrollToBottom()
            DispatchQueue.main.async {
                self.chatInputView.layer.borderWidth = 1
                self.chatInputView.layer.borderColor = UIColor.palette.primaryColor.cgColor
                self.sendButton.layer.backgroundColor = UIColor.palette.primaryColor.cgColor
            }
            
            if textView.text == PlaceholderText.askAQuestionPlaceholder {
                textView.text = ""
                textView.textColor = .black
            }
            return true
        } else if textView.tag == 1 {
            guard let cellPosition = textView.superview?.convert(CGPoint.zero, to: questionTableView),
                    let indexPath = questionTableView.indexPathForRow(at: cellPosition) else {
                  return true
              }

              // Store the currently active index path (optional)
              activeIndexPath = indexPath

              // Focus on the text view
              return true
        }
        
        return false
    }

    
    public func textViewDidEndEditing(_ textView: UITextView) {
        if textView.tag == 0 {
            chatInputView.layer.borderColor = UIColor.clear.cgColor
            sendButton.layer.backgroundColor = UIColor.systemGray4.cgColor
            
            if textView.text.isEmpty {
                textView.text = PlaceholderText.askAQuestionPlaceholder
                textView.textColor = .darkGray
            }
        } else if textView.tag == 1 {
            guard let cellPosition = textView.superview?.convert(CGPoint.zero, to: questionTableView),
                  let indexPath = questionTableView.indexPathForRow(at: cellPosition) else {
                  return
              }
        }
    }

    
    public func textViewShouldReturn(_ textView: UITextView) -> Bool {
        if textView.tag == 0 {
            textView.resignFirstResponder()
            return true
        }else {
            textView.resignFirstResponder()
            return true
        }
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        if let cell = textView.superview?.superview as? FeedbackTableViewCell,
           let indexPath = cell.index {
            // Update the feedback item with the text
            print("sv")
        }
    }
    
    public func textView(_ textView: UITextView,shouldChangeTextIn range: NSRange,replacementText text: String) ->Bool {
        let currentText = textView.text ?? ""
        let updatedText = (
            currentText as NSString
        ).replacingCharacters(
            in: range,
            with: text
        )
        return true
    }
}

extension ChatViewController: FeedbackTableViewCellDelegate,ResponseTableViewDelegate {
    func didUpdateAdditionalFeedback(in cell: FeedbackTableViewCell, newFeedback: String) {
        // Handle the updated additional feedback text
        guard let indexPath = questionTableView.indexPath(for: cell) else { return }
        
        // Update the specific feedbackItem at the given indexPath
        feedbackItems[indexPath.row].data?[0].additionalFeedback = newFeedback
        
        // Optionally reload the cell to reflect changes
        questionTableView.reloadRows(at: [indexPath], with: .none)
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
        guard let indexPath = cell.index else { return }
        
        if cell.isTextViewOpen == false {
            // Update the status in the data model
            viewModel.feedBackIndexDict[indexPath.row] = newStatus
            
            // Only reload if the text view is not open
            questionTableView.reloadRows(at: [indexPath], with: .none)
        } else {
            // Text view is open, so directly update the status in the data model
            viewModel.feedBackIndexDict[indexPath.row] = newStatus

            // Do not reload the cell; allow the user to continue typing
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
        
        
        DispatchQueue.main.async {
            let popupView = PopupView.load(frame: CGRect(x: 20, y: safePopupY + contentHeight, width: self.view.frame.width - 40, height: contentHeight + 40))
            popupView.contentLabel.text = content
            popupView.tag = 1
            self.view.addSubview(popupView)
            
        }
    }
}

