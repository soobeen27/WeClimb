//
//  MainFeedTabelCell.swift
//  WeClimb
//
//  Created by 김솔비 on 8/26/24.
//

import UIKit

import SnapKit

class MainFeedTabelCell: UITableViewCell {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal //가로 스크롤
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: Identifiers.yourCollectionViewCellIdentifier)
        collectionView.backgroundColor = .gray
        //        collectionView.showsHorizontalScrollIndicator = false //스크롤바 숨김 옵션
        return collectionView
    }()
    
    let feedCaptionLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textAlignment = .left
        label.textColor = .black
        label.numberOfLines = 1  //1줄까지만 표시
        label.lineBreakMode = .byTruncatingTail  //1줄 이상 시 ... 표기
//        label.lineBreakMode = .byWordWrapping  //자동 줄바꿈
        return label
    }()
    
    let feedUserProfileImage = {
        let Image = UIImageView()
        Image.layer.cornerRadius = 20
        Image.clipsToBounds = true
        Image.layer.borderColor = UIColor.systemGray3.cgColor
        return Image
    }()
    
    let feedUserNameLabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    let feedProfileAddressLabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .systemGray2
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    let levelLabel = {
        let label = UILabel()
        label.textColor = .white
        label.backgroundColor = .mainPurple
        label.clipsToBounds = true
        return label
    }()
    
    let sectorLabel = {
        let label = UILabel()
        return label
    }()
    
    let dDayLabel = {
        let label = UILabel()
        return label
    }()
    
    let likeButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .mainPurple
        return button
    }()
    
    let likeButtonCounter = {
        let label = UILabel()
        label.textColor = .mainPurple
        label.font = .boldSystemFont(ofSize: 15)
        return label
    }()
    
    let feedProfileStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 6
        return stackView
    }()
    
    let gymInfoStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 7
        return stackView
    }()
    
    let likeStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("*T_T*")
    }
    
    private func setLayout() {
        [feedUserProfileImage, feedProfileStackView, collectionView, gymInfoStackView, likeStackView, feedCaptionLabel]
            .forEach {
                contentView.addSubview($0)
            }
        [likeButton, likeButtonCounter]
            .forEach {
                likeStackView.addArrangedSubview($0)
            }
        [levelLabel, sectorLabel, dDayLabel]
            .forEach {
                gymInfoStackView.addArrangedSubview($0)
                $0.font = .systemFont(ofSize: 13)
                $0.textAlignment = .center
                $0.layer.cornerRadius = 10
                $0.layer.borderWidth = 0.5
                $0.layer.borderColor = UIColor.systemGray3.cgColor
            }
        [feedUserNameLabel, feedProfileAddressLabel]
            .forEach {
                feedProfileStackView.addArrangedSubview($0)
            }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(feedUserProfileImage.snp.bottom).offset(7)
            $0.width.equalToSuperview()
            $0.height.equalTo(collectionView.snp.width)
        }
        gymInfoStackView.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(7)
            $0.leading.equalToSuperview().inset(16)
        }
        feedCaptionLabel.snp.makeConstraints {
            $0.top.equalTo(gymInfoStackView.snp.bottom).offset(7)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        feedProfileStackView.snp.makeConstraints {
            $0.leading.equalTo(feedUserProfileImage.snp.trailing).offset(10)
            $0.centerY.equalTo(feedUserProfileImage.snp.centerY)
        }
        likeStackView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalTo(gymInfoStackView.snp.centerY)
        }
        gymInfoStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
        }
        levelLabel.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 45, height: 19))
        }
        sectorLabel.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 45, height: 19))
        }
        dDayLabel.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 45, height: 19))
        }
        feedUserNameLabel.snp.makeConstraints {
            $0.height.equalTo(13)
        }
        feedProfileAddressLabel.snp.makeConstraints {
            $0.height.equalTo(11)
        }
        feedUserProfileImage.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 40, height: 40))
            $0.leading.equalToSuperview().inset(16)
        }
    }
    
    func configure(userProfileImage: UIImage, userName: String, address: String, caption: String, level: String, sector: String, dDay: String, likeCounter: String) {
        feedUserProfileImage.image = userProfileImage
        feedUserNameLabel.text = userName
        feedProfileAddressLabel.text = address
        feedCaptionLabel.text = caption
        levelLabel.text = level
        sectorLabel.text = sector
        dDayLabel.text = dDay
        likeButtonCounter.text = likeCounter
    }
}
