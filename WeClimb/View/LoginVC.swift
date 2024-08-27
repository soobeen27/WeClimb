//
//  LoginVC.swift
//  WeClimb
//
//  Created by Soo Jang on 8/26/24.
//

import UIKit

import SnapKit
import RxCocoa
import RxSwift

class LoginVC: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.backgroundColor = .purple
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loaded")
        setLayout()
        buttonTapped()
    }
    
    private func buttonTapped() {
        loginButton.rx.tap
            .bind { [weak self] in
                self?.navigationController?.pushViewController(TabBarController(), animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func setLayout() {
        view.backgroundColor = .systemBackground
        [loginButton]
            .forEach {
                view.addSubview($0)
            }
        
        loginButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(CGSize(width: 100, height: 100))
        }
    }

}
