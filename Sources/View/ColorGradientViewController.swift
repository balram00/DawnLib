import UIKit

public class ColorNavigationViewController: UINavigationController {

    override public func viewDidLoad() {
        super.viewDidLoad()
        setValue(CustomNavigationBar(frame: .zero), forKey: "navigationBar")
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        changeGradientImage()
    }
    
    // New gradient colors using #0b95d3, #653894, and #ae285f
    let newGradient = [
        UIColor(hex: "#0b95d3"), // Light Blue
        UIColor(hex: "#653894"), // Purple
        UIColor(hex: "#ae285f")  // Dark Pink
    ]
    
    // Gradient locations (optional, can be adjusted)
    let gradientLocations: [NSNumber] = [0.0, 0.5, 1.0]

    lazy var colorView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        navigationBar.addSubview(view)
        navigationBar.sendSubviewToBack(view)
        return view
    }()
    
    public func changeGradientImage() {
        let reducedHeight: CGFloat = 60 // Use the same value as your new navigation bar height

        // Adjust the colorView's frame based on the new height
        colorView.frame = CGRect(
            x: 0,
            y: -60,  // Adjust y position accordingly
            width: navigationBar.frame.width,
            height: reducedHeight
        )
        
        // Apply gradient image to the colorView
        colorView.backgroundColor = UIColor(
            patternImage: gradientImage(
                withColours: newGradient,
                location: gradientLocations,
                view: navigationBar
            ).resizableImage(
                withCapInsets: UIEdgeInsets(
                    top: 0,
                    left: navigationBar.frame.size.width / 2,
                    bottom: 10,
                    right: navigationBar.frame.size.width / 2
                ),
                resizingMode: .stretch
            )
        )

        // Apply gradient to the navigation bar
        navigationBar.setBackgroundImage(
            gradientImage(
                withColours: newGradient,
                location: gradientLocations,
                view: navigationBar
            ),
            for: .default
        )

        // Apply gradient to large title background (if needed)
        navigationBar.layer.backgroundColor = UIColor(
            patternImage: gradientImage(
                withColours: newGradient,
                location: gradientLocations,
                view: navigationBar
            ).resizableImage(
                withCapInsets: UIEdgeInsets(
                    top: 0,
                    left: navigationBar.frame.size.width / 2,
                    bottom: 10,
                    right: navigationBar.frame.size.width / 2
                ),
                resizingMode: .stretch
            )
        ).cgColor
    }

    public func configNavigationBar() {
        navigationBar.barStyle = .default
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = false
        navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        navigationBar.tintColor = UIColor.white
        navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    public func gradientImage(withColours colours: [UIColor], location: [NSNumber], view: UIView) -> UIImage {
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.locations = location
        gradient.cornerRadius = view.layer.cornerRadius
        return UIImage.image(from: gradient) ?? UIImage()
    }

    override public var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

public extension UIColor {
    convenience init(rgb: Int) {
        self.init(
            red: CGFloat((rgb >> 16) & 0xFF),
            green: CGFloat((rgb >> 8) & 0xFF),
            blue: CGFloat(rgb & 0xFF), alpha: 0.8
        )
    }
}

public extension UIImage {
    class func image(from layer: CALayer) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(layer.bounds.size,
                                               layer.isOpaque, UIScreen.main.scale)
        
        defer { UIGraphicsEndImageContext() }
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

public class CustomNavigationBar: UINavigationBar {
    override public func sizeThatFits(_ size: CGSize) -> CGSize {
        var newSize = super.sizeThatFits(size)
        newSize.height = 60 // Set your desired height, e.g., 60
        return newSize
    }
}
