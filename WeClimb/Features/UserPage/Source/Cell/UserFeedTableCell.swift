//
//  UserFeedTableCell.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

class UserFeedTableCell: UITableViewCell {
    static let identifier = "UserFeedTableCell"
    
    private var disposeBag = DisposeBag()
    private var viewModel: UserFeedTableCellVM?
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UserPageConst.FeedCell.Font.dateLabelFont
        label.textColor = UserPageConst.FeedCell.Color.dateLabelFontColor
        return label
    }()
    
    private let likeImage: UIImageView = {
        let img = UIImageView()
        img.image = UserPageConst.FeedCell.Image.likeImage
        return img
    }()
    
    private let likeCountLabel: UILabel = {
        let label = UILabel()
        label.font = UserPageConst.FeedCell.Font.valueLabelFont
        label.textColor = UserPageConst.FeedCell.Color.valueLabelFontColor
        return label
    }()
    
    private lazy var likeStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [likeImage, likeCountLabel])
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        return stack
    }()
    
    private let commentImage: UIImageView = {
        let img = UIImageView()
        img.image = UserPageConst.FeedCell.Image.commentImage
        return img
    }()
    
    private let commentCountLabel: UILabel = {
        let label = UILabel()
        label.font = UserPageConst.FeedCell.Font.valueLabelFont
        label.textColor = UserPageConst.FeedCell.Color.valueLabelFontColor
        return label
    }()
    
    private lazy var commentStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [commentImage, commentCountLabel])
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        return stack
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UserPageConst.FeedCell.Font.captionLabelFont
        label.textColor = UserPageConst.FeedCell.Color.captionLabelFontColor
        label.numberOfLines = 1
        return label
    }()
    
    private let badgeView = UserFeedBadgeView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        self.backgroundColor = .clear
        [
            dateLabel,
            badgeView,
            captionLabel,
            likeStackView,
            commentStackView
        ].forEach { contentView.addSubview($0) }
        
        dateLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(16)
        }
        
        likeStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.trailing.equalTo(commentStackView.snp.leading).offset(-8)
            $0.height.equalTo(16)
        }
        
        commentStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(16)
        }
        
        badgeView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(84)
        }
        
        captionLabel.snp.makeConstraints {
            $0.top.equalTo(badgeView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-16)
        }
    }
  
    func configure(with viewModel: UserFeedTableCellVMImpl) {
        self.viewModel = viewModel
        disposeBag = DisposeBag()
        
        let input = UserFeedTableCellVMImpl.Input()
        bindViewModel(input: input)
        
        input.fetchDataTrigger.onNext(())
    }

    func bindViewModel(input: UserFeedTableCellVMImpl.Input) {
        guard let viewModel = viewModel else { return }

        let output = viewModel.transform(input: input)
        
        output.dateText
            .drive(dateLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.likeCountText
            .drive(likeCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.commentCountText
            .drive(commentCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.captionText
            .drive(captionLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.badgeModel
            .drive(onNext: { [weak self] model in
                print("🛠 badgeModel emit됨: \(model)")
                self?.badgeView.configure(with: model)
            })
            .disposed(by: disposeBag)
    }
}
