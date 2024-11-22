//
//  ClimbingDeatilGymVC.swift
//  WeClimb
//
//  Created by 머성이 on 8/30/24.
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
        
        layout.minimumInteritemSpacing = 1.0
        layout.minimumLineSpacing = 1.0
        
        let width = (UIScreen.main.bounds.width - 2 * 16 - 2 * 1.0) / 3
        layout.itemSize = CGSize(width: width, height: width * 1.5)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(ThumbnailCell.self, forCellWithReuseIdentifier: ThumbnailCell.className)
        return collectionView
    }()
    
    private let emptyPost: UIView = {
        let view = UIView()
        view.isHidden = false
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "no_Post") // 비어 있을 때 보여줄 이미지
        
        let label = UILabel()
        label.text = "게시물이 없습니다."
        label.textColor = .gray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13)
        
        [imageView, label]
            .forEach { view.addSubview($0) }
        
        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-20)
            $0.width.height.equalTo(120)
        }
        
        label.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        setLayout()
        bindViewModel()
        setupActions()
    }
    
    private func bindViewModel() {
        viewModel.gymNameRelay
            .asDriver()
            .drive(gymNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.logoImageURLRelay
            .compactMap { $0 }
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { [weak self] url in
                guard let self = self else { return }
                FirebaseManager.shared.loadImage(from: url.absoluteString, into: self.logoImageView)
            })
            .disposed(by: disposeBag)
        
        viewModel.postRelay
            .asObservable()
            .subscribe(onNext: { [weak self] posts in
                guard let self = self else { return }
                
                if posts.isEmpty {
                    self.emptyPost.isHidden = false
                    self.thumbnailCollectionView.isHidden = true
                } else {
                    self.emptyPost.isHidden = true
                    self.thumbnailCollectionView.isHidden = false
                }
            })
            .disposed(by: disposeBag)

        viewModel.postRelay
            .asDriver(onErrorJustReturn: [])
            .drive(thumbnailCollectionView.rx.items(
                cellIdentifier: ThumbnailCell.className,
                cellType: ThumbnailCell.self
            )) { index, post, cell in
                if let thumbnailURL = post.thumbnail {
                    cell.configure(with: thumbnailURL)
                }
            }
            .disposed(by: disposeBag)
        
        thumbnailCollectionView.rx.itemSelected
            .withLatestFrom(viewModel.postRelay) { indexPath, posts in
                return (indexPath, posts)
            }
            .subscribe(onNext: { [weak self] indexPath, posts in
                guard let self = self else { return }
                
                let startingIndex = indexPath.row

                let mainFeedVM = MainFeedVM()
                mainFeedVM.posts.accept(posts)
                
                // MainFeedVC로 화면 전환
                let mainFeedVC = SFMainFeedVC(viewModel: mainFeedVM, startingIndex: startingIndex, feedType: .filterPage)
                self.navigationController?.pushViewController(mainFeedVC, animated: true)
            })
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
            emptyPost,
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
        
        emptyPost.snp.makeConstraints {
            $0.edges.equalTo(thumbnailCollectionView)
        }
    }
    
    private func setupActions() {
        filterButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                
                let currentFilter = self.viewModel.getCurrentFilterConditions()
                let climbingFilterVC = ClimbingFilterVC(
                    gymName: self.viewModel.gym.gymName,
                    grade: self.viewModel.grade,
                    initialFilterConditions: currentFilter
                )
                
                climbingFilterVC.filterConditionsRelay
                    .subscribe(onNext: { [weak self] newConditions in
                        guard let self = self else { return }
                        self.viewModel.updateFilterConditions(newConditions)
                        self.viewModel.applyFilters(filterConditions: newConditions)
                    })
                    .disposed(by: self.disposeBag)
                
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
