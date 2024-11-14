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
    
    private let gradeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    private let gradeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    private let gradeColorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        view.clipsToBounds = true
        view.backgroundColor = .clear
        return view
    }()
    
    private let filterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("  필터", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 12)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .regular)
        let symbolImage = UIImage(systemName: "line.3.horizontal.decrease.circle", withConfiguration: symbolConfig)
        button.setImage(symbolImage, for: .normal)
        button.tintColor = .label
        
        return button
    }()
    
    private let thumbnailCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 100, height: 150) // 셀 크기 설정
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ThumbnailCell.self, forCellWithReuseIdentifier: ThumbnailCell.className)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        setLayout()
        bindViewModel()
        setupActions()
    }
    
    private func bindViewModel() {
        viewModel.output.gymName
            .drive(gymNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.logoImageURL
            .drive(onNext: { [weak self] url in
                guard let self else { return }
                FirebaseManager.shared.loadImage(from: url.absoluteString, into: self.logoImageView)
            })
            .disposed(by: disposeBag)
        
        // 썸네일 컬렉션 뷰 바인딩
        viewModel.output.problemThumbnails
            .drive(thumbnailCollectionView.rx.items(cellIdentifier: ThumbnailCell.className, cellType: ThumbnailCell.self)) { index, url, cell in
                cell.configure(with: url.absoluteString)
            }
            .disposed(by: disposeBag)
        
    }
    
    private func setLayout() {
        [
            logoImageView,
            gymNameLabel,
            gradeTitleLabel,
            gradeLabel,
            gradeColorView,
            filterButton,
            thumbnailCollectionView,
        ].forEach { view.addSubview($0) }
        
        logoImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.width.height.equalTo(80)
        }
        
        gymNameLabel.snp.makeConstraints {
            $0.top.equalTo(logoImageView).offset(16)
            $0.leading.equalTo(logoImageView.snp.trailing).offset(10)
            $0.trailing.lessThanOrEqualToSuperview().offset(-16)
        }
        
        gradeTitleLabel.snp.makeConstraints {
            $0.top.equalTo(gymNameLabel.snp.bottom).offset(8)
            $0.leading.equalTo(gymNameLabel)
        }
        
        gradeLabel.snp.makeConstraints {
            $0.centerY.equalTo(gradeTitleLabel)
            $0.leading.equalTo(gradeTitleLabel.snp.trailing).offset(4)
        }
        
        gradeColorView.snp.makeConstraints {
            $0.centerY.equalTo(gradeTitleLabel)
            $0.leading.equalTo(gradeTitleLabel.snp.trailing).offset(4)
            $0.width.height.equalTo(14)
        }
        
        filterButton.snp.makeConstraints {
            $0.top.equalTo(gradeColorView.snp.bottom).offset(24)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(24)
            $0.width.equalTo(64)
        }
        
        thumbnailCollectionView.snp.makeConstraints {
            $0.top.equalTo(filterButton.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupActions() {
        filterButton.rx.tap
            .bind { [weak self] in
                guard let self else { return }
                let climbingFilterVC = ClimbingFilterVC()
                self.presentCustomHeightModal(modalVC: climbingFilterVC, heightRatio: 0.69)
            }
            .disposed(by: disposeBag)
    }
    
    func configure(with gymName: String, grade: String) {
        gymNameLabel.text = gymName
        gradeTitleLabel.text = "난이도 "
        
        // 난이도에 따라 색상 설정
        let colorInfo = grade.colorInfo
        let convertedGrade = grade.colorTextChange()
        if grade.colorInfo.color != .clear {
            gradeColorView.backgroundColor = grade.colorInfo.color
            gradeLabel.isHidden = true
        } else {
            gradeColorView.backgroundColor = .clear
            gradeLabel.isHidden = false
            gradeLabel.text = convertedGrade
        }
    }
}
