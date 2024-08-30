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
    
    private let feedCaptionLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textAlignment = .left
        label.numberOfLines = 1  //1줄까지만 표시
        label.lineBreakMode = .byTruncatingTail  //1줄 이상 시 ... 표기
        //        label.lineBreakMode = .byWordWrapping  //자동 줄바꿈
        return label
    }()
    
    private let feedUserProfileImage = {
        let Image = UIImageView()
        Image.layer.cornerRadius = 20
        Image.clipsToBounds = true
        Image.layer.borderColor = UIColor.systemGray3.cgColor
        return Image
    }()
    
    private let feedUserNameLabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private let feedProfileAddressLabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .systemGray2
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    private let levelLabel = {
        let label = UILabel()
        label.textColor = .white
        label.backgroundColor = .mainPurple
        label.clipsToBounds = true
        return label
    }()
    
    private let sectorLabel = {
        let label = UILabel()
        return label
    }()
    
    private let dDayLabel = {
        let label = UILabel()
        return label
    }()
    
    private let likeButton = UIButton()
    
//    private let likeButton = {
//        let button = UIButton()
//        button.setImage(UIImage(systemName: "heart"), for: .normal)
//        button.imageView?.contentMode = .scaleAspectFit
//        button.tintColor = .mainPurple
//        return button
//    }()
    
    private let likeButtonCounter = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 15)
        return label
    }()
    
    private let feedProfileStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 6
        return stackView
    }()
    
    private let gymInfoStackView = {
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        likeButton.configureHeartButton()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("*T_T*")
    }
    
    private func setLayout() {
        self.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        
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
            //            $0.centerY.equalTo(gymInfoStackView.snp.centerY)
        }
        //        likeButtonCounter.snp.makeConstraints {
        //            $0.top.equalTo(collectionView.snp.bottom).offset(7)
        //        }
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


extension UIButton {
    
    //버튼의 활성화 상태를 나타내는 변수
    private struct AssociatedKeys {
        static var isActivated = "isActivated"
    }
    
    var isActivated: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.isActivated) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.isActivated, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            updateImage()
        }
    }
    
    //활성화 상태
    private var activatedImage: UIImage? {
        return UIImage(systemName: "heart.fill")?
            .withTintColor(UIColor(hex: "#DA407A"))
            .withRenderingMode(.alwaysOriginal)
    }
    
    //비활성화 상태
    private var normalImage: UIImage? {
        return UIImage(systemName: "heart")?
            .withTintColor(UIColor(hex: "#CDCDCD"))
            .withRenderingMode(.alwaysOriginal)
    }
    
    //버튼의 이미지를 현재 상태에 따라 업데이트
    private func updateImage() {
        let image = isActivated ? activatedImage : normalImage
        self.setImage(image, for: .normal)
    }
    
    func configureHeartButton() {
        self.updateImage() // 초기 이미지 설정
        self.addTarget(self, action: #selector(onHeartButtonClicked), for: .touchUpInside)
    }
    
    //버튼클릭 시 호출
    @objc private func onHeartButtonClicked() {
        self.isActivated.toggle() // 활성화 상태를 변경
        animateHeartButton() // 애니메이션 적용
    }
    
    //버튼클릭 시 애니메이션을 적용
    private func animateHeartButton() {
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            guard let self = self else { return }
            // 클릭되었을 때 축소되는 애니메이션
            self.transform = self.transform.scaledBy(x: 0.5, y: 0.5)
        }, completion: { _ in
            // 원래 크기로 되돌아가는 애니메이션
            UIView.animate(withDuration: 0.1, animations: {
                self.transform = CGAffineTransform.identity
            })
        })
    }
}
