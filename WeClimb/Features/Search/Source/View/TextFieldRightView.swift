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

class TextFieldRightView: UIView {
    
    private let disposeBag = DisposeBag()
    
    private let smallCancelButton: UIButton = {
        let button = UIButton(type: .system)
        let closeIcon = UIImage(named: "closeIcon.circle")?.withRenderingMode(.alwaysTemplate)
        button.setImage(closeIcon, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .labelAssistive
        button.alpha = 0
        return button
    }()

    var cancelButtonTapObservable: Observable<Void> {
        return smallCancelButton.rx.tap.asObservable()
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
        addSubview(smallCancelButton)
        
        smallCancelButton.snp.makeConstraints { make in
            make.width.height.equalTo(16)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(12)
        }
    }
    
    func setCancelButtonAlpha(_ alpha: CGFloat) {
        Observable.just(alpha)
            .bind(to: smallCancelButton.rx.alpha)
            .disposed(by: disposeBag)
    }
    
     func cancelButtonTap() -> Observable<Void> {
         return smallCancelButton.rx.tap.asObservable()
     }
}
