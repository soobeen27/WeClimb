//
//  LevelHoldFilterTableCell.swift
//  WeClimb
//
//  Created by 강유정 on 1/3/25.
//

import UIKit

import SnapKit

class LevelHoldFilterTableCell: UITableViewCell {
    
    private let iconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = LevelHoldFilterCellConst.cellTitleFont
        return label
    }()
    
    private let leftImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let rightSeparatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = LevelHoldFilterCellConst.Color.rightSeparatorLineColor
        return view
    }()
    
    func updateCellStyle(for theme: LevelHoldFilterVC.FilterViewTheme, isChecked: Bool) {
        switch theme {
        case .light:
            contentView.backgroundColor = LevelHoldFilterCellConst.Color.lightCellBackgroundColor
            titleLabel.textColor = isChecked ? LevelHoldFilterCellConst.Color.lightIsCheckedCellTitleColor : LevelHoldFilterCellConst.Color.lightNormalCellTitleColor
        case .dark:
            contentView.backgroundColor = LevelHoldFilterCellConst.Color.darkCellBackgroundColor
            titleLabel.textColor = isChecked ? LevelHoldFilterCellConst.Color.darkIsCheckedCellTitleColor : LevelHoldFilterCellConst.Color.darkNormalCellTitleColor
        }

    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.white
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        [iconImage, titleLabel, leftImage, rightSeparatorLine].forEach { contentView.addSubview($0) }
        
        iconImage.snp.makeConstraints {
            $0.leading.equalTo(contentView).inset(LevelHoldFilterCellConst.padding.defaultPadding)
            $0.centerY.equalTo(contentView)
            $0.width.height.equalTo(LevelHoldFilterCellConst.padding.defaultPadding)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(iconImage.snp.trailing).offset(LevelHoldFilterCellConst.padding.titleLeading)
            $0.centerY.equalTo(contentView)
        }
        
        leftImage.snp.makeConstraints {
            $0.trailing.equalTo(contentView).inset(LevelHoldFilterCellConst.padding.defaultPadding)
            $0.centerY.equalToSuperview()
        }
        
        rightSeparatorLine.snp.makeConstraints {
            $0.trailing.equalTo(contentView).inset(LevelHoldFilterCellConst.padding.defaultPadding)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(LevelHoldFilterCellConst.Size.rightSeparatorLineWidth)
            $0.height.equalTo(LevelHoldFilterCellConst.Size.rightSeparatorLineHeight)
        }
    }
    
    func configure(with config: LevelHoldFilterCellConfig, theme: LevelHoldFilterVC.FilterViewTheme) {
        titleLabel.text = config.text
        iconImage.image = UIImage(named: config.imageName)
        
        if config.isChecked {
            titleLabel.font = UIFont.customFont(style: .label2SemiBold)
            iconImage.image = UIImage(named: config.imageName + LevelHoldFilterCellConst.Text.checkSuffix)
        } else {
            iconImage.image = UIImage(named: config.imageName)
            titleLabel.font = UIFont.customFont(style: .label2Regular)
        }
        
        if config.filterType == .level {
            if config.isFirstCell {
                rightSeparatorLine.isHidden = true
                leftImage.image = LevelHoldFilterCellConst.Icon.firstCellHarderIcon
                leftImage.isHidden = false
            } else if config.isLastCell {
                rightSeparatorLine.isHidden = true
                leftImage.image = LevelHoldFilterCellConst.Icon.lastCellEasierIcon
                leftImage.isHidden = false
            } else {
                rightSeparatorLine.isHidden = false
                leftImage.image = nil
                leftImage.isHidden = true
            }
        } else {
            leftImage.isHidden = true
            rightSeparatorLine.isHidden = false
            leftImage.image = nil
        }
        
        updateCellStyle(for: theme, isChecked: config.isChecked)
    }
}
