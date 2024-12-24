//
//  AnswerTableViewCell.swift
//  Sample POC
//
//  Created by bitcot on 23/12/24.
//

import UIKit

class AnswerTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: AnswerTableViewCell.self)
    
    @IBOutlet weak var anwerLabel: UILabel!
    @IBOutlet weak var anwerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        anwerView.layer.cornerRadius = 15
        anwerLabel.applyCustomStyle(
            fontFamily: FontConstants.barlowRegular,
            fontSize: 16,
            lineHeight: 23,
            alignment: .left
        )

    }

    
}
