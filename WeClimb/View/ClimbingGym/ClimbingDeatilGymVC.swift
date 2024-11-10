////
////  ClimbingDeatilGymVC.swift
////  WeClimb
////
////  Created by 머성이 on 8/30/24.
////
//
import UIKit

import SnapKit
import RxCocoa
import RxSwift

class ClimbingDetailGymVC: UIViewController {
    
    private let viewModel: ClimbingDetailGymVM
    private let disposeBag = DisposeBag()
    
    init(viewModel: ClimbingDetailGymVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let gymNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    private let filterByHoldButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("홀드", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let filterByHeightButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("키", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let filterByArmLengthButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("팔길이", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let thumbnailCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 100, height: 150) // 셀 크기 설정
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        //        collectionView.register("셀 이름머하지".self, forCellWithReuseIdentifier: "셀 이름머하지".identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        setLayout()
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.output.gymName
            .drive(gymNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.logoImageURL
            .drive(onNext: { [weak self] url in
                guard let self = self else { return }
                FirebaseManager.shared.loadImage(from: url.absoluteString, into: self.logoImageView)
            })
            .disposed(by: disposeBag)
        
//        viewModel.output.problemThumbnails
//            .drive(thumbnailCollectionView.rx.items) { collectionView, row, url in
//                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThumbnailCell", for: IndexPath(row: row, section: 0)) as! ThumbnailCell
//                FirebaseManager.shared.loadImage(from: url.absoluteString, into: cell.imageView)
//                return cell
//            }
//            .disposed(by: disposeBag)
    }
    
    private func setLayout() {
        [
            logoImageView,
            gymNameLabel,
            filterByHoldButton,
            filterByHeightButton,
            filterByArmLengthButton,
            thumbnailCollectionView,
        ].forEach { view.addSubview($0) }
        
        logoImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.width.height.equalTo(80)
        }
        
        gymNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(logoImageView)
            $0.leading.equalTo(logoImageView.snp.trailing).offset(10)
            $0.trailing.lessThanOrEqualToSuperview().offset(-16)
        }
        
        filterByArmLengthButton.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(10)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(24)
            $0.width.equalTo(48)
        }
        
        filterByHeightButton.snp.makeConstraints {
            $0.centerY.equalTo(filterByArmLengthButton)
            $0.trailing.equalTo(filterByArmLengthButton.snp.leading).offset(-10)
            $0.height.equalTo(24)
            $0.width.equalTo(32)
        }
        
        filterByHoldButton.snp.makeConstraints {
            $0.centerY.equalTo(filterByArmLengthButton)
            $0.trailing.equalTo(filterByHeightButton.snp.leading).offset(-10)
            $0.height.equalTo(24)
            $0.width.equalTo(40)
        }
        
        thumbnailCollectionView.snp.makeConstraints {
            $0.top.equalTo(filterByArmLengthButton.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
