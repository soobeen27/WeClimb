//
//  FeedCommentTabelCell.swift
//  WeClimb
//
//  Created by 김솔비 on 9/11/24.
//

import UIKit

import SnapKit
import Kingfisher
import RxSwift
import RxCocoa

class CommentCell: UITableViewCell {
    
    var disposeBag = DisposeBag()
    
    let longPress = PublishRelay<Comment?>()
    
    var commentCellVM: CommentCellVM?
    
    private let commentProfileImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 19
        image.clipsToBounds = true
        image.layer.borderColor = UIColor.systemGray3.cgColor
        return image
    }()
    
    private let commentUser: UILabel = {
        let label = UILabel()
//        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        return label
    }()
    
    private let commentLabel: UILabel = {
        let label = UILabel()
//        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13, weight: .light)
        label.numberOfLines = 0
        return label
    }()
    
//    private let likeButton = UIButton()
//    
//    private let likeButtonCounter: UILabel = {
//        let label = UILabel()
//        label.font = .systemFont(ofSize: 11, weight: .medium)
////        label.textColor = .white
//        label.textAlignment = .center
//        return label
//    }()
    
    private let commentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 3
        return stackView
    }()
    
//    private let likeStackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.axis = .vertical
//        stackView.spacing = 0
//        return stackView
//    }()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
//        likeButton.configureHeartButton()
        setLayout()
        bindLongPress()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        commentProfileImage.image = nil
        commentUser.text = nil
        commentLabel.text = nil
        disposeBag = DisposeBag()
//        likeButtonCounter.text = nil
    }
    
    func bindLongPress() {
        let longPressGesture = UILongPressGestureRecognizer(target: self,
                                                            action: #selector(longPressAccept))
        self.addGestureRecognizer(longPressGesture)
    }
    
    @objc
    private func longPressAccept(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            longPress.accept(commentCellVM?.comment)
        }
    }
    
    
    private func setLayout() {
        contentView.overrideUserInterfaceStyle = .dark
//        [commentProfileImage, commentStackView, likeStackView]
        [commentProfileImage, commentStackView]
            .forEach {
                contentView.addSubview($0)
            }
        [commentUser, commentLabel]
            .forEach {
                commentStackView.addArrangedSubview($0)
            }
//        [likeButton, likeButtonCounter]
//            .forEach {
//            likeStackView.addArrangedSubview($0)
//        }
        commentProfileImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().inset(16)
            $0.width.height.equalTo(38)
        }
        commentStackView.snp.makeConstraints {
            $0.top.equalTo(commentProfileImage.snp.top)
            $0.bottom.equalToSuperview().inset(10)
            $0.leading.equalTo(commentProfileImage.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().offset(-10)
//            $0.trailing.equalTo(likeStackView.snp.leading).offset(-10)
        }
//        likeStackView.snp.makeConstraints {
//            $0.top.equalToSuperview().inset(10)
//            $0.trailing.equalToSuperview().inset(16)
//        }
//        likeButton.imageView?.snp.makeConstraints {
//            $0.size.equalTo(CGSize(width: 25, height: 23))
//        }
//        likeButton.snp.makeConstraints {
//            $0.size.equalTo(CGSize(width: 25, height: 23))
//        }
    }
    
    
    //MARK: - configure
    func configure(commentCellVM: CommentCellVM) {
        self.commentCellVM = commentCellVM
        if let profileString = commentCellVM.user.profileImage {
            let imageURL = URL(string: profileString)
            commentProfileImage.kf.setImage(with: imageURL)
        } else {
            commentProfileImage.image = UIImage(named: "testStone")
        }
        commentUser.text = commentCellVM.user.userName ?? "탈퇴한 회원"
        commentLabel.text = commentCellVM.comment.content
        
//        commentCellVM.commentLikeList
//            .asDriver()
//            .drive(onNext: { [weak self] likeList in
//                guard let self else { return }
//                self.likeButtonCounter.text = String(likeList.count)
//            })
//            .disposed(by: disposeBag)
//        
//        let myUID = FirebaseManager.shared.currentUserUID()
//
//        likeButton.rx.tap
//            .asSignal().emit(onNext: {
//                commentCellVM.likeComment(myUID: myUID)
//            })
//            .disposed(by: disposeBag)
//        
//        commentCellVM.commentLikeList
//            .asDriver()
//            .drive(onNext: { [weak self] likeList in
//                guard let self else { return }
//                self.likeButtonCounter.text = String(likeList.count)
//                if likeList.contains([myUID]) {
//                    self.likeButton.isActivated = true
//                }  else {
//                    self.likeButton.isActivated = false
//                }
//                self.likeButton.configureHeartButton()
//            })
//            .disposed(by: disposeBag)
    }
}
