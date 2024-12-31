//
//  UIView+Extensions.swift
//  DawnLib-Test
//
//  Created by bitcot on 29/12/24.
//


import UIKit

extension UIView {
    func setCornerRadiusForLeftAndRight(radius: CGFloat) {
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: [.topLeft, .bottomLeft, .topRight, .bottomRight],
            cornerRadii: CGSize(width: radius, height: radius)
        )

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        layer.mask = shapeLayer
    }
}

// Custom class for Gradient Border
class GradientBorderView: UIView {

    private var gradientLayer: CAGradientLayer?
    private var shapeLayer: CAShapeLayer?

    // Custom properties
    var colors: [UIColor] = [UIColor.red, UIColor.blue] {
        didSet {
            updateGradient()
        }
    }
    
    var borderWidth: CGFloat = 5.0 {
        didSet {
            updateShapeLayer()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        // Create and add the gradient layer
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        self.layer.addSublayer(gradientLayer)
        self.gradientLayer = gradientLayer

        // Create and add the shape layer for masking
        let shapeLayer = CAShapeLayer()
        self.layer.addSublayer(shapeLayer)
        self.shapeLayer = shapeLayer

        updateGradient()
        updateShapeLayer()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = bounds
        updateShapeLayer()
    }

    private func updateGradient() {
        gradientLayer?.colors = colors.map { $0.cgColor }
    }

    private func updateShapeLayer() {
        let path = UIBezierPath(rect: bounds)
        let innerPath = UIBezierPath(rect: bounds.insetBy(dx: borderWidth, dy: borderWidth))
        path.append(innerPath)
        path.usesEvenOddFillRule = true

        shapeLayer?.path = path.cgPath
        shapeLayer?.fillRule = .evenOdd
        shapeLayer?.fillColor = UIColor.black.cgColor

        gradientLayer?.mask = shapeLayer
    }
}
