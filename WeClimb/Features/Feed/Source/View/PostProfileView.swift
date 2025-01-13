//
//  PostProfileView.swift
//  WeClimb
//
//  Created by Soobeen Jang on 1/9/25.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

class PostProfileView: UIView {
    let disposeBag = DisposeBag()
    var profileImage: UIImage? {
        didSet {
            profileImageView.image = profileImage
        }
    }
    var name: String? {
        didSet {
            nameLabel.text = name
        }
    }
    
    var gymName: String? {
        didSet {
            gymTag.text = gymName
        }
    }
    var heightArmReach: String? {
        didSet {
            heightArmReachLabel.text = heightArmReach
        }
    }
    
    var level: UIImage? {
        didSet {
            levelTag.rightImage = level
        }
    }
    
    var hold: UIImage? {
        didSet {
            holdTag.rightImage = hold
        }
    }
    
    var caption: String? {
        didSet {
            captionLabel.text = caption
        }
    }
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = FeedConsts.Profile.Size.profileImageCornerRadius
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = FeedConsts.Profile.Font.name
        label.textColor = FeedConsts.Profile.Color.text
        return label
    }()
    
    private let heightArmReachLabel: UILabel = {
        let label = UILabel()
        label.font = FeedConsts.Profile.Font.caption
        label.textColor = UIColor.labelWhite
        return label
    }()
    
    private let hideButton: UIButton = {
        let button = UIButton()
        button.setImage(FeedConsts.Profile.Image.show, for: .normal)
        button.setImage(FeedConsts.Profile.Image.hide, for: .selected)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private lazy var userInfoView: UIView = {
        let view = UIView()
        [profileImageView, nameLabel, heightArmReachLabel, hideButton]
            .forEach {
                view.addSubview($0)
            }
        return view
    }()
    
    private lazy var tagsView: UIView = {
        let view = UIView()
        [gymTag, levelTag, holdTag]
            .forEach {
                view.addSubview($0)
            }
        return view
    }()
    
    private let gymTag: PostTagView = {
        let tagView = PostTagView()
        tagView.leftImage = FeedConsts.Profile.Image.locaction
        return tagView
    }()
    
    private let levelTag: PostTagView = {
        let tagView = PostTagView()
        tagView.text = FeedConsts.Profile.Text.level
        return tagView
    }()
    
    private let holdTag: PostTagView = {
        let tagView = PostTagView()
        tagView.text = FeedConsts.Profile.Text.hold
        return tagView
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = FeedConsts.Profile.Font.caption
        label.textColor = FeedConsts.Profile.Color.text
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var captionSCV: UIScrollView = {
        let scv = UIScrollView()
        scv.addSubview(captionLabel)
        scv.isScrollEnabled = false
        scv.contentSize = CGSize(width: scv.frame.width, height: scv.frame.height * 2)
        scv.showsHorizontalScrollIndicator = false
    
        let captionSCVTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(captionSCVTapped))
        captionSCVTapRecognizer.numberOfTapsRequired = 1
        scv.addGestureRecognizer(captionSCVTapRecognizer)
        return scv
    }()
    
    private lazy var profileStackView: UIStackView = {
        let stv = UIStackView(arrangedSubviews: [userInfoView, tagsView, captionSCV])
        stv.axis = .vertical
        stv.spacing = FeedConsts.Profile.Size.spacing
        stv.distribution = .fill
        stv.alignment = .leading
        return stv
    }()
    
    init() {
        super.init(frame: .zero)
        setLayout()
        bindHideButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func captionSCVTapped() {
        captionSCV.isScrollEnabled.toggle()
        let newHeight: CGFloat = captionSCV.isScrollEnabled ? FeedConsts.Profile.Size.captionLongHeight : FeedConsts.Profile.Size.captionShortHeight
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            self.captionLabel.numberOfLines = self.captionSCV.isScrollEnabled ? 0 : 2
            self.captionSCV.snp.updateConstraints {
                $0.height.equalTo(newHeight)
            }
            self.captionSCV.layer.layoutIfNeeded()
        }  completion: { [weak self] _ in
            guard let self = self else { return }
            self.captionSCV.contentSize = self.captionLabel.intrinsicContentSize
        }
    }
    
    private func bindHideButton() {
        hideButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self else { return }
                self.hideButton.isSelected.toggle()
                toggleStackView()
            })
            .disposed(by: disposeBag)
    }
    
    private func toggleStackView() {
        for (index, view) in self.profileStackView.arrangedSubviews.enumerated() {
            if index != 0 {
                view.isHidden = self.hideButton.isSelected
            }
        }
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            self.profileStackView.layer.layoutIfNeeded()
        }
    }
    
    private func setLayout() {
        setProfileStackViewLayout()
        setUserInfoViewLayout()
        setTagsViewLayout()
        setCaptionLayout()
    }
    
    private func setProfileStackViewLayout() {
        self.addSubview(profileStackView)
        
        profileStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(FeedConsts.Profile.Size.padding)
        }

    }
    
    private func setUserInfoViewLayout() {
        userInfoView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.size.equalTo(CGSize(
                width: FeedConsts.Profile.Size.profileImageSize,
                height: FeedConsts.Profile.Size.profileImageSize)
            )
        }
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(FeedConsts.Profile.Size.userNameProfileImageSpacing)
            $0.top.equalToSuperview()
        }
        
        heightArmReachLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(FeedConsts.Profile.Size.userNameHeightSpacing)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(FeedConsts.Profile.Size.userNameProfileImageSpacing)
            $0.bottom.equalToSuperview()
        }
        
        hideButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
    
    private func setTagsViewLayout() {
        gymTag.snp.makeConstraints {
            $0.leading.top.equalToSuperview()
        }
        levelTag.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview()
            $0.top.equalTo(gymTag.snp.bottom).offset(FeedConsts.Profile.Size.tagsViewHSpacing)
        }
        holdTag.snp.makeConstraints {
            $0.leading.equalTo(levelTag.snp.trailing).offset(FeedConsts.Profile.Size.tagsViewWSpacing)
            $0.bottom.equalToSuperview()
            $0.top.equalTo(levelTag.snp.top)
        }
    }
    
    private func setCaptionLayout() {
        captionSCV.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(FeedConsts.Profile.Size.captionShortHeight)
        }
        captionLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
    }
}
