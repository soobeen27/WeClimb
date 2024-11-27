//
//  CustomSlider.swift
//  WeClimb
//
//  Created by 머성이 on 11/14/24.
//

import UIKit

class CustomSlider: UIControl {
    
    // MARK: - Public Properties
    var minimumValue: Double = 0.0
    var maximumValue: Double = 200.0
    var lowerValue: Double = 120.0 {
        didSet {
            sendActions(for: .valueChanged)
            setNeedsDisplay()
        }
    }
    var upperValue: Double = 200.0 {
        didSet {
            sendActions(for: .valueChanged)
            setNeedsDisplay()
        }
    }
    
    // 값 변경 이벤트 처리용 클로저
    var lowerValueChanged: ((Double) -> Void)?
    var upperValueChanged: ((Double) -> Void)?
    
    // MARK: - Private Properties
    private let thumbSize: CGFloat = 30.0
    private let barHeight: CGFloat = 4.0
    private let minimumRange: Double = 10.0 // 최소 간격
    
    // MARK: - Lifecycle Methods
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // Draw Slider Track (Bar)
        let trackY = rect.midY - barHeight / 2
        let trackRect = CGRect(x: rect.minX + thumbSize / 2, y: trackY, width: rect.width - thumbSize, height: barHeight)
        context.setFillColor(UIColor.lightGray.cgColor)
        context.fill(trackRect)
        
        // Draw Range Track (Selected Range)
        let lowerThumbCenterX = positionForValue(lowerValue)
        let upperThumbCenterX = positionForValue(upperValue)
        let rangeRect = CGRect(x: lowerThumbCenterX, y: trackY, width: upperThumbCenterX - lowerThumbCenterX, height: barHeight)
        context.setFillColor(UIColor.systemBlue.cgColor)
        context.fill(rangeRect)
        
        // Draw Lower Thumb
        let lowerThumbCenter = CGPoint(x: lowerThumbCenterX, y: rect.midY)
        context.setFillColor(UIColor.systemBlue.cgColor)
        context.addArc(center: lowerThumbCenter, radius: thumbSize / 2, startAngle: 0, endAngle: 2 * .pi, clockwise: false)
        context.fillPath()
        
        // Draw Upper Thumb
        let upperThumbCenter = CGPoint(x: upperThumbCenterX, y: rect.midY)
        context.setFillColor(UIColor.systemBlue.cgColor)
        context.addArc(center: upperThumbCenter, radius: thumbSize / 2, startAngle: 0, endAngle: 2 * .pi, clockwise: false)
        context.fillPath()
    }
    
    // MARK: - Tracking Touch Events
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        return updateValue(for: location)
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        return updateValue(for: location)
    }
    
    private func updateValue(for location: CGPoint) -> Bool {
        let percentage = Double((location.x - thumbSize / 2) / (bounds.width - thumbSize))
        let deltaValue = percentage * (maximumValue - minimumValue) + minimumValue
        
        if abs(deltaValue - lowerValue) < abs(deltaValue - upperValue) {
            // Move Lower Thumb
            lowerValue = max(minimumValue, min(deltaValue, upperValue - minimumRange))
            lowerValueChanged?(lowerValue)
        } else {
            // Move Upper Thumb
            upperValue = min(maximumValue, max(deltaValue, lowerValue + minimumRange))
            upperValueChanged?(upperValue)
        }
        
        return true
    }
    
    // MARK: - Helper Methods
    private func positionForValue(_ value: Double) -> CGFloat {
        let percentage = (value - minimumValue) / (maximumValue - minimumValue)
        let position = CGFloat(percentage) * (bounds.width - thumbSize) + thumbSize / 2
        return position
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }
}
