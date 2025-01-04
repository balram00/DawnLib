//
//  AnswerTableViewCell.swift
//  Sample POC
//
//  Created by bitcot on 23/12/24.
//

import UIKit

class AnswerTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: AnswerTableViewCell.self)
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var anwerLabel: UILabel!
    @IBOutlet weak var anwerView: UIView!

    var jsonResponse: Response?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        dataSetUp()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        anwerView.layer.cornerRadius = 15
        anwerLabel.applyCustomStyle(
            fontFamily: FontConstants.barlowRegular,
            fontSize: FontSize.regular.rawValue,
            lineHeight: 23,
            alignment: .left
        )
        rotateImageView(angle: .pi / -4)
    }
    
    func rotateImageView(angle: CGFloat) {
        arrowImage.transform = CGAffineTransform(rotationAngle: angle)
        
    }
    
    func dataSetUp() {
        anwerLabel.text = jsonResponse?.question
    }

    
}
