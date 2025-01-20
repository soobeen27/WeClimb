//
//  CreateNicknameVC.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//

import UIKit

import SnapKit
import RxCocoa
import RxSwift

class CreateNicknameVC: UIViewController {
    var coordinator: CreateNickNameCoordinator?
    
    private let disposeBag = DisposeBag()
    private let viewModel: CreateNicknameVM
    
    var onCreateNickname: (() -> Void)?
    
    init(coordinator: CreateNickNameCoordinator? = nil, viewModel: CreateNicknameVM) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let rightIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = OnboardingConst.CreateNickname.Icon.chevronRight
        imageView.tintColor = .lightGray
        imageView.isHidden = true
        return imageView
    }()
    
    private let crossIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = OnboardingConst.CreateNickname.Icon.xCircle
        imageView.tintColor = .black
        imageView.isHidden = true
        return imageView
    }()
    
    private let logoImage: UIImageView = {
        var image = UIImageView()
        image.image = OnboardingConst.weclimbLogo
        return image
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = OnboardingConst.CreateNickname.Text.titleLabel
        label.font = OnboardingConst.CreateNickname.Font.titleFont
        label.numberOfLines = OnboardingConst.CreateNickname.Text.titleNumberofLine
        label.textColor = OnboardingConst.CreateNickname.Color.titleTextColor
        return label
    }()
    
    private let pageController: UILabel = {
        let label = UILabel()
        label.text = OnboardingConst.CreateNickname.Text.pageControl
        label.textColor = OnboardingConst.CreateNickname.Color.pageControlTextColor
        label.font = OnboardingConst.CreateNickname.Font.valueFont
        label.layer.cornerRadius = OnboardingConst.CreateNickname.CornerRadius.pageControl
        label.contentMode = .center
        return label
    }()
    
    private let nickNameTitleLabel: UILabel = {
        let label = UILabel()
        label.text = OnboardingConst.CreateNickname.Text.nickNameTitle
        label.textColor = OnboardingConst.CreateNickname.Color.titleTextColor
        label.font = OnboardingConst.CreateNickname.Font.nickNameTitle
        return label
    }()
    
    private let nickNameSubTitleLabel: UILabel = {
        let label = UILabel()
        label.text = OnboardingConst.CreateNickname.Text.nickNameSub
        label.textColor = OnboardingConst.CreateNickname.Color.subtitleTextColor
        label.font = OnboardingConst.CreateNickname.Font.valueFont
        return label
    }()
    
    private let nickNameTitleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = OnboardingConst.CreateNickname.Spacing.stackViewSpacing
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let nickNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = OnboardingConst.CreateNickname.Text.nicknamePlaceholder
        
        textField.borderStyle = .roundedRect
        textField.font = OnboardingConst.CreateNickname.Font.placeholderFont
        textField.textColor = OnboardingConst.CreateNickname.Color.nickNameLabelColor
        
        textField.backgroundColor = OnboardingConst.CreateNickname.Color.backgroundColor
        textField.layer.cornerRadius = OnboardingConst.CreateNickname.CornerRadius.textField
        textField.layer.borderWidth = OnboardingConst.CreateNickname.Size.borderWidth
        textField.layer.borderColor = OnboardingConst.CreateNickname.Color.boarderGray.cgColor
        
        textField.attributedPlaceholder = NSAttributedString(
            string: OnboardingConst.CreateNickname.Text.nicknamePlaceholder,
            attributes: [
                .foregroundColor: OnboardingConst.CreateNickname.Color.nickNameFieldColor
            ]
        )
        return textField
    }()
    
    private let errorMessageLabel: UILabel = {
        let label = UILabel()
        label.font = OnboardingConst.CreateNickname.Font.valueFont
        label.isHidden = true
        return label
    }()
    
    private let characterCountLabel: UILabel = {
        let label = UILabel()
        label.text = OnboardingConst.CreateNickname.Text.charCountLabel
        label.font = OnboardingConst.CreateNickname.Font.valueFont
        label.textColor = OnboardingConst.CreateNickname.Color.subtitleTextColor
        return label
    }()
    
    private let confirmButton: WeClimbButton = {
        let button = WeClimbButton(style: .defaultRectangle)
        button.setTitle(OnboardingConst.CreateNickname.Text.nextPage, for: .normal)
        button.backgroundColor = OnboardingConst.CreateNickname.Color.confirmActivationColor
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = OnboardingConst.CreateNickname.CornerRadius.confirmButton
        button.isEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nickNameTextField.delegate = self
        setLayout()
        bindViewModel()
        setupDismissKeyboardGesture()
    }
    
    private func setLayout() {
        view.backgroundColor = OnboardingConst.CreateNickname.Color.backgroundColor
        
        [
            nickNameTitleLabel,
            nickNameSubTitleLabel,
        ].forEach { nickNameTitleStackView.addArrangedSubview($0) }
        
        [
            logoImage,
            titleLabel,
            pageController,
            nickNameTitleStackView,
            nickNameTextField,
            errorMessageLabel,
            rightIconImageView,
            crossIconImageView,
            characterCountLabel,
            confirmButton
        ].forEach { view.addSubview($0) }
        
        pageController.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-OnboardingConst.CreateNickname.Spacing.viewHorizontalMargin)
            $0.height.width.equalTo(OnboardingConst.CreateNickname.Size.pageControlSize)
        }
        
        logoImage.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(OnboardingConst.CreateNickname.Spacing.logoTopMargin)
            $0.leading.equalToSuperview().offset(OnboardingConst.CreateNickname.Spacing.viewHorizontalMargin)
            $0.height.width.equalTo(OnboardingConst.CreateNickname.Size.logoSize)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(logoImage.snp.bottom).offset(OnboardingConst.CreateNickname.Spacing.viewHorizontalMargin)
            $0.leading.equalToSuperview().offset(OnboardingConst.CreateNickname.Spacing.viewHorizontalMargin)
            $0.trailing.equalToSuperview().offset(-OnboardingConst.CreateNickname.Spacing.viewHorizontalMargin)
        }
        
        nickNameTitleStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(OnboardingConst.CreateNickname.Spacing.nicknameTextFieldTop)
            $0.leading.equalToSuperview().offset(OnboardingConst.CreateNickname.Spacing.viewHorizontalMargin)
            $0.height.width.equalTo(OnboardingConst.CreateNickname.Size.nickNameTilteStackViewSize)
        }
        
        nickNameTitleLabel.snp.makeConstraints {
            $0.height.width.equalTo(OnboardingConst.CreateNickname.Size.nickNameTitleLabelSize)
        }
        
        nickNameSubTitleLabel.snp.makeConstraints {
            $0.height.width.equalTo(OnboardingConst.CreateNickname.Size.nickNameSubTitleLabelSize)
        }
        
        nickNameTextField.snp.makeConstraints {
            $0.top.equalTo(nickNameTitleStackView.snp.bottom).offset(OnboardingConst.CreateNickname.Spacing.textFieldTopOffset)
            $0.leading.equalToSuperview().offset(OnboardingConst.CreateNickname.Spacing.viewHorizontalMargin)
            $0.trailing.equalToSuperview().offset(-OnboardingConst.CreateNickname.Spacing.viewHorizontalMargin)
            $0.height.width.equalTo(OnboardingConst.CreateNickname.Size.textFieldHeight)
        }
        
        errorMessageLabel.snp.makeConstraints {
            $0.top.equalTo(nickNameTextField.snp.bottom).offset(OnboardingConst.CreateNickname.Spacing.labelTopOffset)
            $0.leading.trailing.equalTo(nickNameTextField)
            $0.height.equalTo(OnboardingConst.CreateNickname.Size.errorMessageHeight)
        }
        
        rightIconImageView.snp.makeConstraints {
            $0.centerY.equalTo(nickNameTextField)
            $0.trailing.equalTo(nickNameTextField).offset(-OnboardingConst.CreateNickname.Spacing.textFieldTopOffset)
            $0.height.width.equalTo(OnboardingConst.CreateNickname.Size.iconSize)
        }
        
        crossIconImageView.snp.makeConstraints {
            $0.centerY.equalTo(nickNameTextField)
            $0.trailing.equalTo(rightIconImageView.snp.leading).offset(-OnboardingConst.CreateNickname.Spacing.textFieldTopOffset)
            $0.height.width.equalTo(OnboardingConst.CreateNickname.Size.iconSize)
        }
        
        characterCountLabel.snp.makeConstraints {
            $0.top.equalTo(nickNameTextField.snp.bottom).offset(OnboardingConst.CreateNickname.Spacing.labelTopOffset)
            $0.trailing.equalToSuperview().offset(-OnboardingConst.CreateNickname.Spacing.viewHorizontalMargin)
            $0.height.width.equalTo(OnboardingConst.CreateNickname.Size.characterCountLabelSize)
        }
        
        confirmButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-OnboardingConst.CreateNickname.Spacing.confirmButtonBottomOffset)
            $0.leading.equalToSuperview().offset(OnboardingConst.CreateNickname.Spacing.viewHorizontalMargin)
            $0.trailing.equalToSuperview().offset(-OnboardingConst.CreateNickname.Spacing.viewHorizontalMargin)
        }
    }
    
    private func bindViewModel() {
        let input = CreateNicknameImpl.Input(
            nicknameInput: nickNameTextField.rx.text.orEmpty.asObservable(),
            confirmButtonTap: confirmButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
//        output.isNicknameValid
//            .drive(onNext: { [weak self] isValid in
//                guard let self = self else { return }
////                self.rightIconImageView.isHidden = !isValid
////                self.crossIconImageView.isHidden = isValid
////                self.errorMessageLabel.isHidden = isValid
////                self.errorMessageLabel.text = isValid ? "" : "닉네임은 2~12자의 한글, 영문, 숫자만 가능합니다."
//            })
//            .disposed(by: disposeBag)
        
        output.characterCount
            .map { "\($0)/12" }
            .drive(characterCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.updateResult
            .drive(onNext: { [weak self] success in
                guard let self = self else { return }
                if success {
                    self.onCreateNickname?()
                } else {
                    self.errorMessageLabel.isHidden = false
                    self.errorMessageLabel.text = OnboardingConst.CreateNickname.Text.errorMessageDuplicate
                }
            })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(output.isNicknameValid.asObservable(), output.characterCount.asObservable())
            .subscribe(onNext: { [weak self] isValid, count in
                guard let self = self else { return }
                let isEnabled = isValid && count <= OnboardingConst.CreateNickname.Size.maxCharacterCount
                self.confirmButton.isEnabled = isEnabled
                self.confirmButton.backgroundColor = isEnabled ? OnboardingConst.CreateNickname.Color.confirmDeactivationColor : OnboardingConst.CreateNickname.Color.confirmActivationColor
            })
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
    
    //MARK: - 추후 추가될 심볼 구현
//    private func setupTextFieldEvents() {
//        nickNameTextField.rx.controlEvent([.editingDidBegin])
//            .subscribe(onNext: { [weak self] in
//                self?.updateTextFieldForEditing()
//            })
//            .disposed(by: disposeBag)
//        
//        nickNameTextField.rx.controlEvent([.editingDidEnd])
//            .subscribe(onNext: { [weak self] in
//                self?.updateTextFieldForIdle()
//            })
//            .disposed(by: disposeBag)
//    }
    
//    private func updateTextFieldForEditing() {
//        nickNameTextField.layer.borderColor = UIColor.black.cgColor
//        rightIconImageView.image = UIImage(systemName: "x.circle")
//        rightIconImageView.tintColor = .black
//    }
//    
//    private func updateTextFieldForIdle() {
//        nickNameTextField.layer.borderColor = UIColor.lightGray.cgColor
//        rightIconImageView.image = UIImage(systemName: "chevron.right")
//        rightIconImageView.tintColor = .lightGray
//    }
//    
//    private func handleDuplicateCheckResult(isDuplicate: Bool) {
//        if isDuplicate {
//            nickNameTextField.layer.borderColor = UIColor.red.cgColor
//            rightIconImageView.image = UIImage(systemName: "x.circle")
//            rightIconImageView.tintColor = .red
//            crossIconImageView.image = UIImage(systemName: "exclamationmark.circle")
//            crossIconImageView.tintColor = .red
//            crossIconImageView.isHidden = true
//        } else {
//            nickNameTextField.layer.borderColor = UIColor.lightGray.cgColor
//            rightIconImageView.image = UIImage(systemName: "chevron.right")
//            rightIconImageView.tintColor = .lightGray
//            crossIconImageView.isHidden = true
//        }
//    }
}

extension CreateNicknameVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.contains(" ") {
            return false
        }
        
        guard let currentText = textField.text else { return true }
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        return newText.count <= OnboardingConst.CreateNickname.Size.maxCharacterCount
    }
}
