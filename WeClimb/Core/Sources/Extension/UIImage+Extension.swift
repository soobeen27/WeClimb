//
//  UIImage+Extension.swift
//  WeClimb
//
//  Created by 머성이 on 12/3/24.
//

import UIKit

extension UIImage {
    /// 지정된 크기로 리사이즈한 새로운 UIImage 객체 반환
    /// - Parameter targetSize: 리사이즈할 목표 크기를 나타내는 CGSize.
    /// - Returns: 리사이즈된 UIImage 객체 반환. (실패시 nil 반환)
    func resize(targetSize: CGSize) -> UIImage? {
        let newRect = CGRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height).integral
        UIGraphicsBeginImageContextWithOptions(newRect.size, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.interpolationQuality = .high
        draw(in: newRect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
