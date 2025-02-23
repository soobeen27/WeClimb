//
//  PostSidebarView.swift
//  WeClimb
//
//  Created by Soobeen Jang on 1/17/25.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

class PostSidebarView: UIView {
    
    var disposeBag = DisposeBag()
    
    let isLikeRelay = PublishRelay<Bool?>()
    let likeCountRelay = PublishRelay<Int>()
    let commentCountRelay = PublishRelay<Int>()
    
    var commentButtonTap: ControlEvent<Void> {
        return commentButton.rx.tap
    }
    
    var likeButtonTap: ControlEvent<Void> {
        return likeButton.rx.tap
    }
    
    var additionalActionButtonTap: ControlEvent<Void> {
        return additionalActionButton.rx.tap
    }
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.setImage(FeedConsts.Sidebar.Image.heart, for: .normal)
        button.setImage(FeedConsts.Sidebar.Image.heart, for: .disabled)
        button.setImage(FeedConsts.Sidebar.Image.heartFill, for: .selected)
        return button
    }()
    
    private let likeCountLabel: UILabel = {
        let label = UILabel()
        label.font = FeedConsts.Sidebar.Font.count
        label.textColor = FeedConsts.Sidebar.Color.tint
        label.textAlignment = .center
        return label
    }()
    
    private lazy var likeStackView: UIStackView = {
        let stv = UIStackView(arrangedSubviews: [likeButton])
        stv.axis = .vertical
        stv.spacing = FeedConsts.Sidebar.Size.countSpacing
        return stv
    }()
    
    private lazy var commentButton: UIButton = {
        let button = UIButton()
        button.setImage(FeedConsts.Sidebar.Image.comment, for: .normal)
        button.tintColor = FeedConsts.Sidebar.Color.tint
        return button
    }()
    
    private let commentCountLabel: UILabel = {
        let label = UILabel()
        label.font = FeedConsts.Sidebar.Font.count
        label.textColor = FeedConsts.Sidebar.Color.tint
        label.textAlignment = .center
        return label
    }()
    
    private lazy var commentStackView: UIStackView = {
        let stv = UIStackView(arrangedSubviews: [commentButton])
        stv.axis = .vertical
        stv.spacing = FeedConsts.Sidebar.Size.countSpacing
        return stv
    }()
    
    private lazy var additionalActionButton: UIButton = {
        let button = UIButton()
        button.setImage(FeedConsts.Sidebar.Image.extraFunc, for: .normal)
        button.tintColor = FeedConsts.Sidebar.Color.tint
        return button
    }()
    
    private lazy var sidebarStackView: UIStackView = {
        let stv = UIStackView(arrangedSubviews: [likeStackView, commentStackView, additionalActionButton])
        stv.axis = .vertical
        stv.spacing = FeedConsts.Sidebar.Size.spacing
        return stv
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setLayout()
        setStackView()
        likeCheck()
        bindLikeButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func resetToDefaultState() {
        commentCountLabel.removeFromSuperview()
        likeCountLabel.removeFromSuperview()
    }
    
    private func setStackView() {
        setLikeStackView()
        setCommentStackView()
    }
    
    private func likeCheck() {
        isLikeRelay
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isLike in
                guard let self, let isLike else {
                    self?.likeButton.isEnabled = false
                    return
                }
                self.likeButton.isSelected = isLike
            })
            .disposed(by: disposeBag)
    }
    
    private func bindLikeButton() {
        likeButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.likeButton.isSelected.toggle()
                self?.isLikeRelay.accept(self?.likeButton.isSelected ?? false)
                
            })
            .disposed(by: disposeBag)
        
    }
    
    private func setLikeStackView() {
        likeCountRelay
            .bind(onNext: { [weak self] likeCount in
                guard let self else { return }
                if likeCount > 0 {
                    self.likeCountLabel.text = "\(likeCount)"
                    self.likeStackView.addArrangedSubview(self.likeCountLabel)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setCommentStackView() {
        commentCountRelay
            .bind(onNext: { [weak self] commentCount in
                guard let self else { return }
                if commentCount > 0 {
                    self.commentCountLabel.text = "\(commentCount)"
                    self.commentStackView.addArrangedSubview(self.commentCountLabel)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setLayout() {
        self.addSubview(sidebarStackView)
        
        sidebarStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
