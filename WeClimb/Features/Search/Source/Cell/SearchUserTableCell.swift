//
//  SearchUserTableCell.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//

import UIKit

import Kingfisher

class SearchUserTableCell: UITableViewCell {
    
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = SearchConst.Common.Image.defaultUserImage
        imageView.layer.cornerRadius = SearchConst.Cell.Shape.cellImageCornerRadius
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(style: .label2SemiBold)
        return label
    }()
    
    private let userInfoLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(style: .caption2Regular)
        return label
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle(SearchConst.Cell.Text.cellCancelBtnTitle, for: .normal)
        button.setTitleColor(SearchConst.Cell.Color.cellCancelBtnTitleColor, for: .normal)
        button.titleLabel?.font = SearchConst.Cell.Font.cellCancelBtnFont
        button.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        return button
    }()
    
    var onDelete: ((SearchResultItem) -> Void)?
    
    var shouldShowDeleteButton: Bool = true {
        didSet {
            deleteButton.isHidden = !shouldShowDeleteButton
        }
    }
    
    private var currentItem: SearchResultItem?
    private var currentSearchStyle: SearchStyle?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        [userImageView, userNameLabel, userInfoLabel, deleteButton]
            .forEach { contentView.addSubview($0) }
      
        userImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(SearchConst.Cell.Spacing.userImageleftSpacing)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(SearchConst.Cell.Size.userImageSize)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.leading.equalTo(userImageView.snp.trailing).offset(SearchConst.Cell.Spacing.userNameleftSpacing)
            $0.top.equalTo(userImageView.snp.top)
        }
        
        userInfoLabel.snp.makeConstraints {
            $0.top.equalTo(userNameLabel.snp.bottom).offset(SearchConst.Cell.Spacing.userInfoTopSpacing)
            $0.leading.equalTo(userNameLabel.snp.leading)
        }
        
        deleteButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(SearchConst.Cell.Spacing.cancelBtnRightSpacing)
            $0.centerY.equalToSuperview()
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle {
            if let currentItem = currentItem, let currentSearchStyle = currentSearchStyle {
                configure(with: currentItem, searchStyle: currentSearchStyle)
            }
        }
    }

    func configure(with item: SearchResultItem, searchStyle: SearchStyle) {
        
        currentItem = item
        currentSearchStyle = searchStyle

        if item.imageName.isEmpty || URL(string: item.imageName) == nil {
            userImageView.image = UIImage.defaultAvatarProfile
        } else {
            let imageURL = URL(string: item.imageName)
            userImageView.kf.setImage(with: imageURL)
        }

        userNameLabel.text = item.name

        if let height = item.height, let armReach = item.armReach {
            userInfoLabel.text = String(format: SearchConst.Cell.Text.UserInfo.heightAndArmReachLabel, "\(height)", "\(armReach)")
        } else if let height = item.height {
            userInfoLabel.text = String(format: SearchConst.Cell.Text.UserInfo.heightLabel, "\(height)")
        } else if let armReach = item.armReach {
            userInfoLabel.text = String(format: SearchConst.Cell.Text.UserInfo.armReachLabel, "\(armReach)")
        } else {
            userInfoLabel.text = nil
        }
        
        if searchStyle == .uploadSearch {
            applyDarkModeStyle()
            return
        }
        
        if traitCollection.userInterfaceStyle == .dark {
            applyDarkModeStyle()
        }
        else {
            applyLightModeStyle()
        }
    }
    
    private func applyDarkModeStyle() {
        self.backgroundColor = SearchConst.Cell.Color.backgroundDark
        userNameLabel.textColor = SearchConst.Cell.Color.userNameTextDark
        userInfoLabel.textColor = SearchConst.Cell.Color.userInfoTextDark
    }

    private func applyLightModeStyle() {
        self.backgroundColor = SearchConst.Cell.Color.background
        userNameLabel.textColor = SearchConst.Cell.Color.userNameText
        userInfoLabel.textColor = SearchConst.Cell.Color.userInfoText
    }

    @objc private func didTapDeleteButton() {
        guard let name = userNameLabel.text else { return }
        let itemToDelete = SearchResultItem(type: .user, name: name, imageName: "", location: nil, height: nil, armReach: nil)
        onDelete?(itemToDelete)
    }
}
