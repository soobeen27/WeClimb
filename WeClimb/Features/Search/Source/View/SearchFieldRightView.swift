//
//  se.swift
//  WeClimb
//
//  Created by 강유정 on 1/21/25.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class SearchFieldRightView: UIView {
    
    private let disposeBag = DisposeBag()
    
    private let circleCancelButton: UIButton = {
        let button = UIButton(type: .system)
        let closeIcon = SearchConst.Image.circleCancelImage
        button.setImage(closeIcon, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = SearchConst.Color.circleCancelTintColor
        button.alpha = SearchConst.buttonAlphaHidden
        return button
    }()

    var cancelButtonTapObservable: Observable<Void> {
        return circleCancelButton.rx.tap.asObservable()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }
    
    private func setupLayout() {
        addSubview(circleCancelButton)
        
        circleCancelButton.snp.makeConstraints {
            $0.width.height.equalTo(SearchConst.textFieldRightView.Size.circleCancelBtnSize)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(SearchConst.textFieldRightView.Spacing.circleCancelBtnRight)
        }
    }
    
    func setCancelButtonAlpha(_ alpha: CGFloat) {
        Observable.just(alpha)
            .bind(to: circleCancelButton.rx.alpha)
            .disposed(by: disposeBag)
    }
    
    func cancelButtonTap() -> Observable<Void> {
        return circleCancelButton.rx.tap.asObservable()
    }
}
