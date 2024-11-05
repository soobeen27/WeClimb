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
import FirebaseAuth
import FirebaseFirestore

class CommentCell: UITableViewCell {
    
    private let db = Firestore.firestore()
    let post: Post
    
    private let likeVM = LikeViewModel()
    private var commentVM: CommentVM?
    var disposeBag = DisposeBag()
    
    let postType: Like = .comment
    
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
    
    private let likeButton = UIButton()
    
    private let likeButtonCounter: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .medium)
//        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let commentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 3
        return stackView
    }()
    
    private let likeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        likeButton.configureHeartButton()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setLayout() {
        [commentProfileImage, commentStackView, likeStackView]
            .forEach {
                contentView.addSubview($0)
            }
        [commentUser, commentLabel]
            .forEach {
                commentStackView.addArrangedSubview($0)
            }
        [likeButton, likeButtonCounter]
            .forEach {
            likeStackView.addArrangedSubview($0)
        }
        commentProfileImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().inset(16)
            $0.width.height.equalTo(38)
        }
        commentStackView.snp.makeConstraints {
            $0.top.equalTo(commentProfileImage.snp.top)
            $0.bottom.equalToSuperview().inset(10)
            $0.leading.equalTo(commentProfileImage.snp.trailing).offset(10)
            $0.trailing.equalTo(likeStackView.snp.leading).offset(-10)
        }
        likeStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.trailing.equalToSuperview().inset(16)
        }
        likeButton.imageView?.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 25, height: 23))
        }
        likeButton.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 25, height: 23))
        }
    }
    
    
    //MARK: - configure
    func configure(userImageString: String, userName: String, userComment: String, likeCounter: Int) {
        self.commentVM = CommentVM(post: post)
        
        if userImageString == "" {
            commentProfileImage.image = UIImage(named: "testStone")
        } else {
            let imageURL = URL(string: userImageString)
            commentProfileImage.kf.setImage(with: imageURL)
        }
        
        commentUser.text = userName
        commentLabel.text = userComment
        likeButtonCounter.text = String(likeCounter)
    }
    
    
    //MARK: - 좋아요 버튼 세팅
    private func setLikeButton() {
        print("Setting LikeButton")
        guard let user = Auth.auth().currentUser else { return }
        
        likeButton.rx.tap
            .asSignal().emit(onNext: { [weak self] in
                guard let self = self else { return }
                let postUid = self.post.postUID
                let commentUID = UUID().uuidString
                let commentRef = db.collection("posts")
                    .document(postUid)
                    .collection("comments")
                    .document(commentUID)
                
                likeVM.likeComment(myUID: user.uid, CommentUID: commentRef, type: postType)
            })
            .disposed(by: disposeBag)
    }
}
