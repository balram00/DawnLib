//
//  QuestionTableViewCell.swift
//  Sample POC
//
//  Created by bitcot on 22/12/24.
//

import UIKit

protocol QuestionTableViewCellDelegate: AnyObject {
    func didSelectQuestion(_ cell: QuestionTableViewCell)
}

class QuestionTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: QuestionTableViewCell.self)
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionView: UIView!
    @IBOutlet weak var messageImage: UIImageView!

    var delagate: QuestionTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
     
    }
    
    override func layoutSubviews() {
          super.layoutSubviews()
        questionView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
        questionView.layer.cornerRadius = questionView.frame.size.height / 2
        questionView.layer.masksToBounds = true
        messageImage.layer.cornerRadius = messageImage.frame.size.height / 2
        questionLabel.applyCustomStyle(
            fontFamily: FontConstants.arail,
            fontSize: 16,
            lineHeight: 23,
            alignment: .left
        )
      }

    func configure(with questionText: String) {
           questionLabel.text = questionText
       }

}


class PaddedLabel: UILabel {
    var textInsets = UIEdgeInsets.zero {
        didSet { setNeedsDisplay() }
    }

    override func drawText(in rect: CGRect) {
        let insetRect = rect.inset(by: textInsets)
        super.drawText(in: insetRect)
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + textInsets.left + textInsets.right,
                      height: size.height + textInsets.top + textInsets.bottom)
    }
}
