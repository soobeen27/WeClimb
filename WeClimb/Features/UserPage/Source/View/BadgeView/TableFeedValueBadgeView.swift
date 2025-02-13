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
                let lhColor = LHColors.fromEng(colorName)
                self.backgroundColor = lhColor.toBackgroundAccent()
                self.colorImage.image = lhColor.toImage()
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
        label.textColor = .black
        return label
    }()
    
    private let badgeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
    }()
    
    init() {
        super.init(frame: .zero)
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
//            $0.leading.trailing.equalToSuperview()
            $0.edges.equalToSuperview().inset(12)
        }
        
        colorImage.snp.makeConstraints {
            $0.height.width.equalTo(12)
        }
    }
}
