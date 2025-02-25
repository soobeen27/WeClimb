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
import Kingfisher

struct PostProfileModel {
    let profileImage: String?
    let name: String?
    let gymName: String?
    let heightArmReach: String?
    let level: UIImage?
    let hold: UIImage?
    let caption: String?
}

class PostProfileView: UIView {
    var disposeBag = DisposeBag()
    
    private var profileModel: PostProfileModel? {
        didSet {
            setData()
            dataCheck()
            bindHideButton()
        }
    }
    
    var nameTapEvent: Observable<String?> {
        userTapGestureRecognizer.rx.event
            .map { [weak self] _ -> String? in
                return self?.profileModel?.name
            }
    }
    
    var gymTapEvent: Observable<String?> {
        gymTapGestureRecognizer.rx.event
            .map { [weak self] _ -> String? in
                return self?.profileModel?.name
            }
    }
    
    private let userTapGestureRecognizer = UITapGestureRecognizer()
    private let gymTapGestureRecognizer = UITapGestureRecognizer()

    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = FeedConsts.Profile.Size.profileImageCornerRadius
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
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
        view.addGestureRecognizer(userTapGestureRecognizer)
        return view
    }()
    
    private lazy var tagsView: UIView = {
        let view = UIView()
        [gymTag, levelTag, holdTag]
            .forEach {
                view.addSubview($0)
            }
        view.addGestureRecognizer(gymTapGestureRecognizer)
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
    
    private lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(hex: "000000", alpha: 0.0).cgColor,
            UIColor(hex: "000000", alpha: 0.8).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        return gradientLayer
    }()
    
    init() {
        super.init(frame: .zero)
        self.layer.insertSublayer(gradientLayer, at: 0)
        setLayout()
    }
    
    func resetToDefaultState() {
        profileImageView.image = nil
        nameLabel.text = nil
        heightArmReachLabel.text = nil
        hideButton.isSelected = false
        gymTag.text = nil
        levelTag.rightImage = nil
        holdTag.rightImage = nil
        captionLabel.text = nil
        hideButton.isSelected = false
        captionSCV.isScrollEnabled = false
        disposeBag = DisposeBag()
    }
    
    func configure(with data: PostProfileModel) {
        profileModel = data
    }
    
    func updateHoldLevel(hold: UIImage, level: UIImage) {
        levelTag.rightImage = level
        holdTag.rightImage = hold
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.bounds.height > self.gradientLayer.frame.height {
            self.gradientLayer.frame = self.bounds
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                self.gradientLayer.frame = self.bounds
            })
        }
    }

    @objc private func captionSCVTapped() {
        if captionLabel.calculateNumberOfLines() > 2 {
            showFullCaption()
        }
    }
    
    private func setData() {
        guard let profileModel else { return }
        setProfileImageView(urlString: profileModel.profileImage)
        nameLabel.text = profileModel.name
        gymTag.text = profileModel.gymName
        heightArmReachLabel.text = profileModel.heightArmReach
        levelTag.rightImage = profileModel.level
        holdTag.rightImage = profileModel.hold
        captionLabel.text = profileModel.caption
    }
    
    private func setProfileImageView(urlString: String?) {
        if let urlString, let url = URL(string: urlString) {
            profileImageView.kf.setImage(with: url)
        } else {
            profileImageView.image = UIImage.defaultAvatarProfile
        }
    }
    
    private func showFullCaption() {
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
        profileStackView.arrangedSubviews.enumerated().forEach { index, view in
            if index != 0 {
                view.isHidden = self.hideButton.isSelected
            }
        }
        dataCheck()
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            self.profileStackView.layer.layoutIfNeeded()
        }
    }
    
    private func dataCheck() {
        if profileModel?.caption?.isEmpty ?? true {
            profileStackView.arrangedSubviews[2].isHidden = true
        } else {
            profileStackView.arrangedSubviews[2].isHidden = hideButton.isSelected
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
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().inset(FeedConsts.Profile.Size.captionTrailing)
            $0.height.equalTo(FeedConsts.Profile.Size.captionShortHeight)
        }
        captionLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
    }
}
