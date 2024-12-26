//
//  ChatHeaderCell.swift
//  Sample POC
//
//  Created by bitcot on 23/12/24.
//

import UIKit

class ChatHeaderCell: UITableViewCell {
    
    static let identifier = String(describing: ChatHeaderCell.self)
    @IBOutlet weak var headingLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        headingLabel.font = UIFont(name: "Roboto-regular", size: 40)
        headingLabel?.text = "Hi there 👋\nHow can I help?"
        headingLabel?.numberOfLines = 0
        headingLabel.applyCustomStyle(
            fontFamily: FontConstants.robotoRegular,
            fontSize: 40,
            lineHeight: 41.6,
            alignment: .center
        )
    }
    
}


