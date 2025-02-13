//
//  FeedMenuVC.swift
//  WeClimb
//
//  Created by Soobeen Jang on 2/11/25.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

enum FeedMenuSelection {
    case delete
    case report
    case block
}

class FeedMenuView: UIView {
    
    var isMine: Bool? {
        didSet {
            guard let isMine else { return }
            setLayout(isMine: isMine)
        }
    }
    private let disposeBag = DisposeBag()
    
    let selectedButtonType = PublishRelay<FeedMenuSelection>()
    
    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(FeedConsts.Menu.Text.delete, for: .normal)
        button.backgroundColor = FeedConsts.Menu.Color.background
        let attributedString = NSAttributedString(string: FeedConsts.Menu.Text.delete, attributes: [.font: FeedConsts.Menu.Font.text,
            .foregroundColor: FeedConsts.Menu.Color.text])
        button.setAttributedTitle(attributedString, for: .normal)
        return button
    }()
    
    private let reportButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = FeedConsts.Menu.Color.background
        let attributedString = NSAttributedString(string: FeedConsts.Menu.Text.report, attributes: [.font: FeedConsts.Menu.Font.text,
            .foregroundColor: FeedConsts.Menu.Color.text])
        button.setAttributedTitle(attributedString, for: .normal)
        return button
    }()
    
    private let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = FeedConsts.Menu.Color.seperator
        return view
    }()
    
    private let blockButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = FeedConsts.Menu.Color.background
        let attributedString = NSAttributedString(string: FeedConsts.Menu.Text.block, attributes: [.font: FeedConsts.Menu.Font.text,
            .foregroundColor: FeedConsts.Menu.Color.text])
        button.setAttributedTitle(attributedString, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bindButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bindButtons() {
        deleteButton.rx.tap
            .map { FeedMenuSelection.delete }
            .bind(to: selectedButtonType)
            .disposed(by: disposeBag)

        reportButton.rx.tap
            .map { FeedMenuSelection.report }
            .bind(to: selectedButtonType)
            .disposed(by: disposeBag)

        blockButton.rx.tap
            .map { FeedMenuSelection.block }
            .bind(to: selectedButtonType)
            .disposed(by: disposeBag)
    }
    
    private func setLayout(isMine: Bool) {
        self.layer.cornerRadius = FeedConsts.Menu.Size.cornerRadius
        self.layer.masksToBounds = true
        
        self.subviews.forEach { $0.removeFromSuperview() }
        if isMine {
            setMineLayout()
        } else {
            setNotMineLayout()
        }
    }
    
    private func setMineLayout() {
        self.addSubview(deleteButton)
        guard let titleLabel = deleteButton.titleLabel else { return }
        titleLabel.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview().inset(FeedConsts.Menu.Size.padding)
            $0.width.equalTo(FeedConsts.Menu.Size.width)
        }
        deleteButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(250)
        }

    }
    
    private func setNotMineLayout() {
        let stackView = UIStackView(arrangedSubviews: [reportButton, seperatorView, blockButton])
        stackView.axis = .vertical
        
        self.addSubview(stackView)
        
        guard let reportTitleLabel = reportButton.titleLabel else { return }
        reportTitleLabel.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview().inset(FeedConsts.Menu.Size.padding)
        }
        guard let blockTitleLabel = blockButton.titleLabel else { return }
        blockTitleLabel.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview().inset(FeedConsts.Menu.Size.padding)
        }
        
        seperatorView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(250)
        }
        
    }
    
}
