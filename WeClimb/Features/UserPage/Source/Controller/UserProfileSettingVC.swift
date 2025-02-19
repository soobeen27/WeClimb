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

class UserProfileSettingVC: UIViewController {
    
    private let disposeBag = DisposeBag()
    
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
        label.text = "0/50"
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
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 1)) // 8px 여백
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
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 1)) // 8px 여백
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
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 1)) // 8px 여백
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
}
