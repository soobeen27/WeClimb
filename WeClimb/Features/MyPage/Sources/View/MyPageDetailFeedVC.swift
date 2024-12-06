//
//  MyPageModalVC.swift
//  WeClimb
//
//  Created by 김솔비 on 9/4/24.
//

import UIKit

import SnapKit

class MyPageDetailFeedVC: UIViewController {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal //가로 스크롤
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: Identifiers.mainCollectionViewCell)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: SFCollectionViewCell.className)
        collectionView.backgroundColor = .gray
        return collectionView
    }()
    
    private let feedCaptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private let feedUserProfileImage: UIImageView = {
        let Image = UIImageView()
        Image.layer.cornerRadius = 20
        Image.clipsToBounds = true
        Image.layer.borderColor = UIColor.systemGray3.cgColor
        Image.backgroundColor = .systemGray //데이터 연결 시 삭제
        return Image
    }()
    
    private let feedUserNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private let feedProfileAddressLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .systemGray2
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    private let levelLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.backgroundColor = .mainPurple
        label.clipsToBounds = true
        return label
    }()
    
    private let sectorLabel = UILabel()
    
    private let dDayLabel = UILabel()
    
    private let likeButton = UIButton()
    
    private let likeButtonCounter: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 15)
        return label
    }()
    
    private let feedProfileStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 6
        return stackView
    }()
    
    private let gymInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 7
        return stackView
    }()
    
    private let likeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        likeButton.configureHeartButton()
        setLayout()
//        configure()
    }
    
    private func setLayout() {
        view.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        
        [feedUserProfileImage, feedProfileStackView, collectionView, gymInfoStackView, likeStackView, feedCaptionLabel]
            .forEach {
                view.addSubview($0)
            }
        [likeButton, likeButtonCounter]
            .forEach {
                likeStackView.addArrangedSubview($0)
            }
        [levelLabel, sectorLabel, dDayLabel]
            .forEach {
                gymInfoStackView.addArrangedSubview($0)
                $0.font = .systemFont(ofSize: 15)
                $0.textAlignment = .center
                $0.layer.cornerRadius = 11
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
            $0.top.equalTo(gymInfoStackView.snp.bottom).offset(15)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        feedProfileStackView.snp.makeConstraints {
            $0.leading.equalTo(feedUserProfileImage.snp.trailing).offset(10)
            $0.centerY.equalTo(feedUserProfileImage.snp.centerY)
        }
        likeStackView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(collectionView.snp.bottom).offset(7)
        }
        likeButton.imageView?.snp.makeConstraints {
            $0.width.height.equalTo(25)
        }
        likeButton.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 25, height: 25))
            $0.trailing.equalToSuperview().inset(35)
        }
        levelLabel.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 50, height: 22))
        }
        sectorLabel.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 50, height: 22))
        }
        dDayLabel.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 50, height: 22))
        }
        feedUserNameLabel.snp.makeConstraints {
            $0.height.equalTo(13)
        }
        feedProfileAddressLabel.snp.makeConstraints {
            $0.height.equalTo(11)
        }
        feedUserProfileImage.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 40, height: 40))
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.leading.equalToSuperview().inset(16)
        }
    }
    
    private func configure(userProfileImage: UIImage? = nil, userName: String? = nil, address: String? = nil, caption: String? = nil, level: String? = nil, sector: String? = nil, dDay: String? = nil, likeCounter: String? = nil) {
        feedUserProfileImage.image = userProfileImage ?? UIImage(named: "testImage")
        feedUserNameLabel.text = userName ?? "김애옹"
        feedProfileAddressLabel.text = address ?? "관악구 신림동"
        feedCaptionLabel.text = caption ?? """
        1. 언성이 높아지면 애옹체로 말하기 (ex:이거 시간안에 못끝내면 안된다애옹🐱)
        2. 정기 회의는 일 2회 (10:00 / 19:00) 참여가 힘든경우 미리(최소 한시간 전) 말하기
        3. 알잘딱
        4. 잡담 많이하기
        5. 불만있으면 바로 얘기하기
        6. 19시 정기회의시 진행상황 간단하게 브리핑하는 시간 갖기
        7. 고민이 30분 이상 넘어가면 바로 질문박기
        """
        levelLabel.text = level ?? "V6"
        sectorLabel.text = sector ?? "1섹터"
        dDayLabel.text = dDay ?? "D-14"
        likeButtonCounter.text = likeCounter ?? "111"
    }
}
