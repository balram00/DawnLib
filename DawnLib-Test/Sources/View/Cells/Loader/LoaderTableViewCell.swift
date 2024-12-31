//
//  LoaderTableViewCell.swift
//  Sample POC
//
//  Created by bitcot on 23/12/24.
//

import UIKit

class LoaderTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: LoaderTableViewCell.self)

    @IBOutlet weak var dot1: UIView!
    @IBOutlet weak var dot2: UIView!
    @IBOutlet weak var dot3: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        startWaveAnimation()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        dot1.layer.cornerRadius = dot1.layer.bounds.width / 2
        dot2.layer.cornerRadius = dot2.layer.bounds.width / 2
        dot3.layer.cornerRadius = dot3.layer.bounds.width / 2
    }
    
    func startWaveAnimation() {
            animateDot(dot: dot1, delay: 0.0)
            animateDot(dot: dot2, delay: 0.2)
            animateDot(dot: dot3, delay: 0.4)
        }
    
    func animateDot(dot: UIView, delay: TimeInterval) {
            UIView.animateKeyframes(
                withDuration: 1.2,
                delay: delay,
                options: [.repeat, .allowUserInteraction],
                animations: {
                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5) {
                        dot.transform = CGAffineTransform(translationX: 0, y: -8) // Move up
                    }
                    UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                        dot.transform = .identity // Move back down
                    }
                },
                completion: nil
            )
        }
    
}
