//
//  profileImageFullScreen.swift
//  WeClimb
//
//  Created by 김솔비 on 11/15/24.
//


import UIKit

import SnapKit

class ProfileImageFullScreen: UIViewController {
    
    private let imageView: UIImageView
    
    init(image: UIImage) {
        self.imageView = UIImageView(image: image)
        super.init(nibName: nil, bundle: nil)
        setupImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupImageView() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        setTapGesture()
        
    }
    private func setLayout() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        view.addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(340)
            $0.center.equalToSuperview()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("imageView frame size: \(imageView.frame.size)")
        
        // 레이아웃이 완료된 후 원형으로 만듦
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
    }
    
    private func setTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreen))
        imageView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissFullscreen() {
        dismiss(animated: true, completion: nil)
    }
}

//import UIKit
//
//import RxSwift
//
//
//class ProfileImageFullScreen: UIViewController {
//
//    private let disposeBag = DisposeBag()
//    private let fullscreenImageView: UIImageView
//    private let dimmedBackgroundView = UIView() // 반투명 배경 뷰
//
//    init(image: UIImage) {
//        self.fullscreenImageView = UIImageView(image: image)
//        super.init(nibName: nil, bundle: nil)
//        setupFullscreenImageView()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func setupFullscreenImageView() {
//        fullscreenImageView.contentMode = .scaleAspectFit
//        //        fullscreenImageView.backgroundColor = .black
//        fullscreenImageView.isUserInteractionEnabled = true
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        setLayout()
//        setupDismissGesture()
//        dismissFullscreenImage()
//    }
//
//    private func setLayout() {
//        dimmedBackgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.7) // 불투명도 70%
//        view.addSubview(dimmedBackgroundView)
//        dimmedBackgroundView.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//        }
//
//        // 전체 화면에 맞게 레이아웃 설정
//        view.addSubview(fullscreenImageView)
//        fullscreenImageView.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//        }
//    }
//
//    // RxGesture로 닫기 제스처 처리
//    private func setupDismissGesture() {
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
//        fullscreenImageView.addGestureRecognizer(tapGesture)
//        fullscreenImageView.isUserInteractionEnabled = true // 제스처를 사용하기 위해 필요
//    }
//
//    @objc
//    private func dismissFullscreenImage() {
//        dismiss(animated: true, completion: nil)
//    }
//}

