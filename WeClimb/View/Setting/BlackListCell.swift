//
//  BlackListCell.swift
//  WeClimb
//
//  Created by 머성이 on 9/26/24.
//

import UIKit

import SnapKit
import RxSwift

class BlackListCell: UITableViewCell {
    
    var disposeBag = DisposeBag()
    
    private let userProfileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.label
        return label
    }()
    
    let manageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("해제", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .light)
        button.setTitleColor(UIColor.label, for: .normal)
        button.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        
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
    
    // 셀에 유저 정보 설정
    func configure(with user: User) {
        nameLabel.text = user.userName ?? "Unknown"
        
        // Kingfisher 등을 사용해 이미지 로드 (여기서는 기본 이미지 사용)
        if let profileImageURL = user.profileImage {
            FirebaseManager.shared.loadImage(from: profileImageURL, into: userProfileImage)
        } else {
            userProfileImage.image = UIImage(named: "testStone")
        }
    }
    
    // 재사용될 때 disposeBag을 새로 만들어줌 (RxSwift의 재사용 문제 해결)
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
