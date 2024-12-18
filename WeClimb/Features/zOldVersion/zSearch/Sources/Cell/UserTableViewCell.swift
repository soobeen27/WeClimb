//
//  UserTableViewCell.swift
//  WeClimb
//
//  Created by 머성이 on 9/13/24.
//

import UIKit

import Kingfisher
import SnapKit

class UserTableViewCell: UITableViewCell {
    
    private let userImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 28
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 1 // 한줄만
        return label
    }()
    
    private let titleDetail: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .gray
        label.numberOfLines = 1 // 한줄만
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        self.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        
        [userImage, titleLabel, titleDetail]
            .forEach { contentView.addSubview($0) }
        
        userImage.snp.makeConstraints {
            $0.leading.equalTo(contentView.snp.leading).offset(15)
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.width.height.equalTo(56)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(userImage.snp.trailing).offset(10)
            $0.top.equalTo(contentView.snp.top).offset(20)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-15)
        }
        
        titleDetail.snp.makeConstraints {
            $0.leading.equalTo(userImage.snp.trailing).offset(10)
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-15)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-20)
        }
    }
    
    func configure(with data: User) {
        titleLabel.text = data.userName
        titleDetail.text = ""
        
        // Kingfisher로 이미지 로드
        if let imageUrl = data.profileImage {
            FirebaseManager.shared.loadImage(from: imageUrl, into: userImage)
        } else {
            userImage.image = UIImage(named: "testStone")
        }
    }
}

