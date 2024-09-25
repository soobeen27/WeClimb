//
//  BlackListCell.swift
//  WeClimb
//
//  Created by 머성이 on 9/26/24.
//

import UIKit

import SnapKit

class BlackListCell: UITableViewCell {
    
    private let userProfileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    let manageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("관리", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .black
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        [
            userProfileImage,
            nameLabel,
            manageButton
        ].forEach { contentView.addSubview($0) }
        
        userProfileImage.snp.makeConstraints {
            $0.size.equalTo(40)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(userProfileImage)
            $0.leading.equalTo(userProfileImage.snp.trailing).offset(12)
        }
        
        manageButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.equalTo(50)
            $0.height.equalTo(30)
        }
    }
    
    // 셀에 데이터 설정
    func configure(icon: UIImage?, name: String) {
        // 정보들 넣기
    }
}
