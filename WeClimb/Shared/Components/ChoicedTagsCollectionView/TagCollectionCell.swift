//
//  TagCollectionCell.swift
//  WeClimb
//
//  Created by Soobeen Jang on 12/27/24.
//

import UIKit

import SnapKit
import RxSwift

enum ScreenMode {
    case dark
    case light
}

class TagCollectionCell: UICollectionViewCell {
    
    private var screenMode: ScreenMode?
    
    private let tagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .label
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(screenMode: ScreenMode) {
        self.screenMode = screenMode
    }
    
    private func setLayout() {
        [
            tagImageView,
            titleLabel,
            cancelButton
        ]
            .forEach {
            self.contentView.addSubview($0)
        }
        
        tagImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(8)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(80)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(tagImageView.snp.trailing).offset(8)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(80)
        }
        
        cancelButton.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(8)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(80)
        }
    }
    
}
