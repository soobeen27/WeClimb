//
//  ClimbingGymVC.swift
//  WeClimb
//
//  Created by Soo Jang on 8/26/24.
//

import UIKit

import SnapKit
import RxCocoa
import RxSwift

class ClimbingGymVC: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel = ClimbingGymVM()
    private let climbingGymInfoView = ClimbingGymInfoView()
    private var gymData: Gym?
    
    // MARK: - 공통 헤더 뷰 - DS
    private let headerView = GymHeaderView()
    
    // MARK: - 컬렉션 뷰 구성 - DS
    lazy var difficultyCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let itemsPerRow: CGFloat = 3
        let horizontalInsets: CGFloat = 32
        let itemSpacing: CGFloat = 16
        
        let totalSpacing = horizontalInsets + ((itemsPerRow - 1) * itemSpacing)
        let width = (UIScreen.main.bounds.width - totalSpacing) / itemsPerRow
        
        layout.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        layout.minimumLineSpacing = itemSpacing
        layout.minimumInteritemSpacing = itemSpacing
        layout.itemSize = CGSize(width: width, height: width)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    // MARK: - 라이프사이클 - DS
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        bindSectionData()
        actions()

        difficultyCollectionView.register(DifficultyCollectionViewCell.self, forCellWithReuseIdentifier: DifficultyCollectionViewCell.className)
    }
    
    func configure(with gym: Gym) {
        viewModel.setGymInfo(gymName: gym.gymName)
        climbingGymInfoView.viewModel = viewModel
    }
    
    // MARK: - 데이터 바인딩 - DS
    private func bindSectionData() {
        viewModel.gymData
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] gym in
                guard let self else { return }
                self.headerView.configure(with: gym)
            })
            .disposed(by: disposeBag)
        
        viewModel.isDataLoaded
            .filter { $0 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self else { return }
                self.setupInitialUI()
            })
            .disposed(by: disposeBag)
        
        viewModel.items
            .bind(to: difficultyCollectionView.rx.items(cellIdentifier: DifficultyCollectionViewCell.className, cellType: DifficultyCollectionViewCell.self)) { row, item, cell in
                let gradeColor = item
                
                if let logoImage = UIImage(named: "LogoOrange") {
                    cell.configure(with: gradeColor, holdImage: logoImage)
                }
            }
            .disposed(by: disposeBag)
        
        difficultyCollectionView.rx.itemSelected
            .bind(to: viewModel.itemSelected)
            .disposed(by: disposeBag)
    }
    
        private func setupInitialUI() {
            let initialSegmentIndex = viewModel.selectedSegment.value
            headerView.segmentControl.selectedSegmentIndex = initialSegmentIndex
            updateSegmentControlUI(selectedIndex: initialSegmentIndex)
        }
    
    private func updateSegmentControlUI(selectedIndex: Int) {
        if selectedIndex == 1 {
            difficultyCollectionView.isHidden = true
            climbingGymInfoView.isHidden = false
        } else {
            difficultyCollectionView.isHidden = false
            climbingGymInfoView.isHidden = true
        }
    }
    
    // MARK: - 세그먼트 컨트롤 및 버튼 액션 설정 - DS
    private func actions() {
        headerView.followButton.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            self.headerView.followButton.isHidden = true
            if self.headerView.followButton.title(for: .normal) == ClimbingGymNameSpace.follow {
                self.headerView.followButton.setTitle(ClimbingGymNameSpace.unFollow, for: .normal)
                self.headerView.followButton.backgroundColor = .lightGray
                self.headerView.followButton.setTitleColor(.black, for: .normal)
                ClimbingGymNameSpace.totalFollow += 1
            } else {
                self.headerView.followButton.setTitle(ClimbingGymNameSpace.follow, for: .normal)
                self.headerView.followButton.backgroundColor = .mainPurple
                self.headerView.followButton.setTitleColor(.white, for: .normal)
                if ClimbingGymNameSpace.totalFollow > 0 {
                    ClimbingGymNameSpace.totalFollow -= 1
                }
            }
            self.headerView.updateFollowersCount(ClimbingGymNameSpace.follower)
        }, for: .touchUpInside)
        
        headerView.segmentControl.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            
            let selectedIndex = self.headerView.segmentControl.selectedSegmentIndex
            self.viewModel.selectedSegment.accept(selectedIndex)
            
            self.updateSegmentControlUI(selectedIndex: selectedIndex)
        }, for: .valueChanged)
    }
    
    // MARK: - 레이아웃 설정 - DS
    private func setLayout() {
        view.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        climbingGymInfoView.isHidden = true
        
        [
            headerView,
            difficultyCollectionView,
            climbingGymInfoView
        ].forEach { view.addSubview($0) }
        
        headerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        difficultyCollectionView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        climbingGymInfoView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-16)
        }
    }
}
