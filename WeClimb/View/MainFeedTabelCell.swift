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
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "YourCollectionViewCellIdentifier")
        collectionView.backgroundColor = .gray
        //        collectionView.showsHorizontalScrollIndicator = false //스크롤바 숨김 옵션
        return collectionView
    }()
    
    let feedProfileImage = {
        let Image = UIImageView()
        Image.layer.cornerRadius = 20
        //    Image.layer.borderWidth = 0.5
        Image.clipsToBounds = true
        Image.layer.borderColor = UIColor.systemGray3.cgColor
        return Image
    }()
    
    let feedprofileNameLabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    let feedprofileAddressLabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .systemGray2
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    let levelLabel = {
        let label = UILabel()
        label.textColor = .white
        label.backgroundColor = .blue
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
    
    //좋아요 버튼 수정 필요
    let likeButton = {
        let button = UIButton()
        return button
    }()
    
    let feedProfiletackView = {
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("*T_T*")
    }
    
    func setLayout() {
        [feedProfileImage, feedProfiletackView, collectionView, gymInfoStackView]
            .forEach {
                contentView.addSubview($0)
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
        [feedprofileNameLabel, feedprofileAddressLabel]
            .forEach {
                feedProfiletackView.addArrangedSubview($0)
            }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(feedProfileImage.snp.bottom).offset(7)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(350)
        }
        gymInfoStackView.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(7)
            $0.leading.equalToSuperview().inset(16)
        }
        feedProfiletackView.snp.makeConstraints {
            $0.leading.equalTo(feedProfileImage.snp.trailing).offset(10)
            $0.centerY.equalTo(feedProfileImage.snp.centerY)
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
        feedprofileNameLabel.snp.makeConstraints {
            $0.height.equalTo(13)
        }
        feedprofileAddressLabel.snp.makeConstraints {
            $0.height.equalTo(11)
        }
        feedProfileImage.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 40, height: 40))
            $0.leading.equalToSuperview().inset(16)
        }
    }
}
