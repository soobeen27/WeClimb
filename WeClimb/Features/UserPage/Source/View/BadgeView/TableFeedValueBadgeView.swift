//
//  TableFeedValueBadgeView.swift
//  WeClimb
//
//  Created by 윤대성 on 1/24/25.
//

import UIKit

import SnapKit

class TableFeedValueBadgeView: UIView {
    
    var colorName: String? {
        didSet {
            if let colorName = colorName {
                let lhColor = LHColors.fromHoldEng(colorName)
                let bgColor = lhColor.toBackgroundAccent()
                self.backgroundColor = bgColor
                self.colorImage.image = lhColor.toImage(targetSize: CGSize(width: 12, height: 12))
                self.badgeCountLabel.textColor = lhColor.toFontColor()
            }
        }
    }
    
    var text: String? {
        didSet {
            badgeCountLabel.text = text
        }
    }
    
    private let colorImage: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.image = .colorGray
        return img
    }()
    
    private let badgeCountLabel: UILabel = {
        let label = UILabel()
        label.font = BadgeConst.Font.badgeFont
        return label
    }()
    
    private let badgeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.layer.cornerRadius = 8
        stackView.spacing = 4
        return stackView
    }()
    
    init() {
        super.init(frame: .zero)
        setLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        [
            badgeStackView
        ].forEach { self.addSubview($0) }
        
        [
            colorImage,
            badgeCountLabel,
        ].forEach { badgeStackView.addArrangedSubview($0) }
        
        badgeStackView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().inset(12)
            $0.height.equalTo(26)
        }
        
        colorImage.snp.remakeConstraints {
            $0.size.equalTo(BadgeConst.Size.badgeImage)
        }
    }
}
