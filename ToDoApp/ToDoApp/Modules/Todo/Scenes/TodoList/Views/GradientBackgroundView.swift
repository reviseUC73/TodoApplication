//
//  GradientBackgroundView.swift
//  ToDoApp
//
//  Created by ReviseUC73 on 19/4/2568 BE.
//

import UIKit

class GradientBackgroundView: UIView {

    // MARK: - Properties
    private let gradientLayer = CAGradientLayer()

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
        addPastelBubbles()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradient()
        addPastelBubbles()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    // MARK: - Gradient Setup
    private func setupGradient() {
        // พาสเทลสีอ่อนแบบ bubble background
        let topColor = UIColor(red: 0.93, green: 0.96, blue: 1.0, alpha: 1.0).cgColor   // soft blue-white
        let bottomColor = UIColor(red: 1.0, green: 0.95, blue: 0.98, alpha: 1.0).cgColor // soft pink-white

        gradientLayer.colors = [topColor, bottomColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.3, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.7, y: 1.0)
        gradientLayer.frame = bounds

        layer.insertSublayer(gradientLayer, at: 0)
    }

    // MARK: - Bubble Setup
    private func addPastelBubbles() {
        addBubble(color: UIColor.systemPink.withAlphaComponent(0.3),
                  center: CGPoint(x: 80, y: 150), radius: 8)

        addBubble(color: UIColor.systemYellow.withAlphaComponent(0.3),
                  center: CGPoint(x: 160, y: 100), radius: 10)

        addBubble(color: UIColor.systemBlue.withAlphaComponent(0.3),
                  center: CGPoint(x: 120, y: 200), radius: 6)

        addBubble(color: UIColor.systemGreen.withAlphaComponent(0.3),
                  center: CGPoint(x: 220, y: 130), radius: 5)

        addBubble(color: UIColor.systemPurple.withAlphaComponent(0.3),
                  center: CGPoint(x: 180, y: 250), radius: 7)
    }

    private func addBubble(color: UIColor, center: CGPoint, radius: CGFloat) {
        let bubble = UIView(frame: CGRect(x: 0, y: 0, width: radius * 2, height: radius * 2))
        bubble.center = center
        bubble.backgroundColor = color
        bubble.layer.cornerRadius = radius
        bubble.isUserInteractionEnabled = false
        addSubview(bubble)
    }
}
