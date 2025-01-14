//
//  QuestionTableViewCell.swift
//  Sample POC
//
//  Created by bitcot on 22/12/24.
//

import UIKit


class QuestionTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: QuestionTableViewCell.self)
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionView: UIView!
    @IBOutlet weak var messageImage: UIImageView!


    override func awakeFromNib() {
        super.awakeFromNib()
     
    }
    
    override func layoutSubviews() {
          super.layoutSubviews()
        questionView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
        questionView.setCornerRadiusForLeftAndRight(radius: questionView.frame.size.height / 1.5)
        questionView.layer.masksToBounds = true
        messageImage.layer.cornerRadius = messageImage.frame.size.height / 2
        questionLabel.applyCustomStyle(
            fontFamily: FontConstants.arail,
            fontSize: FontSize.regular.rawValue,
            lineHeight: 23,
            alignment: .left
        )
      }

    func configure(with questionText: String) {
           questionLabel.text = questionText
       }

}


