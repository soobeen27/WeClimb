//
//  UploadTextView.swift
//  WeClimb
//
//  Created by 강유정 on 2/11/25.
//

import UIKit

import SnapKit
import RxSwift

class UploadTextView : UIView {
    
    private let disposeBag = DisposeBag()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "문구"
        label.font = .customFont(style: .label1Medium)
        label.textColor = .white
        return label
    }()
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.font = .customFont(style: .body2Medium)
        textView.textColor = .labelNormal
        textView.text = " 내용을 입력해주세요."
        textView.backgroundColor = .fillSolidDarkBlack
        textView.returnKeyType = .done
        textView.layer.cornerRadius = 8
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lineOpacityNormal.cgColor
        textView.isUserInteractionEnabled = true
        textView.isEditable = true
        return textView
    }()
    
    private let helpMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "도움말 메세지"
        label.font = .customFont(style: .caption1Regular)
        label.textColor = .labelNeutral
        return label
    }()
    
    let textFieldCharCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0/1000"
        label.font = .customFont(style: .caption1Regular)
        label.textColor = .labelNeutral
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        
        setLayout()
        applyCornerRadius()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 212)
    }
    
    private func applyCornerRadius() {
        layer.cornerRadius = 20
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        clipsToBounds = true
    }
    
    private func setLayout() {
        self.backgroundColor = UIColor.fillSolidDarkStrong
        
        [titleLabel, textView, helpMessageLabel, textFieldCharCountLabel]
            .forEach { self.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview().offset(16)
        }
        
        textView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.height.equalTo(128)
        }
        
        helpMessageLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalTo(textView.snp.bottom).offset(8)
        }
        
        textFieldCharCountLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.top.equalTo(textView.snp.bottom).offset(8)
        }
    }
}
