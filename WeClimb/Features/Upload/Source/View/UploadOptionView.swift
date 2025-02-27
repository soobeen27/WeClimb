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
    
    var selectedLevelButton: (() -> Void)?
    var selectedHoldButton: (() -> Void)?
    
    private let disposeBag = DisposeBag()
    
    var levelOptionImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UploadMediaConst.UploadOptionView.Image.levelOption
        imageView.isHidden = true
        return imageView
    }()
    
    var levelOptionLabel: UILabel = {
        let label = UILabel()
        label.text = UploadMediaConst.UploadOptionView.Text.levelLabel
        label.font = UploadMediaConst.UploadOptionView.Font.levelLabel
        label.textColor = UploadMediaConst.UploadOptionView.Color.labelText
        return label
    }()
    
    let levelSelectedButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = UploadMediaConst.UploadOptionView.Text.selectPlaceholder
        config.image = UploadMediaConst.UploadOptionView.Image.chevronRight
        config.baseForegroundColor = UploadMediaConst.UploadOptionView.Color.btnText
        config.titleAlignment = .leading
        config.imagePlacement = .trailing
        config.imagePadding = UploadMediaConst.UploadOptionView.Layout.btnImagePadding
        config.contentInsets = UploadMediaConst.UploadOptionView.Layout.btnContentInsets
        
        var titleAttributes = AttributedString(UploadMediaConst.UploadOptionView.Text.selectPlaceholder)
        titleAttributes.font = UploadMediaConst.UploadOptionView.Font.selectedButton
        
        config.attributedTitle = titleAttributes
        
        let button = UIButton(configuration: config)
        button.tintColor = UploadMediaConst.UploadOptionView.Color.btnTint
        return button
    }()
    
    var holdOptionImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UploadMediaConst.UploadOptionView.Image.holdOption
        imageView.isHidden = true
        return imageView
    }()
    
    var holdOptionLabel: UILabel = {
        let label = UILabel()
        label.text = UploadMediaConst.UploadOptionView.Text.holdLabel
        label.font = UploadMediaConst.UploadOptionView.Font.holdLabel
        label.textColor = UploadMediaConst.UploadOptionView.Color.labelText
        return label
    }()
    
    let holdSelectedButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = UploadMediaConst.UploadOptionView.Text.selectPlaceholder
        config.image = UploadMediaConst.UploadOptionView.Image.chevronRight
        config.baseForegroundColor = UploadMediaConst.UploadOptionView.Color.btnText
        config.titleAlignment = .leading
        config.imagePlacement = .trailing
        config.imagePadding = UploadMediaConst.UploadOptionView.Layout.btnImagePadding
        config.contentInsets = UploadMediaConst.UploadOptionView.Layout.btnContentInsets
        
        var titleAttributes = AttributedString(UploadMediaConst.UploadOptionView.Text.selectPlaceholder)
        titleAttributes.font = UploadMediaConst.UploadOptionView.Font.selectedButton
        
        config.attributedTitle = titleAttributes
        
        let button = UIButton(configuration: config)
        button.tintColor = UploadMediaConst.UploadOptionView.Color.btnTint
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
        button.setTitle(UploadMediaConst.UploadOptionView.Text.backButtonTitle, for: .normal)
        button.titleLabel?.font = UploadMediaConst.UploadOptionView.Font.button
        button.setTitleColor(UploadMediaConst.UploadOptionView.Color.backButtonText, for: .normal)
        
        button.leftIcon = UploadMediaConst.UploadOptionView.Image.backButtonIcon
        button.leftIconTintColor = UploadMediaConst.UploadOptionView.Color.backButtonText
        
        button.backgroundColor = UploadMediaConst.UploadOptionView.Color.backButtonBackground
        
        return button
    }()

    private let nextButton: UIButton = {
        let button = WeClimbButton(style: .rightIconRound)
        button.setTitle(UploadMediaConst.UploadOptionView.Text.nextButtonTitle, for: .normal)
        button.setTitleColor(UploadMediaConst.UploadOptionView.Color.nextButtonText, for: .normal)
        button.titleLabel?.font = UploadMediaConst.UploadOptionView.Font.button
        
        button.rightIcon = UploadMediaConst.UploadOptionView.Image.nextButtonIcon
        button.leftIconTintColor = UploadMediaConst.UploadOptionView.Color.nextButtonText
        
        button.backgroundColor = UploadMediaConst.UploadOptionView.Color.nextButtonBackground
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
        return UploadMediaConst.UploadOptionView.Size.viewIntrinsicContent
    }

    private func applyCornerRadius() {
        layer.cornerRadius = UploadMediaConst.UploadOptionView.Size.viewCornerRadius
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        clipsToBounds = true
    }

    
    func updateOptionView(grade: String?, hold: String?) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            let customFont = UploadMediaConst.UploadOptionView.Font.selectedOption
            
            if let grade = grade {
                let koreanGrade = grade.isEmpty ? UploadMediaConst.UploadOptionView.Text.defaultSelection : LHColors.fromEng(grade).toKorean()
                
                var config = self.levelSelectedButton.configuration
                let attributedTitle = NSAttributedString(
                    string: koreanGrade,
                    attributes: [.font: customFont]
                )
                config?.attributedTitle = AttributedString(attributedTitle)
                self.levelSelectedButton.configuration = config
                
                let levelColor = LHColors.fromKoreanFull(koreanGrade).toImage()
                self.levelOptionImage.image = levelColor
                self.levelOptionImage.isHidden = (levelColor == UploadMediaConst.UploadOptionView.Image.defaultGradeColor)
            }
            
            if let hold = hold {
                let holdColorName = hold.replacingOccurrences(of: UploadMediaConst.UploadOptionView.Text.holdSuffixToRemove, with: "")
                let koreanHold = hold.isEmpty ? UploadMediaConst.UploadOptionView.Text.defaultSelection : LHColors.fromEng(holdColorName).toKorean()
                
                var config = self.holdSelectedButton.configuration
                let attributedTitle = NSAttributedString(
                    string: koreanHold,
                    attributes: [.font: customFont]
                )
                config?.attributedTitle = AttributedString(attributedTitle)
                self.holdSelectedButton.configuration = config
                
                let holdColor = LHColors.fromKoreanFull(koreanHold).toImage()
                self.holdOptionImage.image = holdColor
                self.holdOptionImage.isHidden = (holdColor == UploadMediaConst.UploadOptionView.Image.defaultHoldColor)
            }
        }
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
        
        levelSelectedButton.rx.tap
            .bind { [weak self] in
                self?.selectedLevelButton?()
            }
            .disposed(by: disposeBag)
        
        holdSelectedButton.rx.tap
            .bind { [weak self] in
                self?.selectedHoldButton?()
            }
            .disposed(by: disposeBag)
    }
    
    private func setLayout() {
        self.backgroundColor = UploadMediaConst.UploadOptionView.Color.viewBackground
        
        [levelOptionLabel, levelSelectedButton, levelOptionImage, topSeparatorLine,
         holdOptionLabel, holdSelectedButton, holdOptionImage, bottomSeparatorLine,
         backButton, nextButton].forEach { self.addSubview($0) }
        
        levelOptionLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(UploadMediaConst.UploadOptionView.Layout.defultOffset)
            $0.top.equalToSuperview()
            $0.height.equalTo(UploadMediaConst.UploadOptionView.Layout.optionLabelHeight)
        }
        
        levelOptionImage.snp.makeConstraints {
            $0.trailing.equalTo(levelSelectedButton.snp.leading).offset(UploadMediaConst.UploadOptionView.Layout.optionImageSpacing)
            $0.centerY.equalTo(levelOptionLabel)
        }
        
        levelSelectedButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-UploadMediaConst.UploadOptionView.Layout.defultOffset)
            $0.centerY.equalTo(levelOptionLabel)
        }
        
        topSeparatorLine.snp.makeConstraints {
            $0.height.equalTo(UploadMediaConst.UploadOptionView.Layout.separatorHeight)
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(levelOptionLabel.snp.bottom)
        }
        
        holdOptionLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(UploadMediaConst.UploadOptionView.Layout.defultOffset)
            $0.top.equalTo(topSeparatorLine.snp.bottom)
            $0.height.equalTo(UploadMediaConst.UploadOptionView.Layout.optionLabelHeight)
        }
        
        holdSelectedButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-UploadMediaConst.UploadOptionView.Layout.defultOffset)
            $0.centerY.equalTo(holdOptionLabel)
        }
        
        holdOptionImage.snp.makeConstraints {
            $0.trailing.equalTo(holdSelectedButton.snp.leading).offset(UploadMediaConst.UploadOptionView.Layout.optionImageSpacing)
            $0.centerY.equalTo(holdOptionLabel)
        }
        
        bottomSeparatorLine.snp.makeConstraints {
            $0.height.equalTo(UploadMediaConst.UploadOptionView.Layout.separatorHeight)
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(holdOptionLabel.snp.bottom)
        }
        
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(UploadMediaConst.UploadOptionView.Layout.defultOffset)
            $0.top.equalTo(bottomSeparatorLine.snp.bottom).offset(UploadMediaConst.UploadOptionView.Layout.buttonTopOffset)
            $0.height.equalTo(UploadMediaConst.UploadOptionView.Layout.buttonHeight)
            $0.bottom.equalToSuperview().offset(UploadMediaConst.UploadOptionView.Layout.buttonBottomOffset)
        }
        
        nextButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-UploadMediaConst.UploadOptionView.Layout.defultOffset)
            $0.top.equalTo(bottomSeparatorLine.snp.bottom).offset(UploadMediaConst.UploadOptionView.Layout.buttonTopOffset)
            $0.height.equalTo(UploadMediaConst.UploadOptionView.Layout.buttonHeight)
            $0.bottom.equalToSuperview().offset(UploadMediaConst.UploadOptionView.Layout.buttonBottomOffset)
        }
    }
}
