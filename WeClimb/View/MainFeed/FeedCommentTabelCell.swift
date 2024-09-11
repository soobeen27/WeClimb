//
//  FeedCommentTabelCell.swift
//  WeClimb
//
//  Created by 김솔비 on 9/11/24.
//

import UIKit

import SnapKit

class FeedCommentCell: UITableViewCell {
    
    private let commentProfileImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 19
        image.clipsToBounds = true
        image.layer.borderColor = UIColor.systemGray3.cgColor
        return image
    }()
    
    private let commentUser: UILabel = {
        let label = UILabel()
//        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        return label
    }()
    
    private let commentLabel: UILabel = {
        let label = UILabel()
//        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13, weight: .light)
        label.numberOfLines = 0
        return label
    }()
    
    private let likeButton = UIButton()
    
    private let likeButtonCounter: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .medium)
//        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let commentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 3
        return stackView
    }()
    
    private let likeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        likeButton.configureHeartButton()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setLayout() {
        [commentProfileImage, commentStackView, likeStackView]
            .forEach {
                contentView.addSubview($0)
            }
        [commentUser, commentLabel]
            .forEach {
                commentStackView.addArrangedSubview($0)
            }
        [likeButton, likeButtonCounter]
            .forEach {
            likeStackView.addArrangedSubview($0)
        }
        commentProfileImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(5)
            $0.leading.equalToSuperview().inset(16)
            $0.width.height.equalTo(38)
        }
        commentStackView.snp.makeConstraints {
            $0.top.equalTo(commentProfileImage.snp.top)
            $0.bottom.equalToSuperview().inset(5)
            $0.leading.equalTo(commentProfileImage.snp.trailing).offset(10)
            $0.trailing.equalTo(likeStackView.snp.leading).offset(-10)
        }
        likeStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(5)
            $0.trailing.equalToSuperview().inset(16)
        }
        likeButton.imageView?.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 20, height: 18))
        }
        likeButton.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 20, height: 20))
        }
    }
    //MARK: - configure
    func configure(userImage: UIImage, userName: String, userComment: String, likeCounter: String) {
        commentProfileImage.image = userImage
        commentUser.text = userName
        commentLabel.text = userComment
        likeButtonCounter.text = likeCounter
    }
}
