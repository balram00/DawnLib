import UIKit
protocol FeedbackTableViewCellDelegate: AnyObject {
    func didTapFeedbackButton(in cell: FeedbackTableViewCell, newStatus: FeedbackType,selectButtonIndex: Int)
    func didUpdateAdditionalFeedback(in cell: FeedbackTableViewCell, newFeedback: String)
}

struct FeedbackItem {
    var index : Int?
    var data: [feedbackData]?
    
    init(index: Int? = nil, data: [feedbackData]? = nil) {
        self.index = index
        self.data = data
    }
}

struct feedbackData {
    var feedbackType: FeedbackType?
    var additionalFeedback: String?
}

var feedbackItems: [FeedbackItem] = []


class FeedbackTableViewCell: UITableViewCell {
    
    static let identifier: String = "FeedbackTableViewCell"
    weak var delegate: FeedbackTableViewCellDelegate?
    
    // Existing IBOutlets
    @IBOutlet var feedbackButtons: [UIButton]!
    @IBOutlet var submitButton: UIButton!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var disLikeButton: UIButton!
    @IBOutlet var additionalFeedbackView: UIView!
    @IBOutlet var thankYouView: UIView!
    @IBOutlet var feedbackView: UIView!
    @IBOutlet var othersFeedbackButton: UIButton!
    @IBOutlet var additionalFeedbackTextView: UITextView!
    @IBOutlet var tellUsMoreLabel: UILabel!
    @IBOutlet var provideAdditionalFeedbackLabel: UILabel!
    
    // Instance variables
    var index: IndexPath?
    var feedBackIndexDict: [Int: FeedbackType] = [:]
    var isAdditisonalFeedbackVisible = false
    var isFeedbackViewIsOpened: Bool = false
    var selectedFeedbackCount: Int = 0
    var isTextViewOpen:Bool? = false
    var feedbackItem: FeedbackItem? // Data model for this cell
    var feedbackIndex: Int?
    var addFeedBackIndexDict: [Int: String] = [:]
    var feedbackselectedButton: Int? = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        startingSetUp()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        screenSetup()
        additionalFeedbackTextView.translatesAutoresizingMaskIntoConstraints = false
        submitButton.layer.cornerRadius = submitButton.frame.height / 2
        disLikeButton.layer.cornerRadius = disLikeButton.frame.height / 2
        likeButton.layer.cornerRadius = likeButton.frame.height / 2
        
        feedbackButtons.forEach { button in
            button.layer.cornerRadius = button.frame.height / 2
            button.applyCustomStyle(
                fontFamily: FontConstants.arail,
                fontSize: FontSize.regular.rawValue,
                lineHeight: 40,
                textColorHex: "#424243",
                alignment: .left
            )
        }
        [additionalFeedbackTextView, feedbackView].forEach { view in
            view.layer.cornerRadius = 10
            view.layer.borderWidth = 1
            view.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    func configure(with feedbackItem: FeedbackItem) {
        self.feedbackItem = feedbackItem
        
        // Set additional feedback from the dictionary if available
        if let index = index?.row, let feedbackText = addFeedBackIndexDict[index] {
            additionalFeedbackTextView.text = feedbackText
            additionalFeedbackTextView.textColor = feedbackText.isEmpty ? .lightGray : .black
        } else {
            // Default text when there is no saved feedback
            additionalFeedbackTextView.text = "Provide additional feedback..."
            additionalFeedbackTextView.textColor = .lightGray
        }
        
        // Call screenSetup to restore the UI state based on the feedback
        screenSetup()
    }
    
    //MARK: - Actions
    
    @IBAction func likeTapped(_ sender: UIButton) {
        updatingLikeDislikeButtonBGColor(state: .like)
        delegate?.didTapFeedbackButton(in: self, newStatus: .liked, selectButtonIndex: 0)
    }
    
    @IBAction func disLikeTapped(_ sender: UIButton) {
        updatingLikeDislikeButtonBGColor(state: .dislike)
        delegate?.didTapFeedbackButton(in: self, newStatus: .feedback, selectButtonIndex: 0)
    }
    
    @IBAction func closeTapped(_ sender: UIButton) {
        closedFeedback()
        delegate?.didTapFeedbackButton(in: self, newStatus: .closed, selectButtonIndex: 0)
    }
    
    @IBAction func didNotProvideAnswerTapped(_ sender: UIButton) {
        updateButtonBackgroundColor(sender)
    }
    
    @IBAction func notRelevantTapped(_ sender: UIButton) {
        updateButtonBackgroundColor(sender)
    }
    
    @IBAction func notFactuallyCorrectTapped(_ sender: UIButton) {
        updateButtonBackgroundColor(sender)
    }
    
    @IBAction func didNotLikeTheAnswerTapped(_ sender: UIButton) {
        updateButtonBackgroundColor(sender)
    }
    
    @IBAction func didNotLikeTheStyleTapped(_ sender: UIButton) {
        updateButtonBackgroundColor(sender)
    }
    
    @IBAction func othersTapped(_ sender: UIButton) {
        selectedOtherFeedback()
    }
    
    @IBAction func submitTapped(_ sender: UIButton) {
        submitButton.setTitle("Please wait ..", for: .normal)
        self.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.delegate?.didTapFeedbackButton(in: self, newStatus: .disliked, selectButtonIndex: 0)
        }
    }
    
    //MARK: - Functions
    func startingSetUp() {
        feedbackselectedButton = 0
        additionalFeedbackTextView.delegate = self
        additionalFeedbackTextView.returnKeyType = .done
        thankYouView.layer.cornerRadius = 10
        feedbackView.isHidden = true
        additionalFeedbackView.isHidden = true
        thankYouView.isHidden = true
        likeButton.backgroundColor = UIColor.palette.feedBackButtonColor
        disLikeButton.backgroundColor = UIColor.palette.feedBackButtonColor
        likeButton.setImage(ConstantImage.likeBlack, for: .normal)
        disLikeButton.setImage(ConstantImage.dislikeBlack, for: .normal)
        feedbackButtons.forEach { button in
            button.backgroundColor = UIColor.palette.feedBackButtonColor
            button.tintColor = .black
        }
        submitButton.setTitle("Submit", for: .normal)
        othersFeedbackButton.tintColor = .black
        submitButton.layer.backgroundColor = UIColor.palette.primaryColor.cgColor
    }
    
    func updatingLikeDislikeButtonBGColor(state: ButtonState) {
        likeButton.isSelected = state == .like ? true : false
        disLikeButton.isSelected = state == .dislike ? true : false
        feedbackView.isHidden = state == .like ? true : false
        disLikeButton.isSelected = state == .dislike ? true : false
        likeButton.backgroundColor = state == .like ? UIColor.palette.primaryColor : UIColor.palette.feedBackButtonColor
        disLikeButton.backgroundColor = state == .dislike ? UIColor.palette.primaryColor : UIColor.palette.feedBackButtonColor
        likeButton.setImage(state == .like ? ConstantImage.likeWhite : ConstantImage.likeBlack, for: .normal)
        disLikeButton.setImage(state == .dislike ? ConstantImage.dislikeWhite : ConstantImage.dislikeBlack, for: .normal)
    }
    
    func closedFeedback() {
        likeButton.isSelected = false
        disLikeButton.isSelected = false
        likeButton.backgroundColor = UIColor.palette.feedBackButtonColor
        disLikeButton.backgroundColor = UIColor.palette.feedBackButtonColor
        likeButton.setImage(ConstantImage.likeBlack, for: .normal)
        disLikeButton.setImage(ConstantImage.dislikeBlack, for: .normal)
    }
    
    func configure(with text: String, delegate: UITextViewDelegate) {
        additionalFeedbackTextView.text = text
        additionalFeedbackTextView.delegate = delegate
    }
    
    func screenSetup() {
        self.isUserInteractionEnabled = true
        feedBackIndexDict.forEach({ (key, value) in
            if index?.row == key {
                switch value {
                case .closed:
                    feedbackView.isHidden = true
                    thankYouView.isHidden = true
                    additionalFeedbackView.isHidden = true
                    closedFeedback()
                    
                case .feedback:
                    feedbackView.isHidden = false
                    thankYouView.isHidden = true
                    additionalFeedbackView.isHidden = true
                    feedbackButtons.forEach { button in
                        if button.tag != feedbackselectedButton {
                            button.layer.backgroundColor = UIColor.palette.feedBackButtonColor.cgColor
                            button.tintColor = .black
                        }else {
                            button.layer.backgroundColor = UIColor.palette.primaryColor.cgColor
                            button.tintColor = .white
                            selectedFeedbackCount = 1
                        }
                    }                    
                case .othersFeedback:
                    feedbackView.isHidden = false
                    thankYouView.isHidden = true
                    othersFeedbacksetup()
                    additionalFeedbackView.isHidden = false
                    
                case .liked:
                    feedbackView.isHidden = true
                    additionalFeedbackView.isHidden = true
                    thankYouView.isHidden = false
                    updatingLikeDislikeButtonBGColor(state: .like)
                case .disliked:
                    feedbackView.isHidden = true
                    additionalFeedbackView.isHidden = true
                    thankYouView.isHidden = false
                    updatingLikeDislikeButtonBGColor(state: .dislike)
                    feedbackView.isHidden = true
                    additionalFeedbackView.isHidden = true
                }
            }
        })
    }
    
    func othersFeedbacksetup() {
        feedbackButtons.forEach { button in
            button.layer.backgroundColor = UIColor.palette.feedBackButtonColor.cgColor
            button.tintColor = .black
        }
        othersFeedbackButton.layer.backgroundColor = UIColor.palette.primaryColor.cgColor
        othersFeedbackButton.tintColor = .white
    }
    
    
    func selectedOtherFeedback() {
        feedbackButtons.forEach { button in
            button.layer.backgroundColor = UIColor.palette.feedBackButtonColor.cgColor
            button.tintColor = .black
        }
        additionalFeedbackView.isHidden = false
        othersFeedbackButton.backgroundColor = UIColor.palette.primaryColor
        othersFeedbackButton.tintColor = .white
        delegate?.didTapFeedbackButton(in: self, newStatus: .othersFeedback, selectButtonIndex: 0)
    }
    
    func updateButtonBackgroundColor(_ button: UIButton) {
        othersFeedbackButton.layer.backgroundColor = UIColor.palette.feedBackButtonColor.cgColor
        othersFeedbackButton.tintColor = .black
        
        let isCurrentlySelected = button.backgroundColor?.cgColor == UIColor.palette.primaryColor.cgColor
        
        if isCurrentlySelected {
            button.backgroundColor = UIColor.palette.feedBackButtonColor.withAlphaComponent(1)
            button.tintColor = .black
            selectedFeedbackCount -= 1
        } else {
            guard selectedFeedbackCount < 3 else { return }
            button.backgroundColor = UIColor.palette.primaryColor.withAlphaComponent(1)
            button.tintColor = .white
            selectedFeedbackCount += 1
        }
        
        button.setNeedsLayout()
        button.layoutIfNeeded()
        
        if additionalFeedbackView.isHidden == false {
            additionalFeedbackView.isHidden = true
            delegate?.didTapFeedbackButton(in: self, newStatus: .feedback, selectButtonIndex: button.tag)
        }
    }
}

extension FeedbackTableViewCell: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "(optional) Feel free to add specific detail" {
            textView.text = ""
            textView.textColor = .black
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text != "\n" && textView.text != "" {
            guard let index = index?.row else { return }
            let feedbackText = textView.text.isEmpty ? "(optional) Feel free to add specific detail" : textView.text
            addFeedBackIndexDict[index] = feedbackText
            delegate?.didUpdateAdditionalFeedback(in: self, newFeedback: feedbackText ?? "")
        }else {
            textView.resignFirstResponder()
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard let index = index?.row else { return }
        if let text = textView.text, text.hasSuffix("\n") {
            textView.resignFirstResponder()
        }else {
            let feedbackText = textView.text.isEmpty ? "(optional) Feel free to add specific detail" : textView.text
            
            addFeedBackIndexDict[index] = feedbackText
            delegate?.didUpdateAdditionalFeedback(in: self, newFeedback: feedbackText ?? "")
        }
   
    }
    
}

