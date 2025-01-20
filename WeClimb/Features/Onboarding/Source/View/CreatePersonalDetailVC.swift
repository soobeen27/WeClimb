//
//  CreatePersonalDetailVC.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

class CreatePersonalDetailVC: UIViewController {
    var coordinator: CreatePersonalDetailCoordinator?
    
    private let viewModel: CreatePersonalDetailVM
    private let disposeBag = DisposeBag()
    
    var onRegisterResult:(() -> Void)?
    
    init(coordinator: CreatePersonalDetailCoordinator? = nil, viewModel: CreatePersonalDetailVM) {
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
        label.text = OnboardingConst.PersonalDetail.Text.titleLabel
        label.font = OnboardingConst.PersonalDetail.Font.titleFont
        label.numberOfLines = OnboardingConst.PersonalDetail.Text.titleNumberofLine
        label.textColor = OnboardingConst.PersonalDetail.Color.titleTextColor
        return label
    }()
    
    private let pageController: UILabel = {
        let label = UILabel()
        label.text = OnboardingConst.PersonalDetail.Text.pageControl
        label.textColor = OnboardingConst.PersonalDetail.Color.pageControlTextColor
        label.font = OnboardingConst.PersonalDetail.Font.valueFont
        label.layer.cornerRadius = OnboardingConst.PersonalDetail.CornerRadius.pageControl
        label.contentMode = .center
        return label
    }()
    
    private let heightTitleLabel: UILabel = {
        let label = UILabel()
        label.text = OnboardingConst.PersonalDetail.Text.heightTitleText
        label.textColor = OnboardingConst.PersonalDetail.Color.titleTextColor
        label.font = OnboardingConst.PersonalDetail.Font.textFiledTitleLabelFont
        return label
    }()
    
    private let armrichTitleLabel: UILabel = {
        let label = UILabel()
        label.text = OnboardingConst.PersonalDetail.Text.armrichTitleText
        label.textColor = OnboardingConst.PersonalDetail.Color.titleTextColor
        label.font = OnboardingConst.PersonalDetail.Font.textFiledTitleLabelFont
        return label
    }()
    
    private let selectionLabel: UILabel = {
        let label = UILabel()
        label.text = OnboardingConst.PersonalDetail.Text.selectionLabel
        label.textColor = OnboardingConst.PersonalDetail.Color.subtitleTextColor
        label.font = OnboardingConst.PersonalDetail.Font.valueFont
        return label
    }()
    
    private let requiredLabel: UILabel = {
        let label = UILabel()
        label.text = OnboardingConst.PersonalDetail.Text.requiredText
        label.textColor = OnboardingConst.PersonalDetail.Color.subtitleTextColor
        label.font = OnboardingConst.PersonalDetail.Font.valueFont
        return label
    }()
    
    private let heightTitleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = OnboardingConst.PersonalDetail.Spacing.stackViewSpacing
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let armrichTitleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = OnboardingConst.PersonalDetail.Spacing.stackViewSpacing
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let heightTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = OnboardingConst.PersonalDetail.Text.heightPlaceholder
        textField.keyboardType = .numberPad
        
        textField.borderStyle = .roundedRect
        textField.font = OnboardingConst.PersonalDetail.Font.placeholderFont
        textField.textColor = OnboardingConst.PersonalDetail.Color.textFieldLabelColor
        
        textField.backgroundColor = OnboardingConst.PersonalDetail.Color.backgroundColor
        textField.layer.cornerRadius = OnboardingConst.PersonalDetail.CornerRadius.textFieldCornerRadius
        textField.layer.borderWidth = OnboardingConst.PersonalDetail.Size.textFieldBorderWidth
        textField.layer.borderColor = OnboardingConst.PersonalDetail.Color.boarderGray.cgColor
        
        textField.attributedPlaceholder = NSAttributedString(
            string: OnboardingConst.PersonalDetail.Text.heightPlaceholder,
            attributes: [
                .foregroundColor: OnboardingConst.PersonalDetail.Color.placeholderTextFieldColor
            ]
        )
        return textField
    }()
    
    private let armReachTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = OnboardingConst.PersonalDetail.Text.armrichPlaceholder
        textField.keyboardType = .numberPad
        
        textField.borderStyle = .roundedRect
        textField.font = OnboardingConst.PersonalDetail.Font.placeholderFont
        textField.textColor = OnboardingConst.PersonalDetail.Color.textFieldLabelColor
        
        textField.backgroundColor = OnboardingConst.PersonalDetail.Color.backgroundColor
        textField.layer.cornerRadius = OnboardingConst.PersonalDetail.CornerRadius.textFieldCornerRadius
        textField.layer.borderWidth = OnboardingConst.PersonalDetail.Size.textFieldBorderWidth
        textField.layer.borderColor = OnboardingConst.PersonalDetail.Color.boarderGray.cgColor
        
        textField.attributedPlaceholder = NSAttributedString(
            string: OnboardingConst.PersonalDetail.Text.armrichPlaceholder,
            attributes: [
                .foregroundColor: OnboardingConst.PersonalDetail.Color.placeholderTextFieldColor
            ]
        )
        return textField
    }()
    
    private let confirmButton: WeClimbButton = {
        let button = WeClimbButton(style: .defaultRectangle)
        button.setTitle(OnboardingConst.PersonalDetail.Text.nextPage, for: .normal)
        button.backgroundColor = OnboardingConst.PersonalDetail.Color.confirmActivationColor
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = OnboardingConst.PersonalDetail.CornerRadius.confirmButton
        button.isEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        viewModelBind()
        textFieldNumberFilter()
        setupDismissKeyboardGesture()
    }
    
    private func setLayout() {
        view.backgroundColor = OnboardingConst.CreateNickname.Color.backgroundColor
        [
            heightTitleLabel,
            requiredLabel,
        ].forEach { heightTitleStackView.addArrangedSubview($0) }
        
        [
            armrichTitleLabel,
            selectionLabel,
        ].forEach { armrichTitleStackView.addArrangedSubview($0) }
        
        [
            logoImage,
            titleLabel,
            pageController,
            heightTitleStackView,
            armrichTitleStackView,
            heightTextField,
            armReachTextField,
            confirmButton,
        ].forEach { view.addSubview($0) }
        
        pageController.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-OnboardingConst.PersonalDetail.Spacing.viewHorizontalMargin)
            $0.height.width.equalTo(OnboardingConst.PersonalDetail.Size.pageControlSize)
        }
        
        logoImage.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(OnboardingConst.PersonalDetail.Spacing.logoTopSpacing)
            $0.leading.equalToSuperview().offset(OnboardingConst.PersonalDetail.Spacing.viewHorizontalMargin)
            $0.height.width.equalTo(OnboardingConst.PersonalDetail.Size.logoSize)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(logoImage.snp.bottom).offset(OnboardingConst.PersonalDetail.Spacing.titleTopSpacing)
            $0.leading.equalToSuperview().offset(OnboardingConst.PersonalDetail.Spacing.viewHorizontalMargin)
            $0.trailing.equalToSuperview().offset(-OnboardingConst.PersonalDetail.Spacing.viewHorizontalMargin)
        }
        
        heightTitleStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(OnboardingConst.PersonalDetail.Spacing.titleStackViewTopSpacing)
            $0.leading.equalToSuperview().offset(OnboardingConst.PersonalDetail.Spacing.viewHorizontalMargin)
            $0.width.height.equalTo(OnboardingConst.PersonalDetail.Size.heightTitleStackViewSize)
        }
        
        heightTitleLabel.snp.makeConstraints {
            $0.width.height.equalTo(OnboardingConst.PersonalDetail.Size.heightTitleLabelSize)
        }
        
        requiredLabel.snp.makeConstraints {
            $0.width.height.equalTo(OnboardingConst.PersonalDetail.Size.requiredLabelSize)
        }
        
        heightTextField.snp.makeConstraints {
            $0.top.equalTo(heightTitleStackView.snp.bottom).offset(OnboardingConst.PersonalDetail.Spacing.textFieldTopSpacing)
            $0.leading.equalToSuperview().offset(OnboardingConst.PersonalDetail.Spacing.viewHorizontalMargin)
            $0.trailing.equalToSuperview().offset(-OnboardingConst.PersonalDetail.Spacing.viewHorizontalMargin)
            $0.height.equalTo(OnboardingConst.PersonalDetail.Size.heightTextFieldHeight)
        }
        
        armrichTitleStackView.snp.makeConstraints {
            $0.top.equalTo(heightTextField.snp.bottom).offset(OnboardingConst.PersonalDetail.Spacing.titleTopSpacing)
            $0.leading.equalToSuperview().offset(OnboardingConst.PersonalDetail.Spacing.viewHorizontalMargin)
            $0.width.height.equalTo(OnboardingConst.PersonalDetail.Size.armrichTitleStackViewSize)
        }
        
        armrichTitleLabel.snp.makeConstraints {
            $0.width.height.equalTo(OnboardingConst.PersonalDetail.Size.armrichTitleLabelSize)
        }
        
        selectionLabel.snp.makeConstraints {
            $0.width.height.equalTo(OnboardingConst.PersonalDetail.Size.selectionLabelSize)
        }
        
        armReachTextField.snp.makeConstraints {
            $0.top.equalTo(armrichTitleStackView.snp.bottom).offset(OnboardingConst.PersonalDetail.Spacing.textFieldTopSpacing)
            $0.leading.equalToSuperview().offset(OnboardingConst.PersonalDetail.Spacing.viewHorizontalMargin)
            $0.trailing.equalToSuperview().offset(-OnboardingConst.PersonalDetail.Spacing.viewHorizontalMargin)
            $0.height.equalTo(OnboardingConst.PersonalDetail.Size.armrichTextFieldHeight)
        }
        
        confirmButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-OnboardingConst.PersonalDetail.Spacing.confirmButtonBottomSpacing)
            $0.leading.equalToSuperview().offset(OnboardingConst.PersonalDetail.Spacing.viewHorizontalMargin)
            $0.trailing.equalToSuperview().offset(-OnboardingConst.PersonalDetail.Spacing.viewHorizontalMargin)
        }
    }
    
    private func viewModelBind() {
        let input = CreatePersonalDetailImpl.Input(
            height: heightTextField.rx.text.orEmpty
                .map { Int($0) ?? 0 }
                .asObservable(),
            armReach: armReachTextField.rx.text
                .map { Int($0 ?? "") },
            confirmButtonTap: confirmButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.isFormValid
            .drive(onNext: { [weak self] isValid in
                guard let self = self else { return }
                self.confirmButton.isEnabled = isValid
                self.confirmButton.backgroundColor = isValid
                ? OnboardingConst.CreateNickname.Color.confirmDeactivationColor
                : OnboardingConst.CreateNickname.Color.confirmActivationColor
            })
            .disposed(by: disposeBag)
        
        output.updateResult
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                print("업데이트 성공!")
                self.onRegisterResult?()
            })
            .disposed(by: disposeBag)
    }
    
    private func textFieldNumberFilter() {
        heightTextField.rx.text.orEmpty
            .map { text in
                return text.filter { $0.isNumber }
            }
            .bind(to: heightTextField.rx.text)
            .disposed(by: disposeBag)
        
        armReachTextField.rx.text.orEmpty
            .map { text in
                return text.filter { $0.isNumber }
            }
            .bind(to: armReachTextField.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func setupDismissKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
    }
}
