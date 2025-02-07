//
//  CommentTitleView.swift
//  WeClimb
//
//  Created by Soobeen Jang on 2/6/25.
//

import UIKit

import SnapKit

class CommentTitleView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(style: .heading2SemiBold)
        label.text = CommentConsts.titleText
        label.textColor = CommentConsts.titleColor
        return label
    }()
    
    private let strokeView: UIView = {
        let v = UIView()
        v.backgroundColor = CommentConsts.strokeColor
        return v
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func setLayout() {
        [titleLabel, strokeView]
            .forEach { addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        strokeView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
}
