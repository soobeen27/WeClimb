//
//  UserProfileSettingVC.swift
//  WeClimb
//
//  Created by 윤대성 on 2/19/25.
//

import UIKit

import SnapKit
import RxCocoa
import RxSwift

enum UserProfileSettingItem {
    case homeGym(name: String)
//    case level(name: String)
    case other(String)
}

enum UserProfileSettingEvent {
    case userPage
    case homeGymPage
}

class UserProfileSettingVC: UIViewController {
    
    var coordinator: UserProfileSettingCoordinator?
    
    private let disposeBag = DisposeBag()
    private let viewModel: UserProfileSettingVM
    
    init(viewModel: UserProfileSettingVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let imageSettingButton: UIImageView = {
        let img = UIImageView()
        img.image = ProfileSettingConst.Image.nonImage
        img.layer.cornerRadius = ProfileSettingConst.CornerRadius.profileImageCornerRadius
        img.contentMode = .scaleAspectFit
        img.clipsToBounds = true
        return img
    }()
    
    // MARK: - 프로필
    private let profileBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = ProfileSettingConst.Color.titleLabelBackgroundColor
        return view
    }()
    
    private let profileLabel: UILabel = {
        let label = UILabel()
        label.text = ProfileSettingConst.Text.titleProfileLabel
        label.font = ProfileSettingConst.Font.titleProfileLabelFont
        label.textColor = ProfileSettingConst.Color.titleLabelColor
        return label
    }()
    
    private let nickNameStackView: UIStackView = {
        let stv = UIStackView()
        stv.spacing = ProfileSettingConst.Spacing.stackViewSpacing
        stv.alignment = .leading
        stv.axis = .horizontal
        return stv
    }()
    
    private let nickNameLabel: UILabel = {
        let label = UILabel()
        label.text = ProfileSettingConst.Text.nickNameLabel
        label.font = ProfileSettingConst.Font.basicFont
        label.textColor = ProfileSettingConst.Color.basicLabelColor
        return label
    }()
    
    private let nickNameRequired: UILabel = {
        let label = UILabel()
        label.text = ProfileSettingConst.Text.nickNameRequiredLabel
        label.font = ProfileSettingConst.Font.valueFont
        label.textColor = ProfileSettingConst.Color.valueLabelColor
        return label
    }()
    
    private let nickNameCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0/12"
        label.textAlignment = .right
        label.font = ProfileSettingConst.Font.valueFont
        label.textColor = ProfileSettingConst.Color.valueLabelColor
        return label
    }()
    
    private let heightStackView: UIStackView = {
        let stv = UIStackView()
        stv.spacing = ProfileSettingConst.Spacing.stackViewSpacing
        stv.alignment = .leading
        stv.axis = .horizontal
        return stv
    }()
    
    private let heightLabel: UILabel = {
        let label = UILabel()
        label.text = ProfileSettingConst.Text.heightLabel
        label.font = ProfileSettingConst.Font.basicFont
        label.textColor = ProfileSettingConst.Color.basicLabelColor
        return label
    }()
    
    private let heightRequired: UILabel = {
        let label = UILabel()
        label.text = ProfileSettingConst.Text.heightRequierdLabel
        label.font = ProfileSettingConst.Font.valueFont
        label.textColor = ProfileSettingConst.Color.valueLabelColor
        return label
    }()
    
    private let armReachStackView: UIStackView = {
        let stv = UIStackView()
        stv.spacing = ProfileSettingConst.Spacing.stackViewSpacing
        stv.alignment = .leading
        stv.axis = .horizontal
        return stv
    }()
    
    private let armReachLabel: UILabel = {
        let label = UILabel()
        label.text = ProfileSettingConst.Text.armReachLabel
        label.font = ProfileSettingConst.Font.basicFont
        label.textColor = ProfileSettingConst.Color.basicLabelColor
        return label
    }()
    
    private let armReachSelection: UILabel = {
        let label = UILabel()
        label.text = ProfileSettingConst.Text.armReachSelectionLabel
        label.font = ProfileSettingConst.Font.valueFont
        label.textColor = ProfileSettingConst.Color.valueLabelColor
        return label
    }()
    
    private let nickNameTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .default
        textField.backgroundColor = .clear
        textField.autocapitalizationType = .none
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 1))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.placeholder = ProfileSettingConst.Text.nickNameTextFieldPlaceholder
        textField.layer.borderColor = ProfileSettingConst.Color.textFieldBorderColor.cgColor
        textField.layer.borderWidth = ProfileSettingConst.Size.textFieldBorderWidth
        textField.layer.cornerRadius = ProfileSettingConst.CornerRadius.textFieldCornerRadius
        textField.font = ProfileSettingConst.Font.textFieldFont
        textField.textColor = ProfileSettingConst.Color.textFieldFontColor
        return textField
    }()
    
    private let heightTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        textField.backgroundColor = .clear
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 1))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.placeholder = ProfileSettingConst.Text.heightTextFieldPlaceholder
        textField.layer.borderColor = ProfileSettingConst.Color.textFieldBorderColor.cgColor
        textField.layer.borderWidth = ProfileSettingConst.Size.textFieldBorderWidth
        textField.layer.cornerRadius = ProfileSettingConst.CornerRadius.textFieldCornerRadius
        textField.font = ProfileSettingConst.Font.textFieldFont
        textField.textColor = ProfileSettingConst.Color.textFieldFontColor
        return textField
    }()
    
    private let armReachTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        textField.backgroundColor = .clear
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 1))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.placeholder = ProfileSettingConst.Text.armReachTextFieldPlaceholder
        textField.layer.borderColor = ProfileSettingConst.Color.textFieldBorderColor.cgColor
        textField.layer.borderWidth = ProfileSettingConst.Size.textFieldBorderWidth
        textField.layer.cornerRadius = ProfileSettingConst.CornerRadius.textFieldCornerRadius
        textField.font = ProfileSettingConst.Font.textFieldFont
        textField.textColor = ProfileSettingConst.Color.textFieldFontColor
        return textField
    }()
    
    
    // MARK: - 활동
    private let activityBackground: UIView = {
        let view = UIView()
        view.backgroundColor = ProfileSettingConst.Color.titleLabelBackgroundColor
        return view
    }()
    
    private let activityLabel: UILabel = {
        let label = UILabel()
        label.text = ProfileSettingConst.Text.activityLabel
        label.font = ProfileSettingConst.Font.titleProfileLabelFont
        label.textColor = ProfileSettingConst.Color.titleLabelColor
        return label
    }()
    
    private let activityTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ActivityTableViewCell.self, forCellReuseIdentifier: ActivityTableViewCell.identifier)
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    // MARK: - other
    private let confirmButton: WeClimbButton = {
        let button = WeClimbButton(style: .defaultRectangle)
        button.setTitle(ProfileSettingConst.Text.confirmButtonLabel, for: .normal)
        button.layer.cornerRadius = ProfileSettingConst.CornerRadius.confirmButtonCornerRadius
        button.backgroundColor = ProfileSettingConst.Color.confirmButtonColor
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        bindViewModel()
        setupNavigationBar()
    }
    
    private func setLayout() {
        view.backgroundColor = .white
        
        profileImageLayout()
        profileSettingLayout()
        activityLayout()
        profileStackViewLayout()
    }
    
    private func profileImageLayout() {
        view.addSubview(imageSettingButton)
        
        imageSettingButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func profileStackViewLayout() {
        [
            nickNameLabel,
            nickNameRequired,
        ].forEach { nickNameStackView.addArrangedSubview($0) }
        
        nickNameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
        }
        
        nickNameRequired.snp.makeConstraints {
            $0.centerY.equalToSuperview()
        }
        
        [
            heightLabel,
            heightRequired,
        ].forEach { heightStackView.addArrangedSubview($0) }
        
        heightLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
        }
        
        heightRequired.snp.makeConstraints {
            $0.centerY.equalToSuperview()
        }
        
        [
            armReachLabel,
            armReachSelection,
        ].forEach { armReachStackView.addArrangedSubview($0) }
        
        armReachLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
        }
        
        armReachSelection.snp.makeConstraints {
            $0.centerY.equalToSuperview()
        }
    }
    
    private func profileSettingLayout() {
        [
            profileLabel
        ].forEach { profileBackgroundView.addSubview($0) }
        
        profileLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
        }
        
        [
            profileBackgroundView,
            nickNameStackView,
            heightStackView,
            armReachStackView,
            nickNameCountLabel,
            nickNameTextField,
            heightTextField,
            armReachTextField,
            confirmButton
        ].forEach { view.addSubview($0) }
        
        profileBackgroundView.snp.makeConstraints {
            $0.top.equalTo(imageSettingButton.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        nickNameStackView.snp.makeConstraints {
            $0.top.equalTo(profileBackgroundView.snp.bottom).offset(21)
            $0.leading.equalToSuperview().offset(16)
        }
        
        nickNameTextField.snp.makeConstraints {
            $0.top.equalTo(nickNameStackView.snp.bottom).offset(4)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(46)
        }
        
        nickNameCountLabel.snp.makeConstraints {
            $0.top.equalTo(nickNameTextField.snp.bottom).offset(4)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(32)
        }
        
        heightStackView.snp.makeConstraints {
            $0.top.equalTo(nickNameCountLabel.snp.bottom).offset(21)
            $0.leading.equalToSuperview().offset(16)
        }
        
        heightTextField.snp.makeConstraints {
            $0.top.equalTo(heightStackView.snp.bottom).offset(4)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(46)
        }
        
        armReachStackView.snp.makeConstraints {
            $0.top.equalTo(heightTextField.snp.bottom).offset(21)
            $0.leading.equalToSuperview().offset(16)
        }
        
        armReachTextField.snp.makeConstraints {
            $0.top.equalTo(armReachStackView.snp.bottom).offset(4)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(46)
        }
        
        confirmButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-20)
            $0.height.equalTo(50)
        }
    }
    
    private func activityLayout() {
        [
            activityLabel,
        ].forEach { activityBackground.addSubview($0) }
        
        activityLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
        
        [
            activityBackground,
            activityTableView,
        ].forEach { view.addSubview($0) }
        
        activityBackground.snp.makeConstraints {
            $0.top.equalTo(armReachTextField.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        activityTableView.snp.makeConstraints {
            $0.top.equalTo(activityBackground.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(confirmButton.snp.top)
        }
    }
    
    private func bindViewModel() {
        let input = UserProfileSettingImpl.Input()
        let output = viewModel.transform(input: input)

        nickNameTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .bind(to: input.nicknameInput)
            .disposed(by: disposeBag)
        
        output.isNicknameValid
            .drive(onNext: { [weak self] isValid in
                guard let self = self else { return }
                let borderColor = isValid ? UIColor.green.cgColor : UIColor.red.cgColor
                self.nickNameTextField.layer.borderColor = borderColor
            })
            .disposed(by: disposeBag)

        nickNameTextField.rx.text.orEmpty
            .map { "\($0.count)/12" }
            .bind(to: nickNameCountLabel.rx.text)
            .disposed(by: disposeBag)

        heightTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .bind(to: input.heightInput)
            .disposed(by: disposeBag)

        armReachTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .bind(to: input.armReachInput)
            .disposed(by: disposeBag)

        output.nicknameText
            .drive(onNext: { [weak self] nickname in
                self?.nickNameTextField.placeholder = nickname
            })
            .disposed(by: disposeBag)
        
        output.heightText
            .drive(onNext: { [weak self] height in
                self?.heightTextField.placeholder = height
            })
            .disposed(by: disposeBag)
        
        output.armReachText
            .drive(onNext: { [weak self] armReach in
                self?.armReachTextField.placeholder = armReach
            })
            .disposed(by: disposeBag)

        confirmButton.rx.tap
            .bind(to: input.confirmButtonTap)
            .disposed(by: disposeBag)

        output.updateResult
            .drive(onNext: { [weak self] success in
                guard let self = self else { return }
                let alert = UIAlertController(
                    title: success ? "성공" : "실패",
                    message: success ? "프로필이 업데이트되었습니다." : "업데이트에 실패했습니다.",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "확인", style: .default))
                self.present(alert, animated: true)
                coordinator?.showReturnPage()
            })
            .disposed(by: disposeBag)

        output.settingItems
            .bind(to: activityTableView.rx.items(cellIdentifier: ActivityTableViewCell.identifier, cellType: ActivityTableViewCell.self)) { row, item, cell in
                switch item {
                case .homeGym(let name):
                    cell.configure(title: "홈짐", value: name)
                case .other(let title):
                    cell.configure(title: title, value: "")
                }
            }
            .disposed(by: disposeBag)

        activityTableView.rx.modelSelected(UserProfileSettingItem.self)
            .subscribe(onNext: { [weak self] item in
                guard let self = self else { return }
                if case .homeGym = item {
                    self.showHomeGymSelection(input: input)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setupNavigationBar() {
        navigationItem.title = ProfileSettingConst.Text.profileSettingTitle
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: ProfileSettingConst.Font.naviTitleFont,
            .foregroundColor: ProfileSettingConst.Color.naviTitleFontColor
        ]
        navigationController?.navigationBar.titleTextAttributes = titleAttributes

        let backButtonImage = ProfileSettingConst.Image.backButtonSymbolImage
        let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(backButtonTapped))
        
        navigationItem.leftBarButtonItem = backButton
        
        addNavigationBarLayer()
    }
    
    private func addNavigationBarLayer() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        
        let bottomBorder = UIView()
        bottomBorder.backgroundColor = ProfileSettingConst.Color.borderColor

        navigationBar.addSubview(bottomBorder)
        
        bottomBorder.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }

    @objc private func backButtonTapped() {
        coordinator?.showReturnPage()
    }
    
    func showHomeGymSelection(input: UserProfileSettingImpl.Input) {
        coordinator?.showHomeGymPage(.homeGymPage)
    }
    
//        func showHomeGymSelection(input: UserProfileSettingImpl.Input) {
//            //        let homeGymVC = HomeGymSelectionVC()
//            //        homeGymVC.selectedGym
//            //            .subscribe(onNext: { gymName in
//            //                input.homeGymSelected.accept(gymName) // 선택된 홈짐 업데이트
//            //            })
//            //            .disposed(by: disposeBag)
//            //        present(homeGymVC, animated: true)
//        }
//    }
}
