//
//  GuestMyPageVC.swift
//  WeClimb
//
//  Created by 김솔비 on 9/25/24.
//

import UIKit

import SnapKit
import RxSwift

class GuestVC: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .systemGray3
        label.text = "로그인 후 이용해주세요"
        label.textAlignment = .center
        return label
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인 하러가기", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "MainColor")
        button.layer.cornerRadius = 10
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        bind()
    }
    
    private func loginButtonTapped() {
        let loginVC = LoginVC()
        loginVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    private func bind() {
        loginButton.rx.tap
            .bind { [weak self] in
                self?.loginButtonTapped()
            }
            .disposed(by: disposeBag)
    }
    
    
    private func setLayout() {
        view.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        [infoLabel, loginButton]
            .forEach {
                view.addSubview($0)
            }
        
        infoLabel.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 250, height: 50))
            $0.top.equalToSuperview().inset(350)
            $0.centerX.equalToSuperview()
        }
        loginButton.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 150, height: 40))
            $0.top.equalTo(infoLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
    }
}
