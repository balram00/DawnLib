//
//  ChatHeaderView.swift
//  DawnLib-Test
//
//  Created by bitcot on 30/12/24.
//

import UIKit


class ChatHeaderView: UIView {
    
    static let identifier = String(describing: ChatHeaderCell.self)
    @IBOutlet weak var headingLabel: UILabel!
    
    override func awakeFromNib() {
           super.awakeFromNib()
        headingLabel?.text = "Hi there 👋   \nHow can I help?"
        headingLabel?.numberOfLines = 0
        headingLabel.applyCustomStyle(
            fontFamily: FontConstants.robotoRegular,
            fontSize: FontSize.header.rawValue,
            lineHeight: 41.6,
            alignment: .center
        )
     }
    
    class func load(frame: CGRect) -> ChatHeaderView {
        let view = Bundle.main.loadNibNamed("ChatHeaderView", owner: self, options: nil)?.first as! ChatHeaderView
        view.frame = frame
        return view
    }
}
