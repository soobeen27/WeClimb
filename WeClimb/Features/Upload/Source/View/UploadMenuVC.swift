//
//  UploadMenuView.swift
//  WeClimb
//
//  Created by 강유정 on 1/24/25.
//
//

import UIKit

import SnapKit

class UploadMenuVC: UIViewController {
    var coordinator: UploadCoordinator?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = UploadMenuConst.UploadMenuVC.Text.title
        label.font = UploadMenuConst.UploadMenuVC.Font.title
        label.textAlignment = .left
        label.textColor = UploadMenuConst.UploadMenuVC.Color.titleText
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = UploadMenuConst.UploadMenuVC.Text.description
        label.font = UploadMenuConst.UploadMenuVC.Font.description
        label.textAlignment = .left
        label.textColor = UploadMenuConst.UploadMenuVC.Color.descriptionText
        return label
    }()
    
    private let climbingButton: UIButton = {
        let button = UIButton()
        button.setTitle(UploadMenuConst.UploadMenuVC.Text.climbingBtnTitle, for: .normal)
        button.titleLabel?.font = UploadMenuConst.UploadMenuVC.Font.climbingBtnTitle
        button.setTitleColor(UploadMenuConst.UploadMenuVC.Color.climbingBtnTitle, for: .normal)
        button.backgroundColor = UploadMenuConst.UploadMenuVC.Color.climbingBtnBackground
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    var onClimbingButtonTapped: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setButton()
        setLayout()
    }
    
    private func addTopBorderToButton(_ button: UIButton) {
        let borderLayer = CALayer()
        borderLayer.backgroundColor = UploadMenuConst.UploadMenuVC.Color.buttonTopBorder.cgColor
        borderLayer.frame = CGRect(
            x: UploadMenuConst.UploadMenuVC.Size.buttonTopBorderInsetX,
            y: UploadMenuConst.UploadMenuVC.Size.buttonTopBorderInsetY,
            width: UploadMenuConst.UploadMenuVC.Size.buttonTopBorderWidth,
            height: UploadMenuConst.UploadMenuVC.Size.buttonTopBorderHeight
        )
        
        button.layer.addSublayer(borderLayer)
    }
    
    private func setView() {
        view.backgroundColor = UploadMenuConst.UploadMenuVC.Color.viewBackground
        view.layer.cornerRadius = UploadMenuConst.UploadMenuVC.Size.viewCornerRadius
        view.layer.shadowColor = UploadMenuConst.UploadMenuVC.Color.viewShadow.cgColor
        view.layer.shadowOpacity = UploadMenuConst.UploadMenuVC.Size.viewShadowOpacity
        view.layer.shadowOffset = UploadMenuConst.UploadMenuVC.Size.viewShadowOffset
        view.layer.shadowRadius = UploadMenuConst.UploadMenuVC.Size.viewShadowRadius
    }
    
    private func setButton() {
        climbingButton.addTarget(self, action: #selector(climbingButtonTapped), for: .touchUpInside)
        addTopBorderToButton(climbingButton)
    }
    
    private func setLayout() {
        [titleLabel, descriptionLabel, climbingButton]
            .forEach { view.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(UploadMenuConst.UploadMenuVC.Layout.titleTopOffset)
            $0.leading.trailing.equalToSuperview().inset(UploadMenuConst.UploadMenuVC.Layout.titleSideInset)
            $0.height.equalTo(UploadMenuConst.UploadMenuVC.Layout.titleHeight)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(UploadMenuConst.UploadMenuVC.Layout.descriptionTopOffset)
            $0.leading.trailing.equalToSuperview().inset(UploadMenuConst.UploadMenuVC.Layout.descriptionSideInset)
            $0.height.equalTo(UploadMenuConst.UploadMenuVC.Layout.descriptionHeight)
        }
        
        climbingButton.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(UploadMenuConst.UploadMenuVC.Layout.climbingBtnTopOffset)
            $0.leading.trailing.equalToSuperview().inset(UploadMenuConst.UploadMenuVC.Layout.climbingBtnSideInset)
            $0.height.equalTo(UploadMenuConst.UploadMenuVC.Layout.climbingBtnHeight)
        }
    }
    
    @objc private func climbingButtonTapped() {
        onClimbingButtonTapped?()
    }
}
