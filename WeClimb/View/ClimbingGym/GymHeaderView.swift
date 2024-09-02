//
//  GymHeaderView.swift
//  WeClimb
//
//  Created by 머성이 on 9/2/24.
//

import UIKit

import SnapKit

class GymHeaderView: UIView {
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let profileNameLabel: UILabel = {
        let label = UILabel()
        label.text = "000 클라이밍"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    let followerLabel: UILabel = {
        let label = UILabel()
        label.text = "1999 팔로워"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .gray
        return label
    }()
    
    let socialStackView: UIStackView = {
        let instagramImageView = UIImageView(image: UIImage(systemName: "camera.fill"))
        instagramImageView.tintColor = .systemPink
        instagramImageView.snp.makeConstraints { $0.size.equalTo(CGSize(width: 20, height: 20)) }
        
        let naverMapImageView = UIImageView(image: UIImage(systemName: "map.fill"))
        naverMapImageView.tintColor = .systemGreen
        naverMapImageView.snp.makeConstraints { $0.size.equalTo(CGSize(width: 20, height: 20)) }
        
        let stackView = UIStackView(arrangedSubviews: [naverMapImageView, instagramImageView])
        stackView.axis = .horizontal
        stackView.spacing = 16
        return stackView
    }()
    
    let followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("팔로우", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 10
        return button
    }()
    
    let segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["세팅", "정보"])
        segmentControl.selectedSegmentIndex = 0
        return segmentControl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        [profileImageView, profileNameLabel, followerLabel, socialStackView, followButton, segmentControl].forEach {
            addSubview($0)
        }
        
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.width.height.equalTo(80)
        }
        
        profileNameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.top)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(16)
        }
        
        followerLabel.snp.makeConstraints {
            $0.top.equalTo(profileNameLabel.snp.bottom).offset(8)
            $0.leading.equalTo(profileNameLabel.snp.leading)
        }
        
        socialStackView.snp.makeConstraints {
            $0.top.equalTo(followerLabel.snp.bottom).offset(8)
            $0.leading.equalTo(followerLabel.snp.leading)
        }
        
        followButton.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView.snp.centerY)
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.equalTo(80)
            $0.height.equalTo(32)
        }
        
        segmentControl.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-16)
        }
    }
}
