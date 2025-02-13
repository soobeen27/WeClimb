//
//  PostCommentTableCell.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//

import UIKit

import SnapKit
import Kingfisher
import RxSwift
import RxCocoa

class PostCommentTableCell: UITableViewCell {
    
    let longPress = PublishRelay<(commentUID: String, authorUID: String)>()
    
    private var uids: (commentUID: String, authorUID: String)?
    
    var disposeBag = DisposeBag()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage.defaultAvatarProfile
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 16
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = CommentConsts.Cell.Font.userName
        label.textColor = CommentConsts.textColor
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = CommentConsts.Cell.Font.date
        label.textColor = CommentConsts.Cell.Color.date
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = CommentConsts.Cell.Font.content
        label.textColor = CommentConsts.textColor
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var contentContainer: UIView = {
        let v = UIView()
        v.addSubview(contentLabel)
        return v
    }()
    
    private lazy var profileStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [nameLabel, contentContainer, dateLabel])
        sv.axis = .vertical
        sv.alignment = .leading
        sv.spacing = CommentConsts.Cell.Size.spacing
        return sv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
        bindLongPress()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = UIImage.defaultAvatarProfile
        nameLabel.text = nil
        dateLabel.text = nil
        contentLabel.text = nil
        uids = nil
        disposeBag = DisposeBag()
    }
    
    func configure(data: CommentCellData) {
        nameLabel.text = data.name
        dateLabel.text = data.date
        contentLabel.text = data.content
        if let profileURL = data.profileImageURL {
            profileImageView.kf.setImage(with: profileURL)
        }
        uids = (commentUID: data.commentUID, authorUID: data.authorUID)
    }
    
    private func bindLongPress() {
        let longPressGesture = UILongPressGestureRecognizer(target: self,
                                                            action: #selector(longPressAccept))
        self.addGestureRecognizer(longPressGesture)
    }
    
    @objc
    private func longPressAccept(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began, let uids {
            longPress.accept(uids)
        }
    }
    
    private func setLayout() {
        contentView.backgroundColor = CommentConsts.backgroundColor
        [profileImageView, profileStackView]
            .forEach {
                contentView.addSubview($0)
            }
        
        profileImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(CommentConsts.Cell.Size.hPadding)
            $0.top.equalToSuperview().offset(CommentConsts.Cell.Size.vPadding)
            $0.size.equalTo(CommentConsts.Cell.Size.profileImage)
        }
        
        profileStackView.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(CommentConsts.Cell.Size.spacing)
            $0.top.bottom.equalToSuperview().inset(CommentConsts.Cell.Size.vPadding)
            $0.trailing.equalToSuperview().offset(-CommentConsts.Cell.Size.hPadding)
        }
        
        contentLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(CommentConsts.Cell.Size.contentPadding)
        }
        
    }
}
