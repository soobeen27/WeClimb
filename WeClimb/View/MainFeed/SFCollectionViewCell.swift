//
//  SFCollectionViewCell.swift
//  WeClimb
//
//  Created by 김솔비 on 9/5/24.
//

import UIKit

import SnapKit

class SFCollectionViewCell: UICollectionViewCell {
    
    var commentButtonTapped: (() -> Void)? // 클로저 정의
    
    //MARK: - UI 세팅
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal //가로 스크롤
        layout.itemSize = CGSize(width: self.frame.width, height: self.frame.width * (16.0/9.0))
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        collectionView.frame = self.bounds
        collectionView.showsHorizontalScrollIndicator = false //스크롤바 숨김 옵션
        return collectionView
    }()
    
    private let feedCaptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 1  //1줄까지만 표시
        label.lineBreakMode = .byTruncatingTail  //1줄 이상 ... 표기
        return label
    }()
    
    private let feedUserProfileImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 20
        image.clipsToBounds = true
        image.layer.borderColor = UIColor.systemGray3.cgColor
        return image
    }()
    
    private let feedUserNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    private let feedProfileAddressLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .systemGray2
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    private let followButton: UIButton = {
        let button = UIButton()
        button.setTitle("Follow", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.systemGray3.cgColor
        return button
    }()
    
    private let levelLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.backgroundColor = .mainPurple.withAlphaComponent(0.5)
        label.clipsToBounds = true
        return label
    }()
    
    private let sectorLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        return label
    }()
    
    private let dDayLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        return label
    }()
    
    private let likeButton = UIButton()
    
    private let likeButtonCounter: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let commentButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "bubble"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white
        return button
    }()
    
    private let commentButtonCounter: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let ellipsisButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white
        return button
    }()
    
    private let feedProfileStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    
    private let gymInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 15
        return stackView
    }()
    
    private let likeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 1
        return stackView
    }()
    
    private let commentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 1
        return stackView
    }()
    
    
    //MARK: - 코드 시작
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        likeButton.configureHeartButton()
        setCollectionView()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("*T_T*")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //셀의 내용을 초기화하여 이전 데이터 제거
        feedUserNameLabel.text = nil
        feedProfileAddressLabel.text = nil
        feedCaptionLabel.text = nil
        likeButtonCounter.text = nil
        feedUserProfileImage.image = nil
    }
    
    private func setCollectionView() {
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: Identifiers.collectionViewCell)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.isPagingEnabled = true
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)  //컬렉션뷰 상단좌우 여백 삭제
    }
    
    
    //MARK: - 레이아웃 설정
    private func setLayout() {
        [feedUserNameLabel, likeButton, commentButton, followButton, likeButtonCounter, commentButtonCounter, ellipsisButton]
            .forEach { view in
                addShadow(to: view)
            }
        
        self.backgroundColor = UIColor(hex: "#0C1014")
        self.addSubview(collectionView)
        [feedProfileStackView, followButton, likeStackView, commentStackView, gymInfoStackView, feedCaptionLabel, ellipsisButton]
            .forEach {
                self.addSubview($0)
            }
        [feedUserProfileImage, feedUserNameLabel]
            .forEach {
                feedProfileStackView.addArrangedSubview($0)
            }
        [likeButton, likeButtonCounter]
            .forEach {
                likeStackView.addArrangedSubview($0)
            }
        [commentButton, commentButtonCounter]
            .forEach {
                commentStackView.addArrangedSubview($0)
            }
        [levelLabel, sectorLabel, dDayLabel]
            .forEach {
                gymInfoStackView.addArrangedSubview($0)
                $0.font = .systemFont(ofSize: 13)
                $0.textColor = .white
                $0.textAlignment = .center
                $0.layer.cornerRadius = 5
                $0.layer.borderWidth = 0.5
                $0.layer.borderColor = UIColor.systemGray5.cgColor
                $0.layer.opacity = 0.8  //투명도
                $0.layer.masksToBounds = true  //코너를 넘지 않도록 설정
            }
        
        collectionView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(collectionView.snp.width).multipliedBy(16.0/9.0) //아이폰 평균 동영상 촬영 비율(16:9)
        }
        feedProfileStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(UIScreen.main.bounds.height * 0.76)
            $0.leading.equalToSuperview().inset(16)
        }
        feedUserProfileImage.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 40, height: 40))
        }
        feedUserNameLabel.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 100, height: 40))
        }
        followButton.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 50, height: 20))
            $0.centerY.equalTo(feedProfileStackView.snp.centerY)
            $0.leading.equalTo(feedProfileStackView.snp.trailing)
        }
        feedCaptionLabel.snp.makeConstraints {
            $0.top.equalTo(feedProfileStackView.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        gymInfoStackView.snp.makeConstraints {
            $0.top.equalTo(feedCaptionLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(16)
        }
        levelLabel.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 45, height: 20))
        }
        sectorLabel.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 45, height: 20))
        }
        dDayLabel.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 45, height: 20))
        }
        likeStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(UIScreen.main.bounds.height * 0.57)  //기기화면 비율
            $0.trailing.equalToSuperview().inset(10)
        }
        likeButton.imageView?.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 35, height: 30))
        }
        likeButton.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 35, height: 35))
        }
        commentStackView.snp.makeConstraints {
            $0.top.equalTo(likeStackView.snp.bottom).offset(20)
            //            $0.centerY.equalTo(likeStackView.snp.centerY)
            $0.trailing.equalToSuperview().inset(10)
        }
        commentButton.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 35, height: 35))
            $0.top.equalTo(likeStackView.snp.bottom).offset(20)
        }
        commentButton.imageView?.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 35, height: 35))
        }
        ellipsisButton.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 40, height: 22))
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(5)
            $0.trailing.equalToSuperview().inset(16)
        }
        ellipsisButton.imageView?.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 40, height: 22))
        }
    }
    
    
    //MARK: - configure
    func configure(userProfileImage: UIImage, userName: String, address: String, caption: String, level: String, sector: String, dDay: String, likeCounter: String, commentCounter: String) {
        feedUserProfileImage.image = userProfileImage
        feedUserNameLabel.text = userName
        feedProfileAddressLabel.text = address
        feedCaptionLabel.text = caption
        levelLabel.text = level
        sectorLabel.text = sector
        dDayLabel.text = dDay
        likeButtonCounter.text = likeCounter
        commentButtonCounter.text = commentCounter
    }
    
    
    //MARK: - 버튼 그림자 모드
    func addShadow(to view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor //그림자 색상
        view.layer.shadowOffset = CGSize(width: 1, height: 1) //그림자 위치
        view.layer.shadowOpacity = 0.5 //그림자 투명도
        view.layer.shadowRadius = 2 //그림자의 흐림(퍼짐) 정도
        view.layer.masksToBounds = false //테두리에 그림자가 잘리지 않도록 설정
    }
}
    

//MARK: - 컬렉션뷰 프로토콜 설정
extension SFCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.collectionViewCell, for: indexPath)
        cell.backgroundColor = UIColor(hex: "#0C1014")
        
        //샘플 이미지 삽입
        let testImage: UIImageView = {
            let image = UIImageView()
            image.image = UIImage(named: "feedTestImage")
            image.contentMode = .scaleAspectFill
            image.translatesAutoresizingMaskIntoConstraints = false
            return image
        }()
        
        cell.contentView.addSubview(testImage)
        
        testImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        
        print("내부 컬렉션뷰셀의 cellForItemAt 호출됨: \(indexPath)")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

