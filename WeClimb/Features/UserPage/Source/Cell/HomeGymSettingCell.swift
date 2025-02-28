//
//  HomeGymSettingCell.swift
//  WeClimb
//
//  Created by 윤대성 on 2/23/25.
//

import UIKit

import Kingfisher
import RxCocoa
import RxSwift
import SnapKit

class HomeGymSettingCell: UITableViewCell {
    static let identifier = "HomeGymSettingCell"
    
    var disposeBag = DisposeBag()
    private let selectRelay = PublishRelay<Void>()
    
    private let gymImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = SearchConst.Cell.Color.gymImageDefaultBackground
        imageView.layer.cornerRadius = SearchConst.Cell.Shape.cellImageCornerRadius
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let gymLocationLabel: UILabel = {
        let label = UILabel()
        label.font = SearchConst.Cell.Font.gymLocationFont
        label.textColor = SearchConst.Cell.Color.gymLocationText
        return label
    }()
    
    private let gymNameLabel: UILabel = {
        let label = UILabel()
        label.font = SearchConst.Cell.Font.gymNameFont
        label.textColor = SearchConst.Cell.Color.gymNameText
        return label
    }()
    
    private let homeGymMarkImage: UIImageView = {
        let img = UIImageView()
        img.image = HomeGymSettingConst.Image.nomalHomeGymMark
        img.isUserInteractionEnabled = true
        img.clipsToBounds = true
        return img
    }()
    
    var onMarkTapped: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
        setupTapGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        [
            gymImageView,
            gymLocationLabel,
            gymNameLabel,
            homeGymMarkImage,
        ].forEach { self.addSubview($0) }
        
        gymImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(SearchConst.Cell.Spacing.gymImageleftSpacing)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(SearchConst.Cell.Size.gymImageSize)
        }
        
        gymLocationLabel.snp.makeConstraints {
            $0.leading.equalTo(gymImageView.snp.trailing).offset(SearchConst.Cell.Spacing.gymLocationleftSpacing)
            $0.top.equalTo(gymImageView.snp.top)
        }
        
        gymNameLabel.snp.makeConstraints {
            $0.leading.equalTo(gymLocationLabel)
            $0.top.equalTo(gymLocationLabel.snp.bottom).offset(SearchConst.Cell.Spacing.gymNameTopSpacing)
        }
        
        homeGymMarkImage.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
        }
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer()
        homeGymMarkImage.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event
            .map { _ in }
            .bind(to: selectRelay)
            .disposed(by: disposeBag)
    }
    
    func selectionObservable() -> Observable<Void> {
        return selectRelay.asObservable()
    }
    
    func configure(with gym: Gym, isSelected: Observable<Bool>) {
        gymNameLabel.text = gym.gymName
        
        isSelected
            .subscribe(onNext: { [weak self] selected in
                self?.homeGymMarkImage.image = selected ? HomeGymSettingConst.Image.clickHomeGymMark : HomeGymSettingConst.Image.nomalHomeGymMark
            })
            .disposed(by: disposeBag)
    }
    
    func updateGymImage(with url: URL?) {
        if let url = url {
            gymImageView.kf.setImage(with: url)
        } else {
            gymImageView.image = UIImage(named: "defaultGymImage")
        }
    }
}
