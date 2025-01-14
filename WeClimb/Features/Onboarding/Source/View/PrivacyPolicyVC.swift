//
//  PrivacyPolicyVC.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

class PrivacyPolicyVC: UIViewController {
    var coordinator: PrivacyPolicyCoordinator?
    private let viewModel: PrivacyPolicyVM
    private let disposeBag = DisposeBag()
    
    private let toggleAllTermsRelay = PublishRelay<Void>()
    private let toggleRequiredTermRelay = PublishRelay<Int>()
    private let toggleOptionalTermRelay = PublishRelay<Int>()
    private let confirmButtonTapRelay = PublishRelay<Void>()
    
    private lazy var requiredCheckBoxes: [UIButton] = [
        isAppTermsAgreedCheckBox,
        isPrivacyTermsAgreedCheckBox
    ]
    
    private lazy var optionalCheckBoxes: [UIButton] = [
        isSnsConsentGivenCheckBox
    ]
    
    var onTermsAgreed: (() -> Void)?
    
    init(coordinator: PrivacyPolicyCoordinator? = nil, viewModel: PrivacyPolicyVM) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let logoImage: UIImageView = {
        var image = UIImageView()
        image.image = OnboardingConst.weclimbLogo
        return image
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = OnboardingConst.PrivacyPolicy.Text.titleLabel
        label.font = OnboardingConst.PrivacyPolicy.Font.titleFont
        label.numberOfLines = OnboardingConst.PrivacyPolicy.Text.titleNumberofLine
        label.textColor = OnboardingConst.PrivacyPolicy.Color.titleTextColor
        return label
    }()
    
    private let pageController: UILabel = {
        let label = UILabel()
        label.text = OnboardingConst.PrivacyPolicy.Text.pageControl
        label.textColor = OnboardingConst.PrivacyPolicy.Color.pageControlTextColor
        label.font = OnboardingConst.PrivacyPolicy.Font.valueFont
        label.layer.cornerRadius = OnboardingConst.PrivacyPolicy.CornerRadius.pageControl
        label.contentMode = .center
        return label
    }()
    
    private let allAgreeCheckBox: UIButton = {
        let button = UIButton()
        button.setImage(OnboardingConst.PrivacyPolicy.Image.clickCheckBox, for: .selected)
        button.setImage(OnboardingConst.PrivacyPolicy.Image.clearCheckBox, for: .normal)
        button.setTitle(OnboardingConst.PrivacyPolicy.Text.isAllAgree, for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleLabel?.font = OnboardingConst.PrivacyPolicy.Font.titleCheckBoxFont
        button.setTitleColor(OnboardingConst.PrivacyPolicy.Color.checkBoxFontColor, for: .normal)
        return button
    }()
    
    private let isAppTermsAgreedCheckBox: UIButton = {
        let button = UIButton()
        button.setImage(OnboardingConst.PrivacyPolicy.Image.clickCheckBox, for: .selected)
        button.setImage(OnboardingConst.PrivacyPolicy.Image.clearCheckBox, for: .normal)
        button.setTitle(OnboardingConst.PrivacyPolicy.Text.isAppTermsAgreed, for: .normal)
        button.contentHorizontalAlignment = .left
        button.setTitleColor(OnboardingConst.PrivacyPolicy.Color.checkBoxFontColor, for: .normal)
        button.titleLabel?.font = OnboardingConst.PrivacyPolicy.Font.valueCheckBoxFont
        return button
    }()
    
    private let isPrivacyTermsAgreedCheckBox: UIButton = {
        let button = UIButton()
        button.setImage(OnboardingConst.PrivacyPolicy.Image.clickCheckBox, for: .selected)
        button.setImage(OnboardingConst.PrivacyPolicy.Image.clearCheckBox, for: .normal)
        button.setTitle(OnboardingConst.PrivacyPolicy.Text.isPrivacyTermsAgreed, for: .normal)
        button.contentHorizontalAlignment = .left
        button.setTitleColor(OnboardingConst.PrivacyPolicy.Color.checkBoxFontColor, for: .normal)
        button.titleLabel?.font = OnboardingConst.PrivacyPolicy.Font.valueCheckBoxFont
        return button
    }()
    
    private let isSnsConsentGivenCheckBox: UIButton = {
        let button = UIButton()
        button.setImage(OnboardingConst.PrivacyPolicy.Image.clickCheckBox, for: .selected)
        button.setImage(OnboardingConst.PrivacyPolicy.Image.clearCheckBox, for: .normal)
        button.setTitle(OnboardingConst.PrivacyPolicy.Text.isSNSConsenctGivenCheck, for: .normal)
        button.contentHorizontalAlignment = .left
        button.setTitleColor(OnboardingConst.PrivacyPolicy.Color.checkBoxFontColor, for: .normal)
        button.titleLabel?.font = OnboardingConst.PrivacyPolicy.Font.valueCheckBoxFont
        return button
    }()
    
    private let checkBoxBackGroundView: UIView = {
        let view = UIView()
        view.backgroundColor = OnboardingConst.PrivacyPolicy.Color.containerBoxColor
        view.layer.cornerRadius = OnboardingConst.PrivacyPolicy.Style.containerCornerRadius
        return view
    }()
    
    private let AppTermsAgreedLinkButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = OnboardingConst.PrivacyPolicy.Font.valueFont
        
        let buttonTitle = OnboardingConst.PrivacyPolicy.Text.AppTermAgreedButtonText
        let attributedString = NSMutableAttributedString(string: buttonTitle)
        
        attributedString.addAttributes([
            .foregroundColor: UIColor.systemGray,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ], range: NSRange(location: OnboardingConst.PrivacyPolicy.Size.labelstartLocation, length: buttonTitle.count))
        
        button.setAttributedTitle(attributedString, for: .normal)
        
        return button
    }()

    private let PrivacyTermsAgreedLinkButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = OnboardingConst.PrivacyPolicy.Font.valueFont
        
        let buttonTitle = OnboardingConst.PrivacyPolicy.Text.PrivacyTermsAgreedLinkButton
        let attributedString = NSMutableAttributedString(string: buttonTitle)
        
        attributedString.addAttributes([
            .foregroundColor: UIColor.systemGray,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ], range: NSRange(location: OnboardingConst.PrivacyPolicy.Size.labelstartLocation, length: buttonTitle.count))
        
        button.setAttributedTitle(attributedString, for: .normal)
        
        return button
    }()
    
    private let confirmButton: WeClimbButton = {
        let button = WeClimbButton(style: .defaultRectangle)
        button.setTitle(OnboardingConst.PrivacyPolicy.Text.nextPage, for: .normal)
        button.backgroundColor = OnboardingConst.PrivacyPolicy.Color.confirmActivationColor
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = OnboardingConst.PrivacyPolicy.CornerRadius.confirmButton
        button.isEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        checkBoxBind()
        setupButtonActions()
        linkButtonTapBind()
    }
    
    private func setLayout() {
        view.backgroundColor = UIColor.white
        
        [
            logoImage,
            titleLabel,
            pageController,
            allAgreeCheckBox,
            checkBoxBackGroundView,
            AppTermsAgreedLinkButton,
            PrivacyTermsAgreedLinkButton,
            confirmButton,
        ].forEach { view.addSubview($0) }
        
        [
            isAppTermsAgreedCheckBox,
            isPrivacyTermsAgreedCheckBox,
            isSnsConsentGivenCheckBox,
        ].forEach { checkBoxBackGroundView.addSubview($0) }
        
        pageController.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-OnboardingConst.PrivacyPolicy.Spacing.horizontalPadding)
            $0.height.width.equalTo(OnboardingConst.PrivacyPolicy.Size.pageControllerSize)
        }
        
        logoImage.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(OnboardingConst.PrivacyPolicy.Spacing.logoTopOffset)
            $0.leading.equalToSuperview().offset(OnboardingConst.PrivacyPolicy.Spacing.horizontalPadding)
            $0.height.width.equalTo(OnboardingConst.PrivacyPolicy.Size.logoSize)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(logoImage.snp.bottom).offset(OnboardingConst.PrivacyPolicy.Spacing.titleLabelTopOffset)
            $0.leading.equalToSuperview().offset(OnboardingConst.PrivacyPolicy.Spacing.horizontalPadding)
            $0.trailing.equalToSuperview().offset(-OnboardingConst.PrivacyPolicy.Spacing.horizontalPadding)
        }
        
        allAgreeCheckBox.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(OnboardingConst.PrivacyPolicy.Spacing.allAgreeCheckBoxTopOffset)
            $0.leading.equalToSuperview().offset(OnboardingConst.PrivacyPolicy.Spacing.horizontalPadding)
            $0.trailing.equalToSuperview().offset(-OnboardingConst.PrivacyPolicy.Spacing.horizontalPadding)
            $0.height.width.equalTo(OnboardingConst.PrivacyPolicy.Size.allAgreeCheckBoxHeight)
        }
        
        checkBoxBackGroundView.snp.makeConstraints {
            $0.top.equalTo(allAgreeCheckBox.snp.bottom)
            $0.leading.equalToSuperview().offset(OnboardingConst.PrivacyPolicy.Spacing.horizontalPadding)
            $0.trailing.equalToSuperview().offset(-OnboardingConst.PrivacyPolicy.Spacing.horizontalPadding)
            $0.height.width.equalTo(OnboardingConst.PrivacyPolicy.Size.checkBoxBackGroundSize)
        }
        
        isAppTermsAgreedCheckBox.snp.makeConstraints {
            $0.top.equalToSuperview().offset(OnboardingConst.PrivacyPolicy.Spacing.titleLabelTopOffset)
            $0.height.equalTo(OnboardingConst.PrivacyPolicy.Size.checkBoxHeight)
            $0.leading.equalToSuperview().offset(OnboardingConst.PrivacyPolicy.Spacing.horizontalPadding)
            $0.trailing.equalToSuperview().offset(-OnboardingConst.PrivacyPolicy.Spacing.horizontalPadding)
        }
        
        isPrivacyTermsAgreedCheckBox.snp.makeConstraints {
            $0.top.equalTo(isAppTermsAgreedCheckBox.snp.bottom).offset(OnboardingConst.PrivacyPolicy.Spacing.titleLabelTopOffset)
            $0.height.equalTo(OnboardingConst.PrivacyPolicy.Size.checkBoxHeight)
            $0.leading.equalToSuperview().offset(OnboardingConst.PrivacyPolicy.Spacing.privacyPolicyLabelLeadingOffset)
            $0.trailing.equalToSuperview().offset(-OnboardingConst.PrivacyPolicy.Spacing.horizontalPadding)
        }
        
        isSnsConsentGivenCheckBox.snp.makeConstraints {
            $0.top.equalTo(isPrivacyTermsAgreedCheckBox.snp.bottom).offset(OnboardingConst.PrivacyPolicy.Spacing.titleLabelTopOffset)
            $0.height.equalTo(OnboardingConst.PrivacyPolicy.Size.checkBoxHeight)
            $0.leading.equalToSuperview().offset(OnboardingConst.PrivacyPolicy.Spacing.horizontalPadding)
            $0.trailing.equalToSuperview().offset(-OnboardingConst.PrivacyPolicy.Spacing.horizontalPadding)
        }
        
        AppTermsAgreedLinkButton.snp.makeConstraints {
            $0.top.equalTo(checkBoxBackGroundView.snp.bottom).offset(OnboardingConst.PrivacyPolicy.Spacing.titleLabelTopOffset)
            $0.leading.equalToSuperview().offset(OnboardingConst.PrivacyPolicy.Spacing.horizontalPadding)
            $0.width.height.equalTo(OnboardingConst.PrivacyPolicy.Size.AppTermsLinkButtonSize)
        }
        PrivacyTermsAgreedLinkButton.snp.makeConstraints {
            $0.top.equalTo(AppTermsAgreedLinkButton .snp.bottom).offset(OnboardingConst.PrivacyPolicy.Spacing.linkButtonVerticalSpacing)
            $0.leading.equalToSuperview().offset(OnboardingConst.PrivacyPolicy.Spacing.horizontalPadding)
            $0.width.height.equalTo(OnboardingConst.PrivacyPolicy.Size.PrivacyTermsLinkButtonSize)
        }
        
        confirmButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-OnboardingConst.PrivacyPolicy.Spacing.confirmButtonBottomOffset)
            $0.leading.equalToSuperview().offset(OnboardingConst.PrivacyPolicy.Spacing.horizontalPadding)
            $0.trailing.equalToSuperview().offset(-OnboardingConst.PrivacyPolicy.Spacing.horizontalPadding)
            $0.height.equalTo(48)
        }
    }
    
    private func checkBoxBind() {
        let input = PrivacyPolicyImpl.Input(
            toggleAllTerms: toggleAllTermsRelay,
            toggleRequiredTerm: toggleRequiredTermRelay,
            toggleOptionalTerm: toggleOptionalTermRelay,
            confirmButtonTap: confirmButtonTapRelay
        )
        
        let output = viewModel.transform(input: input)
        
        output.allTermsAgreed
            .drive(onNext: { isAllAgreed in
                let imageName = isAllAgreed ? OnboardingConst.PrivacyPolicy.Image.clickCheckBox : OnboardingConst.PrivacyPolicy.Image.clearCheckBox
                self.allAgreeCheckBox.setImage(imageName, for: .normal)
            })
            .disposed(by: disposeBag)
        
        output.requiredTermsAgreed
            .drive(onNext: { states in
                for (index, state) in states.enumerated() {
                    let imageName = state ? OnboardingConst.PrivacyPolicy.Image.clickCheckBox : OnboardingConst.PrivacyPolicy.Image.clearCheckBox
                    self.requiredCheckBoxes[index].setImage(imageName, for: .normal)
                }
            })
            .disposed(by: disposeBag)
        
        output.optionalTermsAgreed
            .drive(onNext: { states in
                for (index, state) in states.enumerated() {
                    let imageName = state ? OnboardingConst.PrivacyPolicy.Image.clickCheckBox : OnboardingConst.PrivacyPolicy.Image.clearCheckBox
                    self.optionalCheckBoxes[index].setImage(imageName, for: .normal)
                }
            })
            .disposed(by: disposeBag)
        
        output.isConfirmButtonEnabled
            .drive(onNext: { [weak self] isEnabled in
                print("Confirm Button Enabled: \(isEnabled)")
                self?.confirmButton.isEnabled = isEnabled
                self?.confirmButton.backgroundColor = isEnabled ? OnboardingConst.PrivacyPolicy.Color.confirmDeactivationColor : OnboardingConst.PrivacyPolicy.Color.confirmActivationColor
            })
            .disposed(by: disposeBag)
    }
    
    private func setupButtonActions() {
        allAgreeCheckBox.rx.tap
            .bind(to: toggleAllTermsRelay)
            .disposed(by: disposeBag)
        
        requiredCheckBoxes.enumerated().forEach { index, button in
            button.rx.tap
                .map { index }
                .bind(to: toggleRequiredTermRelay)
                .disposed(by: disposeBag)
        }
        
        optionalCheckBoxes.enumerated().forEach { index, button in
            button.rx.tap
                .map { index }
                .bind(to: toggleOptionalTermRelay)
                .disposed(by: disposeBag)
        }
        
        confirmButton.rx.tap
                .subscribe(onNext: { [weak self] in
                    print("나간다")
                    self?.onTermsAgreed?()
                })
                .disposed(by: disposeBag)

    }
    
    private func linkButtonTapBind() {
        AppTermsAgreedLinkButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.showTermsPage(url: OnboardingConst.PrivacyPolicy.link.termslink)
            })
            .disposed(by: disposeBag)
        
        PrivacyTermsAgreedLinkButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.showTermsPage(url: OnboardingConst.PrivacyPolicy.link.privacyPolicylink)
            })
            .disposed(by: disposeBag)
    }
}
