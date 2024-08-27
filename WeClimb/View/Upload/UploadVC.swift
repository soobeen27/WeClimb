//
//  UploadVC.swift
//  WeClimb
//
//  Created by Soo Jang on 8/26/24.
//

import AVKit
import Photos
import UIKit

import SnapKit
import RxCocoa
import RxSwift

class UploadVC: UIViewController {
        
    private lazy var viewModel: UploadVM = {
        return UploadVM()
    }()
    
    private let disposeBag = DisposeBag()
    
    private let selectedMediaView: UIView = {
        let view = UIView()
        
        return view
    }()
    private let albumButton: UIButton = {
        let button = UIButton()
        button.setTitle("Album Test Name", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        button.setTitleColor(.label, for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        albumButtonTap()
    }
    
    func albumButtonTap() {
        albumButton.rx.tap
            .bind { [weak self] in
                guard let self else { return }
                self.present(SelectAlbumVC(), animated: true)
            }.disposed(by: disposeBag)
    }
    
    private func setLayout() {
        view.backgroundColor = .systemBackground
        [selectedMediaView, albumButton]
            .forEach {
                view.addSubview($0)
            }
        selectedMediaView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(view.frame.width)
        }
        
        albumButton.snp.makeConstraints {
            $0.top.equalTo(selectedMediaView.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(8)
        }
        
    }
}
