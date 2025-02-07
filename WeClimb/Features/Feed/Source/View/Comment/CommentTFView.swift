//
//  CommentTFView.swift
//  WeClimb
//
//  Created by Soobeen Jang on 2/6/25.
//

import UIKit

import SnapKit
import RxSwift

class CommentTFView: UIView {
    
    private let strokeView: UIView = {
        let view = UIView()
        view.backgroundColor = CommentConsts.strokeColor
        return view
    }()
    
    var postOwnerName: String? {
        didSet {
            if let postOwnerName {
                placeholderText = postOwnerName + CommentConsts.TextFieldView.Text.placeholder
            }
        }
    }
    
    private var placeholderText: String = "댓글 추가"
    
    lazy var commentTF: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .line
        tf.backgroundColor = CommentConsts.TextFieldView.Color.tfBackground
        tf.layer.cornerRadius = CommentConsts.TextFieldView.Size.tfCornerRadius
        tf.layer.borderColor = CommentConsts.TextFieldView.Color.tfStroke.cgColor
        tf.layer.borderWidth = 1
        tf.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [
            NSAttributedString.Key.foregroundColor: CommentConsts.TextFieldView.Color.placeholder,
            NSAttributedString.Key.font: CommentConsts.TextFieldView.Font.placeholder
        ])
        tf.textColor = CommentConsts.textColor
        
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: CommentConsts.TextFieldView.Size.padding, height: tf.frame.height))
        tf.leftView = leftPaddingView
        tf.leftViewMode = .always
        tf.rightView = tfRightView
        tf.rightViewMode = .always
        return tf
    }()

    lazy var tfRightView: UIView = {
        let v = UIView()
        v.addSubview(sendButton)
        sendButton.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-CommentConsts.TextFieldView.Size.padding)
            $0.centerY.equalToSuperview()
        }
        v.snp.makeConstraints {
            $0.width.equalTo(CommentConsts.TextFieldView.Size.sendButton + CommentConsts.TextFieldView.Size.padding)
            $0.height.equalTo(CommentConsts.TextFieldView.Size.tfHeight)
        }
        return v
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton()
        button.setImage(CommentConsts.TextFieldView.Image.send, for: .normal)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        self.backgroundColor = CommentConsts.TextFieldView.Color.background
        
        [strokeView, commentTF]
            .forEach { self.addSubview($0) }
        
        strokeView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        commentTF.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(CommentConsts.TextFieldView.Size.padding)
            $0.top.equalTo(strokeView).offset(CommentConsts.TextFieldView.Size.padding)
            $0.height.equalTo(CommentConsts.TextFieldView.Size.tfHeight)
        }
    }
    
}
