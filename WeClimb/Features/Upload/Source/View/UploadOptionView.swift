//
//  UploadOptionView.swift
//  WeClimb
//
//  Created by 강유정 on 2/3/25.
//

import UIKit

import SnapKit
import RxSwift

class UploadOptionView : UIView {
    
    var didTapBackButton: (() -> Void)?
    var didTapNextButton: (() -> Void)?
    
    private let disposeBag = DisposeBag()
    
    var gradeOptionLabel: UILabel = {
        let label = UILabel()
        label.text = "레벨"
        label.font = .customFont(style: .label1Medium)
        label.textColor = .white
        return label
    }()
    
    let gradeSelectedButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "선택해주세요"
        config.image = UIImage.chevronRightIcon.resize(targetSize: CGSize(width: 20, height: 20))?
            .withTintColor(UIColor.labelAssistive, renderingMode: .alwaysOriginal)
        config.baseForegroundColor = .labelAssistive
        config.titleAlignment = .leading
        config.imagePlacement = .trailing
        config.imagePadding = 4
        config.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        var titleAttributes = AttributedString("선택해주세요")
           titleAttributes.font = UIFont.customFont(style: .label2Regular)
           
           config.attributedTitle = titleAttributes
        
        let button = UIButton(configuration: config)
        button.tintColor = .labelAssistive
        
        return button
    }()
    
    var holdOptionLabel: UILabel = {
        let label = UILabel()
        label.text = "홀드"
        label.font = .customFont(style: .label1Medium)
        label.textColor = .white
        return label
    }()
    
    let holdSelectedButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "선택해주세요"
        config.image = UIImage.chevronRightIcon.resize(targetSize: CGSize(width: 20, height: 20))?
            .withTintColor(UIColor.labelAssistive, renderingMode: .alwaysOriginal)
        config.baseForegroundColor = .labelAssistive
        config.titleAlignment = .leading
        config.imagePlacement = .trailing
        config.imagePadding = 4
        config.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        var titleAttributes = AttributedString("선택해주세요")
           titleAttributes.font = UIFont.customFont(style: .label2Regular)
           
           config.attributedTitle = titleAttributes
        
        let button = UIButton(configuration: config)
        button.tintColor = .labelAssistive
        
        
        return button
    }()
    
    private let topSeparatorLine: UILabel = {
        let label = UILabel()
        label.backgroundColor = .lineOpacityNormal
        return label
    }()
    
    private let bottomSeparatorLine: UILabel = {
        let label = UILabel()
        label.backgroundColor = .lineOpacityNormal
        return label
    }()
    
    private let backButton: UIButton = {
        let button = WeClimbButton(style: .leftIconRound)
        button.setTitle("이전", for: .normal)
        button.titleLabel?.font = UIFont.customFont(style: .caption1Medium)
        button.setTitleColor(.labelAssistive, for: .normal)
        
        let arrowLeftIcon = UIImage(named: "arrowLeftIcon")?.withRenderingMode(.alwaysTemplate)
        button.leftIcon = arrowLeftIcon
        button.leftIconTintColor = .labelAssistive
        
        button.backgroundColor = UIColor(hex: "313235") // FillSolidDarkLight
        
        return button
    }()

    private let nextButton: UIButton = {
        let button = WeClimbButton(style: .rightIconRound)
        button.setTitle("다음", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.customFont(style: .caption1Medium)
        
        button.rightIcon = UIImage(named: "arrowRightIcon")?.withRenderingMode(.alwaysTemplate)
        button.leftIconTintColor = .black
        
        button.backgroundColor = UIColor.white
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        
        setLayout()
        applyCornerRadius()
        bindButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 57)
    }
    
    private func applyCornerRadius() {
        layer.cornerRadius = 20
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        clipsToBounds = true
    }
    
    private func bindButton() {
        backButton.rx.tap
            .bind { [weak self] in
                self?.didTapBackButton?()
            }
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind { [weak self] in
                self?.didTapNextButton?()
            }
            .disposed(by: disposeBag)
    }

    private func setLayout() {
        self.backgroundColor = UIColor.fillSolidDarkStrong
        
        [gradeOptionLabel, gradeSelectedButton, topSeparatorLine, holdOptionLabel, holdSelectedButton, bottomSeparatorLine, backButton, nextButton]
            .forEach { self.addSubview($0) }
     
        gradeOptionLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalToSuperview()
            $0.height.equalTo(56)
        }
        
        gradeSelectedButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalTo(gradeOptionLabel)
        }
        
        topSeparatorLine.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(gradeOptionLabel.snp.bottom)
        }
        
        holdOptionLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalTo(topSeparatorLine.snp.bottom)
            $0.height.equalTo(56)
        }
        
        holdSelectedButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalTo(holdOptionLabel)
        }
        
        bottomSeparatorLine.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(holdOptionLabel.snp.bottom)
        }
        
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalTo(bottomSeparatorLine.snp.bottom).offset(10)
            $0.height.equalTo(30)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        nextButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.top.equalTo(bottomSeparatorLine.snp.bottom).offset(10)
            $0.height.equalTo(30)
            $0.bottom.equalToSuperview().offset(-10)
        }
    }
}
