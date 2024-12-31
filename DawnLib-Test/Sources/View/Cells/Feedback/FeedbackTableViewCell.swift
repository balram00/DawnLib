//
//  FeedbackTableViewCell.swift
//  Sample POC
//
//  Created by bitcot on 23/12/24.
//

import UIKit

protocol FeedbackTableViewCellDelegate: AnyObject {
    func didTapOthersButton(in cell: FeedbackTableViewCell)
}

class FeedbackTableViewCell: UITableViewCell {
    
    static let identifier: String = "FeedbackTableViewCell"
    weak var delegate: FeedbackTableViewCellDelegate?
    
    @IBOutlet var feedbackButtons: [UIButton]!
    @IBOutlet var submitButton: UIButton!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var disLikeButton: UIButton!
    @IBOutlet var additionalFeedbackView: UIView!
    @IBOutlet var feedbackView: UIView!
    @IBOutlet var othersFeedbackButton: UIButton!
    @IBOutlet var additionalFeedbackTextView: UITextView!
    @IBOutlet var tellUsMoreLabel: UILabel!
    @IBOutlet var provideAdditionalFeedbackLabel: UILabel!
    
    var index: IndexPath?
    var feedBackIndexDict: [Int: FeedbackType] = [:]
    var isAdditisonalFeedbackVisible = false
    var isFeedbackViewIsOpened: Bool = false
    var selectedFeedbackCount: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let iconImage = UIImage(named: "disLike")?.withRenderingMode(.alwaysTemplate) // Ensures icon is tinted
        submitButton.setImage(iconImage, for: .normal)

        submitButton.layer.cornerRadius = submitButton.frame.height / 2
        disLikeButton.layer.cornerRadius = disLikeButton.frame.height / 2
        likeButton.layer.cornerRadius = likeButton.frame.height / 2
        
        feedbackButtons.forEach { button in
            button.layer.cornerRadius = button.frame.height / 2
            button.applyCustomStyle(
                fontFamily:FontConstants.arail,
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

    //MARK: - Actions
    
    @IBAction func likeTapped(_ sender: UIButton) {
        updatingLikeDislikeButtonBGColor(senderButton: "like")

//        changingStatus(status: .liked)
//        likeButton.isSelected = true
//        disLikeButton.isSelected = false
//        feedbackView.isHidden = true
//        additionalFeedbackView.isHidden = true
//        likeButton.backgroundColor = likeButton.isSelected ? UIColor.palette.primaryColor : UIColor.palette.feedBackButtonColor
//        disLikeButton.backgroundColor = disLikeButton.isSelected ? UIColor.palette.primaryColor : UIColor.palette.feedBackButtonColor
//        likeButton.setImage(likeButton.isSelected ? UIImage(named: "likeWhite") : UIImage(named: "likeBlack"), for: .normal)
//        disLikeButton.setImage(UIImage(named: "disLikeBlack"), for: .normal)
//        likeButton.tintColor = .white
//        disLikeButton.tintColor = .black
//        delegate?.didTapOthersButton(in: self)
    }
    
    @IBAction func disLikeTapped(_ sender: UIButton) {
        updatingLikeDislikeButtonBGColor(senderButton: "dislike")
//        changingStatus(status: .feedback)
//        disLikeButton.isSelected = true
//        likeButton.isSelected = false
//        feedbackView.isHidden = false
//        disLikeButton.backgroundColor = disLikeButton.isSelected ? UIColor.palette.primaryColor : UIColor.palette.feedBackButtonColor
//        disLikeButton.setImage(disLikeButton.isSelected ? UIImage(named: "disLikeWhite") : UIImage(named: "disLikeBlack"), for: .normal)
//        likeButton.setImage(UIImage(named: "likeBlack"), for: .normal)
//
//        likeButton.backgroundColor = likeButton.isSelected ? UIColor.palette.primaryColor : UIColor.palette.feedBackButtonColor
//        disLikeButton.tintColor = .white
//        likeButton.tintColor = .black
//        
//        delegate?.didTapOthersButton(in: self)
    }
    
    @IBAction func didntProvideAnswerTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        updateButtonBackgroundColor(sender)
//        delegate?.didTapOthersButton(in: self)
    }
    
    @IBAction func notRelevantTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        updateButtonBackgroundColor(sender)
//        delegate?.didTapOthersButton(in: self)
    }
    
    @IBAction func notFactuallyCorrectTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        updateButtonBackgroundColor(sender)
//        delegate?.didTapOthersButton(in: self)
    }
    
    @IBAction func didntLikeAnswerTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        updateButtonBackgroundColor(sender)
//        delegate?.didTapOthersButton(in: self)
    }
    
    @IBAction func didntLikeStyleTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        updateButtonBackgroundColor(sender)
//        delegate?.didTapOthersButton(in: self)
    }
    
    @IBAction func closeTapped(_ sender: UIButton) {
        startingSetUp()
        delegate?.didTapOthersButton(in: self)
    }
    
    @IBAction func othersTapped(_ sender: UIButton) {
        selectedOtherFeedback()
    }
    
    //MARK: - Funtions
    
    func startingSetUp() {
        changingStatus(status: .closed)
        feedbackView.isHidden = true
        likeButton.backgroundColor = UIColor.palette.feedBackButtonColor
        disLikeButton.backgroundColor = UIColor.palette.feedBackButtonColor
        likeButton.setImage(UIImage(named: "likeBlack"), for: .normal)
        disLikeButton.setImage(UIImage(named: "disLikeBlack"), for: .normal)
    }
    
    func updatingLikeDislikeButtonBGColor(senderButton:String) {
        changingStatus(status: senderButton == "like" ? .liked : .feedback)
        likeButton.isSelected = senderButton == "like" ? true : false
        disLikeButton.isSelected = senderButton == "dislike" ? true : false
        feedbackView.isHidden = senderButton == "like" ? true : false
//      additionalFeedbackView.isHidden = senderButton == "like" ? true : nil
        disLikeButton.isSelected = senderButton == "dislike" ? true : false
        likeButton.backgroundColor = senderButton == "like" ? UIColor.palette.primaryColor : UIColor.palette.feedBackButtonColor
        disLikeButton.backgroundColor = senderButton == "dislike" ? UIColor.palette.primaryColor : UIColor.palette.feedBackButtonColor
        likeButton.setImage(senderButton == "like" ? UIImage(named: "likeWhite") : UIImage(named: "likeBlack"), for: .normal)
        disLikeButton.setImage(senderButton == "dislike" ?  UIImage(named: "disLikeWhite") : UIImage(named: "disLikeBlack"), for: .normal)
        delegate?.didTapOthersButton(in: self)
        
//        if senderButton == "like" {
//            changingStatus(status: .liked)
//            likeButton.isSelected = true
//            disLikeButton.isSelected = false
//            feedbackView.isHidden = true
//            additionalFeedbackView.isHidden = true
//            likeButton.backgroundColor = likeButton.isSelected ? UIColor.palette.primaryColor : UIColor.palette.feedBackButtonColor
//            disLikeButton.backgroundColor = disLikeButton.isSelected ? UIColor.palette.primaryColor : UIColor.palette.feedBackButtonColor
//            likeButton.setImage(likeButton.isSelected ? UIImage(named: "likeWhite") : UIImage(named: "likeBlack"), for: .normal)
//            disLikeButton.setImage(UIImage(named: "disLikeBlack"), for: .normal)
//            delegate?.didTapOthersButton(in: self)
//        }else {
//            changingStatus(status: .feedback)
//            disLikeButton.isSelected = true
//            likeButton.isSelected = false
//            feedbackView.isHidden = false
//            disLikeButton.backgroundColor = disLikeButton.isSelected ? UIColor.palette.primaryColor : UIColor.palette.feedBackButtonColor
//            disLikeButton.setImage(disLikeButton.isSelected ? UIImage(named: "disLikeWhite") : UIImage(named: "disLikeBlack"), for: .normal)
//            likeButton.setImage(UIImage(named: "likeBlack"), for: .normal)
//
//            likeButton.backgroundColor = likeButton.isSelected ? UIColor.palette.primaryColor : UIColor.palette.feedBackButtonColor
//
//            
//            delegate?.didTapOthersButton(in: self)
//        }
    }
    
    func screenSetup() {
        feedBackIndexDict.forEach({ (key,value) in
            if index?.row == key {
                switch value {
                case .closed:
                    feedbackView.isHidden = true
                    additionalFeedbackView.isHidden = true
                    
                case .feedback:
                    feedbackView.isHidden = false
                    additionalFeedbackView.isHidden = true
                    
                case .othersFeedback:
                    feedbackView.isHidden = false
                    additionalFeedbackView.isHidden = false
                case .liked:
                    feedbackView.isHidden = true
                    additionalFeedbackView.isHidden = true
                }
            }
        })
    }
    
    func selectedOtherFeedback() {
        additionalFeedbackView.isHidden = false
        othersFeedbackButton.isSelected = true
        feedbackButtons.forEach { button in
            button.backgroundColor = UIColor.palette.feedBackButtonColor
            button.tintColor = .black
        }
        changingStatus(status: .othersFeedback)
        delegate?.didTapOthersButton(in: self)
    }
    
    func updateButtonBackgroundColor(_ button: UIButton) {
        submitButton.backgroundColor = UIColor.palette.feedBackButtonColor
        changingStatus(status: .feedback)
        let isCurrentlySelected = button.backgroundColor == UIColor.palette.primaryColor
        
        if isCurrentlySelected {
            button.backgroundColor = UIColor.palette.feedBackButtonColor
            button.tintColor = .black
            selectedFeedbackCount -= 1
        } else {
            // Ensure the selection limit is not exceeded
            guard selectedFeedbackCount < 3 else {
                return  }
            
            // Select the button
            button.backgroundColor = UIColor.palette.primaryColor
            button.tintColor = .white
            selectedFeedbackCount += 1
        }
    }


    
    func changingStatus(status: FeedbackType) {
        if let index = index?.row {
            feedBackIndexDict[index] = status
        }
    }
    
}



