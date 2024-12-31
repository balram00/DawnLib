import UIKit

class NavbarHelper {
    // Method to create the left bar button (with label and container)
    static func createLeftBarButton() -> UIView {
        let firstLabel = createLabel(text: "Dawn", font: UIFont(name: FontConstants.barlowBold, size: 20), textColor: .white)
        let secondLabel = createLabel(text: "BETA", font: UIFont(name: FontConstants.barlowRegular, size: 11), textColor: .purple)

        let secondLabelContainer = createContainer(for: secondLabel)
        
        let stackView = UIStackView(arrangedSubviews: [firstLabel, secondLabelContainer])
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .center
        stackView.distribution = .fill
        
        let containerView = UIView()
        containerView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])

        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width * 0.5),
            containerView.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        return containerView
    }

    // Method to create the right bar button (close icon)
    static func createRightBarButton() -> UIButton {
        let rightButton = UIButton(type: .system)
        rightButton.setImage(UIImage(named: "cross"), for: .normal)
        rightButton.tintColor = .white
        return rightButton
    }

    // Method to create a label with specified text, font, and color
    static func createLabel(text: String, font: UIFont?, textColor: UIColor) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font
        label.textColor = textColor
        label.sizeToFit()
        return label
    }

    // Method to create a container for a given label
    static func createContainer(for label: UILabel) -> UIView {
        let container = UIView()
        container.backgroundColor = .white
        container.contentMode = .center
        container.layer.cornerRadius = 10
        container.addSubview(label)

        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            container.widthAnchor.constraint(equalTo: label.widthAnchor, constant: 12),
            container.heightAnchor.constraint(equalTo: label.heightAnchor, constant: 12)
        ])
        
        return container
    }
}
