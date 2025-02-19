//
//  GymFilterButton.swift
//  WeClimb
//
//  Created by Soobeen Jang on 2/18/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

class GymFilterButton: UIView {
    
    var titleText: String? {
        didSet {
            titleLabel.text = titleText
        }
    }
    
    let colorRelay = PublishRelay<LHColors>()
    
    private let disposeBag = DisposeBag()
    
    private let titleLabel = UILabel()
    
    private let rightImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = GymConsts.FilterButton.Image.chevDown
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        bindImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        self.layer.cornerRadius = GymConsts.FilterButton.Size.cornerRadius
        self.clipsToBounds = true
        self.layer.borderColor = GymConsts.FilterButton.Color.stroke.cgColor
        self.layer.borderWidth = GymConsts.FilterButton.Size.strokeWidth
        self.snp.makeConstraints {
            $0.height.equalTo(GymConsts.FilterButton.Size.height)
            $0.width.equalTo(GymConsts.FilterButton.Size.width)
        }
        
        [titleLabel, rightImageView]
            .forEach {
                self.addSubview($0)
            }
        

    }
    
    private func bindImage() {
        colorRelay.bind { [weak self] lh in
            guard let self else { return }
            if lh == .other {
                self.setUnselected()
            } else {
                self.setSelected(type: lh)
            }
        }.disposed(by: disposeBag)
    }
    
    private func setUnselected() {
        self.rightImageView.image = GymConsts.FilterButton.Image.chevDown
        self.backgroundColor = GymConsts.FilterButton.Color.background
        self.titleLabel.font = GymConsts.FilterButton.Font.title
        self.titleLabel.textColor = GymConsts.FilterButton.Color.title
    }
    
    private func setSelected(type: LHColors) {
        let image = type.toImage().resize(targetSize: CGSize(
            width: GymConsts.FilterButton.Size.image,
            height: GymConsts.FilterButton.Size.image)
        )
        self.rightImageView.image = image
        self.backgroundColor = GymConsts.FilterButton.Color.selectedBackground
        self.titleLabel.font = GymConsts.FilterButton.Font.selectedTitle
        self.titleLabel.textColor = GymConsts.FilterButton.Color.selectedTitle
    }
}
