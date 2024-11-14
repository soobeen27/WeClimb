//
//  RangeSlider.swift
//  WeClimb
//
//  Created by 머성이 on 11/14/24.
//

import UIKit

class RangeSlider: UIControl {
    
    var minimumValue: CGFloat = 120
    var maximumValue: CGFloat = 200
    var stepValue: CGFloat = 10
    
    var lowerValue: CGFloat = 120 {
        didSet { updateLayerFrames() }
    }
    
    var upperValue: CGFloat = 180 {
        didSet { updateLayerFrames() }
    }
    
    private let trackLayer = CALayer()
    private let lowerThumbLayer = CALayer()
    private let upperThumbLayer = CALayer()
    
    private var previousLocation = CGPoint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
    }
    
    private func setupLayers() {
        trackLayer.backgroundColor = UIColor.systemGray4.cgColor
        lowerThumbLayer.backgroundColor = UIColor.systemBlue.cgColor
        upperThumbLayer.backgroundColor = UIColor.systemBlue.cgColor
        
        [
            trackLayer,
            lowerThumbLayer,
            upperThumbLayer
        ].forEach { layer.addSublayer($0) }
        
        lowerThumbLayer.cornerRadius = 15
        upperThumbLayer.cornerRadius = 15
        
        // 슬라이더 초기화
        updateLayerFrames()
    }
    
    private func updateLayerFrames() {
        // 트랙 설정
        let trackHeight: CGFloat = 4
        trackLayer.frame = CGRect(x: 0, y: bounds.height / 2 - trackHeight / 2, width: bounds.width, height: trackHeight)
        
        // lowerThumb와 upperThumb의 위치 계산
        let lowerThumbCenter = positionForValue(lowerValue)
        lowerThumbLayer.frame = CGRect(x: lowerThumbCenter - 15, y: bounds.height / 2 - 15, width: 30, height: 30)
        
        let upperThumbCenter = positionForValue(upperValue)
        upperThumbLayer.frame = CGRect(x: upperThumbCenter - 15, y: bounds.height / 2 - 15, width: 30, height: 30)
    }
    
    private func positionForValue(_ value: CGFloat) -> CGFloat {
        return bounds.width * (value - minimumValue) / (maximumValue - minimumValue)
    }
    
    private func boundValue(_ value: CGFloat, toLowerValue lowerValue: CGFloat, upperValue: CGFloat) -> CGFloat {
        return min(max(value, lowerValue), upperValue)
    }
    
    private func roundedStepValue(_ value: CGFloat) -> CGFloat {
        return round(value / stepValue) * stepValue
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        previousLocation = touch.location(in: self)
        
        if lowerThumbLayer.frame.contains(previousLocation) {
            return true
        } else if upperThumbLayer.frame.contains(previousLocation) {
            return true
        }
        
        return false
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        let deltaLocation = location.x - previousLocation.x
        let deltaValue = (maximumValue - minimumValue) * deltaLocation / bounds.width
        
        previousLocation = location
        
        if lowerThumbLayer.frame.contains(location) {
            lowerValue = boundValue(roundedStepValue(lowerValue + deltaValue), toLowerValue: minimumValue, upperValue: upperValue)
        } else if upperThumbLayer.frame.contains(location) {
            upperValue = boundValue(roundedStepValue(upperValue + deltaValue), toLowerValue: lowerValue, upperValue: maximumValue)
        }
        
        sendActions(for: .valueChanged)
        return true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateLayerFrames() // 뷰의 레이아웃이 변경될 때마다 프레임을 업데이트
    }
}
