import UIKit
protocol FeedbackTableViewCellDelegate: AnyObject {
    func didTapFeedbackButton(in cell: FeedbackTableViewCell, newStatus: FeedbackType)
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

    override func awakeFromNib() {
        super.awakeFromNib()
        startingSetUp()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
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
         
         // Assuming we have a single `feedbackData` in `data`
         if let feedbackData = feedbackItem.data?.first {
             additionalFeedbackTextView.text = feedbackData.additionalFeedback ?? "Provide additional feedback..."
             additionalFeedbackTextView.textColor = feedbackData.additionalFeedback?.isEmpty == true ? .lightGray : .black
         }
     }

    //MARK: - Actions
    
    @IBAction func likeTapped(_ sender: UIButton) {
        updatingLikeDislikeButtonBGColor(state: .like)
        delegate?.didTapFeedbackButton(in: self, newStatus: .liked)
    }
    
    @IBAction func disLikeTapped(_ sender: UIButton) {
        updatingLikeDislikeButtonBGColor(state: .dislike)
        delegate?.didTapFeedbackButton(in: self, newStatus: .feedback)
    }
    
    @IBAction func closeTapped(_ sender: UIButton) {
        closedFeedback()
        delegate?.didTapFeedbackButton(in: self, newStatus: .closed)
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
            self.delegate?.didTapFeedbackButton(in: self, newStatus: .disliked)
        }
    }
        
    //MARK: - Functions
    func startingSetUp() {
//        additionalFeedbackTextView.delegate = self
        additionalFeedbackTextView.isUserInteractionEnabled = true
        additionalFeedbackTextView.isEditable = true
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
//                    feedbackButtons.forEach { button in
//                        button.layer.backgroundColor = UIColor.palette.feedBackButtonColor.cgColor
//                        button.tintColor = .black
//                    }
                    updatingLikeDislikeButtonBGColor(state: .dislike)
                    
                case .othersFeedback:
                    selectedOtherFeedback()
                    feedbackView.isHidden = false
                    thankYouView.isHidden = true
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
    
    func selectedOtherFeedback() {
        feedbackButtons.forEach { button in
            button.layer.backgroundColor = UIColor.palette.feedBackButtonColor.cgColor
            button.tintColor = .black
        }
        additionalFeedbackView.isHidden = false
        othersFeedbackButton.backgroundColor = UIColor.palette.primaryColor
        othersFeedbackButton.tintColor = .white
        delegate?.didTapFeedbackButton(in: self, newStatus: .othersFeedback)
    }
    
    func updateButtonBackgroundColor(_ button: UIButton) {
        othersFeedbackButton.layer.backgroundColor = UIColor.palette.feedBackButtonColor.cgColor
        othersFeedbackButton.tintColor = .black

        // Ensure proper color comparison
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
        
        // Update the UI immediately
        button.setNeedsLayout()
        button.layoutIfNeeded()

        if additionalFeedbackView.isHidden == false {
            additionalFeedbackView.isHidden = true
            delegate?.didTapFeedbackButton(in: self, newStatus: .feedback)
        }
    }

    


}


extension FeedbackTableViewCell: UITextViewDelegate {
    // MARK: - UITextViewDelegate methods
       func textViewDidBeginEditing(_ textView: UITextView) {
           if textView.text == "Provide additional feedback..." {
               textView.text = ""
               textView.textColor = .black
           }
       }

       func textViewDidEndEditing(_ textView: UITextView) {
           // Update the feedbackItem model with the new feedback text
           if let feedbackText = textView.text, let index = feedbackItem?.index {
               feedbackItem?.data?[0].additionalFeedback = feedbackText
               delegate?.didUpdateAdditionalFeedback(in: self, newFeedback: feedbackText)
           }
       }
       
       func textViewDidChange(_ textView: UITextView) {
           // Live update the additional feedback text
           delegate?.didUpdateAdditionalFeedback(in: self, newFeedback: textView.text)
       }

}
