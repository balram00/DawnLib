//
//  FeedbackTableViewCell.swift
//  Sample POC
//
//  Created by bitcot on 23/12/24.
//

import UIKit

class FeedbackTableViewCell: UITableViewCell {
    
    static let identifier: String = "FeedbackTableViewCell"
    
    @IBOutlet var feedbackButtons: [UIButton]!
    @IBOutlet var submitButton: UIButton!
    @IBOutlet var additionalFeedbackView: UIView!
    @IBOutlet var feedbackView: UIView!
    @IBOutlet var additionalFeedbackTextView: UITextView!
    @IBOutlet var tellUsMoreLabel: UILabel!
    @IBOutlet var provideAdditionalFeedbackLabel: UILabel!



    var isAddtionalFeedbackVisible = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        submitButton.layer.cornerRadius = submitButton.frame.height / 2
        feedbackButtons.forEach({ button in
            button.layer.cornerRadius = button.frame.height / 2
            button.applyCustomStyle(
                fontFamily: "Arail",
                fontSize: 16,
                lineHeight: 23,
                textColorHex: "#424243",
                alignment: .left
            )
        })
        [additionalFeedbackTextView,feedbackView].forEach({ view in
            view.layer.cornerRadius = 10
            view.layer.borderWidth = 1
            view.layer.borderColor = UIColor.lightGray.cgColor
        })
        [tellUsMoreLabel,provideAdditionalFeedbackLabel].forEach({ label in
            label.applyCustomStyle(
                fontFamily: FontConstants.robotoRegular,
                fontSize: 16,
                lineHeight: 23,
                alignment: .left
            )
        })
        
        
    }

    @IBAction func didntProvideAnswerTapped(_ sender: UIButton) {
        // Toggle selection state
        sender.isSelected.toggle()
        
        // Update background color based on selected state
        updateButtonBackgroundColor(sender, isSelected: sender.isSelected)
    }

    @IBAction func notRelevantTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        updateButtonBackgroundColor(sender, isSelected: sender.isSelected)
    }

    @IBAction func notFactuallyCorrectTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        updateButtonBackgroundColor(sender, isSelected: sender.isSelected)
    }

    @IBAction func didntLikeAnswerTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        updateButtonBackgroundColor(sender, isSelected: sender.isSelected)
    }

    @IBAction func didntLikeStyleTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        updateButtonBackgroundColor(sender, isSelected: sender.isSelected)
    }
    
    func updateButtonBackgroundColor(_ button: UIButton, isSelected: Bool) {
        if isSelected {
            button.backgroundColor = UIColor.palette.primaryColor
            button.tintColor = .white
        } else {
            button.backgroundColor = UIColor.palette.feedBackButtonColor
            button.tintColor = .black
        }
    }
       
       @IBAction func othersTapped(_ sender: UIButton) {
           if !isAddtionalFeedbackVisible {
               additionalFeedbackView.isHidden = false
               isAddtionalFeedbackVisible = !isAddtionalFeedbackVisible
           }else{
               additionalFeedbackView.isHidden = true
               isAddtionalFeedbackVisible = !isAddtionalFeedbackVisible
           }
       }
    
}
