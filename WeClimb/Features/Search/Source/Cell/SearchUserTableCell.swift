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
        imageView.image = UIImage.avatarIconFill
        imageView.layer.cornerRadius = 36 / 2
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(style: .label2SemiBold)
        label.textColor = .labelStrong
        return label
    }()
    
    private let userHeightLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(style: .caption2Regular)
        label.textColor = .labelNeutral
        return label
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("삭제", for: .normal)
        button.setTitleColor(.labelNeutral, for: .normal)
        button.titleLabel?.font = UIFont.customFont(style: .caption1Regular)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        [userImageView, userNameLabel, userHeightLabel, cancelButton]
            .forEach { contentView.addSubview($0) }
      
        userImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(36)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.leading.equalTo(userImageView.snp.trailing).offset(8)
            $0.top.equalTo(userImageView.snp.top)
        }
        
        userHeightLabel.snp.makeConstraints {
            $0.top.equalTo(userNameLabel.snp.bottom).offset(2)
            $0.leading.equalTo(userNameLabel.snp.leading)
        }
        
        cancelButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
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
        if let height = item.height {
            userHeightLabel.text = "\(height) cm"
        } else {
            userHeightLabel.text = nil
        }
    }
}

