//
//  ClimbingGymVC.swift
//  WeClimb
//
//  Created by Soo Jang on 8/26/24.
//

import UIKit
import SnapKit

class ClimbingGymVC: UIViewController {
    
    // MARK: - 간단 레이블 구성 DS
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let profileNameLabel: UILabel = {
        let label = UILabel()
        label.text = "000 클라이밍"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    private let followerLabel: UILabel = {
        let label = UILabel()
        label.text = "1999 팔로워"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .gray
        return label
    }()
    
    private let followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("팔로우", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["세팅", "정보"])
        segmentControl.selectedSegmentIndex = 0
        return segmentControl
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    // MARK: - 라이프 사이클 DS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
    
    private func setLayout() {
        view.backgroundColor = .white
        
        [
            profileImageView,
            profileNameLabel,
            followerLabel,
            followButton,
            segmentControl,
            contentView
        ].forEach { view.addSubview($0) }
    
        setConstraints()
    }
    
    // MARK: - 레이아웃 구성 DS
    private func setConstraints() {
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
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
        
        followButton.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView.snp.centerY)
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.equalTo(80)
            $0.height.equalTo(32)
        }
        
        segmentControl.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(segmentControl.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview()
        }
    }
}

