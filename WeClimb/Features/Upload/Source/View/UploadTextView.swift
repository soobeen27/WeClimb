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
        label.text = UploadPostConst.UploadTextView.Text.title
        label.font = UploadPostConst.UploadTextView.Font.title
        label.textColor = UploadPostConst.UploadTextView.Color.titleText
        return label
    }()
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.font = UploadPostConst.UploadTextView.Font.textView
        textView.textColor = UploadPostConst.UploadTextView.Color.textViewText
        textView.text = UploadPostConst.UploadTextView.Text.placeholder
        textView.backgroundColor = UploadPostConst.UploadTextView.Color.textViewBackground
        textView.returnKeyType = .done
        textView.layer.cornerRadius = UploadPostConst.UploadTextView.Size.textViewCornerRadius
        textView.layer.borderWidth = UploadPostConst.UploadTextView.Size.textViewBorderWidth
        textView.layer.borderColor = UploadPostConst.UploadTextView.Color.textViewBorder.cgColor
        textView.isUserInteractionEnabled = true
        textView.isEditable = true
        return textView
    }()
    
    private let helpMessageLabel: UILabel = {
        let label = UILabel()
        label.text = UploadPostConst.UploadTextView.Text.helpMessage
        label.font = UploadPostConst.UploadTextView.Font.helpMessage
        label.textColor = UploadPostConst.UploadTextView.Color.helpMessageText
        return label
    }()
    
    let textFieldCharCountLabel: UILabel = {
        let label = UILabel()
        label.text = UploadPostConst.UploadTextView.Text.charCountFormat
        label.font = UploadPostConst.UploadTextView.Font.charCount
        label.textColor = UploadPostConst.UploadTextView.Color.charCountText
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
        return UploadPostConst.UploadTextView.Size.viewIntrinsicContent
    }
    
    private func applyCornerRadius() {
        layer.cornerRadius = UploadPostConst.UploadTextView.Size.viewCornerRadius
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        clipsToBounds = true
    }
    
    private func setLayout() {
        self.backgroundColor = UploadPostConst.UploadTextView.Color.viewBackground
        
        [titleLabel, textView, helpMessageLabel, textFieldCharCountLabel]
            .forEach { self.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(UploadPostConst.UploadTextView.Layout.titleLeadingOffset)
            $0.top.equalToSuperview().offset(UploadPostConst.UploadTextView.Layout.titleTopOffset)
        }
        
        textView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(UploadPostConst.UploadTextView.Layout.textViewSideInset)
            $0.top.equalTo(titleLabel.snp.bottom).offset(UploadPostConst.UploadTextView.Layout.textViewTopOffset)
            $0.height.equalTo(UploadPostConst.UploadTextView.Layout.textViewHeight)
        }
        
        helpMessageLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(UploadPostConst.UploadTextView.Layout.helpMessageLeadingOffset)
            $0.top.equalTo(textView.snp.bottom).offset(UploadPostConst.UploadTextView.Layout.helpMessageTopOffset)
        }
        
        textFieldCharCountLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(UploadPostConst.UploadTextView.Layout.charCountTrailingOffset)
            $0.top.equalTo(textView.snp.bottom).offset(UploadPostConst.UploadTextView.Layout.charCountTopOffset)
        }
    }
}
