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
        let imageView = UIImageView()
        imageView.image = BadgeConst.Image.markerImage
        return imageView
    }()
    
    init(gymNameText: String? = nil) {
        super.init(frame: .zero)
        self.gymNameText = gymNameText
        setLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        self.backgroundColor = BadgeConst.Color.gymNameBackgroundColor
        self.layer.cornerRadius = 8
        
        [
            gymName,
            markerImageView
        ].forEach { self.addSubview($0) }
        
        markerImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.width.height.equalTo(BadgeConst.Size.gymNameMarkerHeight)
            $0.centerY.equalToSuperview()
        }
        
        gymName.snp.makeConstraints {
            $0.leading.equalTo(markerImageView.snp.trailing).offset(5)
            $0.trailing.equalToSuperview().offset(-BadgeConst.Spacing.gymNameMargin)
            $0.centerY.equalToSuperview()
        }
    }
}
