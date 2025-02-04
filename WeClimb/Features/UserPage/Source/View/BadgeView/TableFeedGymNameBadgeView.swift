//
//  TableFeedGymNameBadgeView.swift
//  WeClimb
//
//  Created by 윤대성 on 1/24/25.
//

import UIKit

import SnapKit

class TableFeedGymNameBadgeView: UIView {
    
    var gymNameText: String? {
        didSet {
            gymName.text = gymNameText
            setLayout()
        }
    }
    
    private let gymName: UILabel = {
        let label = UILabel()
        label.font = BadgeConst.Font.gymNameLabelFont
        label.textColor = BadgeConst.Color.gymNameFontColor
        return label
    }()
    
    private let markerImageView: UIImageView = {
        let imageView = UIImageView(image: .locationIconFill)
        imageView.backgroundColor = .clear
        imageView.tintColor = BadgeConst.Color.gymNameMarkerColor
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
        return imageView
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
        self.backgroundColor = BadgeConst.Color.gymNameBackgroundColor
        
        [
            gymName,
            markerImageView
        ].forEach { self.addSubview($0) }
        
        markerImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(BadgeConst.Spacing.gymNameMargin)
            $0.width.height.equalTo(BadgeConst.Size.gymNameMarkerHeight)
        }
        
        gymName.snp.makeConstraints {
            $0.leading.equalTo(markerImageView.snp.trailing).offset(BadgeConst.Spacing.gymNameValueMargin)
            $0.trailing.equalToSuperview().offset(-BadgeConst.Spacing.gymNameMargin)
        }
    }
}
