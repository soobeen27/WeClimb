//
//  SearchTableViewCell.swift
//  WeClimb
//
//  Created by 강유정 on 8/27/24.
//

import UIKit

import Kingfisher
import SnapKit

class GymTableViewCell: UITableViewCell {
    
    private var currentImageURL: String?
    
    private let gymImage: UIImageView = {
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
    
    private let addressLabel: UILabel = {
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
        
        [gymImage, titleLabel, addressLabel]
            .forEach { contentView.addSubview($0) }
        
        gymImage.snp.makeConstraints {
            $0.leading.equalTo(contentView.snp.leading).offset(15)
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.width.height.equalTo(56)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(gymImage.snp.trailing).offset(10)
            $0.top.equalTo(contentView.snp.top).offset(20)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-15)
        }
        
        addressLabel.snp.makeConstraints {
            $0.leading.equalTo(gymImage.snp.trailing).offset(10)
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-15)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-20)
        }
    }
    
    func configure(with model: Gym) {
        titleLabel.text = model.gymName
        addressLabel.text = model.address
        
        // Kingfisher로 이미지 로드
        if let imageUrl = model.profileImage, imageUrl != currentImageURL {
            currentImageURL = imageUrl
            gymImage.image = nil // 기존 이미지 제거
            FirebaseManager.shared.loadImage(from: imageUrl, into: gymImage)
        } else if model.profileImage == nil {
            gymImage.image = UIImage(named: "defaultImage")
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // 셀 재사용 시 초기화
        gymImage.image = nil
        currentImageURL = nil
    }
}
