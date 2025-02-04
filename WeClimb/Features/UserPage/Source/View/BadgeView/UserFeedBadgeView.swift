//
//  UserFeedBadgeView.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//

import UIKit

import Kingfisher
import RxCocoa
import RxSwift
import SnapKit

struct FeedBageModel {
    let gymName: String?
    let hold: UIImage?
    let holdValue: String?
    let gymThmbnail: UIImage?
}

class UserFeedBadgeView: UIView {
    private var disposeBag = DisposeBag()
    
    private var feedBageModel: FeedBageModel? {
        didSet {
            setData()
        }
    }
    
    private lazy var badgeView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = BadgeConst.CornerRadius.badgeViewCornerRadius
        view.backgroundColor = BadgeConst.Color.feedBackgroundColor
        [
            nameBadge,
            badgeStackView,
            gymThmbnail,
        ].forEach {
            view.addSubview($0)
        }
        return view
    }()
    
    private let nameBadge: TableFeedGymNameBadgeView = {
        let name = TableFeedGymNameBadgeView()
        name.gymNameText = "위클클라이밍"
        return name
    }()
    
    private let valueBadge: TableFeedValueBadgeView = {
        let value = TableFeedValueBadgeView()
        value.leftImage = BadgeConst.Image.locaction
        return value
    }()
    
    private let badgeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        return stackView
    }()
    
    // 뱃지 뷰 들어가야함 (색상)
    
    private let gymThmbnail: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    
    private func setData() {
        guard let model = feedBageModel else { return }
        nameBadge.gymNameText = model.gymName
        valueBadge.leftImage = model.hold
        valueBadge.text = model.holdValue
    }
    
    func resetToDefalueState() {
        nameBadge.gymNameText = nil
        valueBadge.fontColor = nil
        valueBadge.leftImage = nil
        valueBadge.text = nil
        gymThmbnail.image = nil
        disposeBag = DisposeBag()
    }
    
    func configure(with data: FeedBageModel) {
        feedBageModel = data
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setGymThmbnail(urlString: String?) {
        if let urlString, let url = URL(string: urlString) {
            gymThmbnail.kf.setImage(with: url)
        } else {
            gymThmbnail.image = UIImage.defaultAvatarProfile
        }
    }
    
    private func setLayout() {
        setBadgeMainLayout()
        setBadgeValueLayout()
    }
    
    private func setBadgeMainLayout() {
        [
            badgeView,
        ].forEach { self.addSubview($0) }
        
        badgeView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(84)
        }
    }
    
    private func setBadgeValueLayout() {
        [
            valueBadge,
        ].forEach { badgeStackView.addArrangedSubview($0) }
        
        badgeStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
        }
        
        gymThmbnail.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
        }
        
        nameBadge.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalToSuperview().offset(12)
            $0.height.equalTo(26)
        }
        
        valueBadge.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.bottom.equalToSuperview().offset(12)
            $0.height.equalTo(26)
        }
    }
}
