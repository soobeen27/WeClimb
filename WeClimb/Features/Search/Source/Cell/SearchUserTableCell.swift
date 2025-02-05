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
        imageView.image = SearchConst.Image.defaultUserImage
        imageView.layer.cornerRadius = SearchConst.Shape.cellImageCornerRadius
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(style: .label2SemiBold)
        label.textColor = .labelStrong
        return label
    }()
    
    private let userInfoLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(style: .caption2Regular)
        label.textColor = .labelNeutral
        return label
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle(SearchConst.Text.cellCancelBtnTitle, for: .normal)
        button.setTitleColor(SearchConst.Color.cellCancelBtnTitleColor, for: .normal)
        button.titleLabel?.font = SearchConst.Font.cellCancelBtnFont
        button.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        return button
    }()
    
    var onDelete: ((SearchResultItem) -> Void)?
    
    var shouldShowDeleteButton: Bool = true {
        didSet {
            deleteButton.isHidden = !shouldShowDeleteButton
        }
    }
    
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
            $0.leading.equalToSuperview().inset(SearchConst.userCell.Spacing.userImageleftSpacing)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(SearchConst.userCell.Size.userImageSize)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.leading.equalTo(userImageView.snp.trailing).offset(SearchConst.userCell.Spacing.userNameleftSpacing)
            $0.top.equalTo(userImageView.snp.top)
        }
        
        userInfoLabel.snp.makeConstraints {
            $0.top.equalTo(userNameLabel.snp.bottom).offset(SearchConst.userCell.Spacing.userInfoTopSpacing)
            $0.leading.equalTo(userNameLabel.snp.leading)
        }
        
        deleteButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(SearchConst.userCell.Spacing.cancelBtnRightSpacing)
            $0.centerY.equalToSuperview()
        }
    }
    
    func configure(with item: SearchResultItem) {
        
        if item.imageName.isEmpty || URL(string: item.imageName) == nil {
            userImageView.image = UIImage.defaultAvatarProfile
        } else {
            let imageURL = URL(string: item.imageName)
            userImageView.kf.setImage(with: imageURL)
        }
        
        userNameLabel.text = item.name
        if let height = item.height, let armReach = item.armReach {
            userInfoLabel.text = String(format: SearchConst.Text.UserInfo.heightAndArmReachLabel, "\(height)", "\(armReach)")
        } else if let height = item.height {
            userInfoLabel.text = String(format: SearchConst.Text.UserInfo.heightLabel, "\(height)")
        } else if let armReach = item.armReach {
            userInfoLabel.text = String(format: SearchConst.Text.UserInfo.armReachLabel, "\(armReach)")
        } else {
            userInfoLabel.text = nil
        }
    }
    
    @objc private func didTapDeleteButton() {
        guard let name = userNameLabel.text else { return }
        let itemToDelete = SearchResultItem(type: .user, name: name, imageName: "", location: nil, height: nil, armReach: nil)
        onDelete?(itemToDelete)
    }
}

