import UIKit

class PopupView: UIView {
    
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var horizontalPosition: NSLayoutConstraint!
    
    // Create a custom function to load the view
    class func load(frame: CGRect) -> PopupView {
        let view = Bundle.main.loadNibNamed("PopUpView", owner: self, options: nil)?.first as! PopupView
        view.frame = frame
        view.addTapGestureToRemove()
        return view
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Configure the label to handle multiline text
        contentLabel.numberOfLines = 0
        contentLabel.lineBreakMode = .byWordWrapping
        contentLabel.textAlignment = .left
        contentLabel.textColor =  UIColor { tc in
            switch tc.userInterfaceStyle {
            case .dark:
                return UIColor.palette.textColor
            default:
                return UIColor.palette.textColor
            }
        }
    }
    
    func addTapGestureToRemove() {
        // Apply gradient border to the contentView
        let gradientBorderView = GradientBorderView(frame: contentView.bounds)
        gradientBorderView.colors = [UIColor.systemPink, UIColor.systemBlue, UIColor.systemTeal]
        gradientBorderView.borderWidth = 1.0
        contentView.addSubview(gradientBorderView)
        gradientBorderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gradientBorderView.topAnchor.constraint(equalTo: contentView.topAnchor),
            gradientBorderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            gradientBorderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            gradientBorderView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        self.addGestureRecognizer(tapGesture) // Add gesture recognizer to the entire PopupView, not just contentView
    }
    
    @objc private func viewTapped(_ sender: UITapGestureRecognizer) {
        self.removeFromSuperview()
    }
}

