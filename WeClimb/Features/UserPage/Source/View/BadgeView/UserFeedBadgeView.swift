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
    let hold: [String]?
    let userFeedThmbnail: String?
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
            badgeValueView,
            userFeedThmbnail,
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
//        value.clipsToBounds = true
//        value.layer.masksToBounds = true
        value.layer.cornerRadius = 8
        return value
    }()
    
    private let badgeValueView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let badgeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    // 뱃지 뷰 들어가야함 (색상)
    
    private let userFeedThmbnail: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.layer.cornerRadius = 6
        return img
    }()
    
    private func setData() {
        guard let model = feedBageModel else { return }
        
        nameBadge.gymNameText = model.gymName
        
        var holdCountDict: [String: Int] = [:]
        
        model.hold?.forEach { holdColor in
            holdCountDict[holdColor, default: 0] += 1
        }
        
        badgeStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        holdCountDict.forEach { (color, count) in
            let badgeView = TableFeedValueBadgeView()
            badgeView.colorName = color
            badgeView.text = "\(count)"
            badgeStackView.addArrangedSubview(badgeView)
        }
        
        setGymThmbnail(urlString: model.userFeedThmbnail)
    }
    
    func resetToDefalueState() {
        nameBadge.gymNameText = nil
        valueBadge.colorName = nil
        valueBadge.text = nil
        userFeedThmbnail.image = nil
        disposeBag = DisposeBag()
    }
    
    func configure(with data: FeedBageModel) {
        print("🛠️ configure 호출됨: \(data)")
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
        print("🖼️ setGymThmbnail 호출됨, urlString: \(urlString ?? "nil")")
        if let urlString, let url = URL(string: urlString) {
            userFeedThmbnail.kf.setImage(with: url)
        } else {
            userFeedThmbnail.image = UIImage.appleIcon
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
        
        badgeValueView.addSubview(badgeStackView)
        
        badgeStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(4)
        }
        
        badgeValueView.snp.makeConstraints {
            $0.top.equalTo(nameBadge.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(12)
            $0.trailing.lessThanOrEqualToSuperview().inset(12)
        }
        
        userFeedThmbnail.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(12)
            $0.width.height.equalTo(60)
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
