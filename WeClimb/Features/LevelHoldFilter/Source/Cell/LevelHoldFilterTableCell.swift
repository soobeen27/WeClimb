//
//  LevelHoldFilterTableCell.swift
//  WeClimb
//
//  Created by 강유정 on 1/3/25.
//

import UIKit

import SnapKit

class LevelHoldFilterTableCell: UITableViewCell {
    var coordinator: UploadCoordinator?
    
    private let iconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 127/255, green: 129/255, blue: 138/255, alpha: 1)
        label.font = UIFont.customFont(style: .label2Regular)
        return label
    }()
    
    private let leftImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.backgroundColor = UIColor(red: 127/255, green: 129/255, blue: 138/255, alpha: 0.16)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.white
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        [iconImage, titleLabel, leftImage, separatorLine].forEach { contentView.addSubview($0) }
        
        iconImage.snp.makeConstraints {
            $0.leading.equalTo(contentView).inset(16)
            $0.centerY.equalTo(contentView)
            $0.width.height.equalTo(16)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(iconImage.snp.trailing).offset(8)
            $0.centerY.equalTo(contentView)
            $0.trailing.lessThanOrEqualTo(leftImage.snp.leading).offset(-8)
        }
        
        leftImage.snp.makeConstraints {
            $0.trailing.equalTo(contentView).inset(16)
            $0.centerY.equalToSuperview()
        }
        
        separatorLine.snp.makeConstraints {
            $0.trailing.equalTo(contentView).inset(16)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(43)
            $0.height.equalTo(1)
        }
    }
    
    func configure(with text: String, imageName: String, isChecked: Bool, isFirstCell: Bool, isLastCell: Bool) {
        titleLabel.text = text
        iconImage.image = UIImage(named: imageName)
        
        if isChecked {
            titleLabel.font = UIFont.customFont(style: .label2SemiBold)
            titleLabel.textColor = .black
            iconImage.image = UIImage(named: imageName + "Check")
        } else {
            iconImage.image = UIImage(named: imageName)
            titleLabel.textColor = UIColor(red: 127/255, green: 129/255, blue: 138/255, alpha: 1)
            titleLabel.font = UIFont.customFont(style: .label2Regular)
        }
        
        if isFirstCell {
            separatorLine.isHidden = true
            leftImage.image = UIImage(named: "harderIcon")
        } else if isLastCell {
            separatorLine.isHidden = true
            leftImage.image = UIImage(named: "easierIcon")
        } else {
            separatorLine.isHidden = false
            leftImage.image = nil
        }
    }
}
