//
//  Untitled.swift
//  WeClimb
//
//  Created by Soobeen Jang on 1/31/25.
//

import UIKit

class GradientView: UIView {
    
    private let gradientLayer = CAGradientLayer()
    
    init() {
        super.init(frame: .zero)
        setupGradientLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupGradientLayer() {
        gradientLayer.colors = [
            UIColor(hex: "1A1A1A", alpha: 0.8).cgColor,
            UIColor.clear.cgColor,
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
        layer.insertSublayer(gradientLayer, at: 0)
        layer.masksToBounds = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.gradientLayer.frame = self.bounds
    }
}
