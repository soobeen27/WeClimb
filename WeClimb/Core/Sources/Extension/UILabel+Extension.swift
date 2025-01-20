//
//  UILabel+Extension.swift
//  WeClimb
//
//  Created by Soobeen Jang on 1/14/25.
//

import UIKit

extension UILabel {
    func calculateNumberOfLines() -> Int {
        guard let text = self.text, let font = self.font else { return 0 }
        
        // UILabel의 너비를 기반으로 텍스트 크기 계산
        let maxSize = CGSize(width: self.frame.width, height: CGFloat.greatestFiniteMagnitude)
        let textAttributes: [NSAttributedString.Key: Any] = [.font: font]
        
        let boundingRect = text.boundingRect(with: maxSize,
                                             options: [.usesLineFragmentOrigin, .usesFontLeading],
                                             attributes: textAttributes,
                                             context: nil)
        
        // 텍스트의 전체 높이와 폰트 라인 높이를 나눠 줄 수 계산
        let textHeight = ceil(boundingRect.height)
        let lineHeight = font.lineHeight
        
        let numberOfLines = Int(textHeight / lineHeight)
        return numberOfLines
    }
}
