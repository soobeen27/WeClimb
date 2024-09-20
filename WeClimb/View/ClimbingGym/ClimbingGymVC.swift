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
    
    // MARK: - 테이블 뷰 구성 - DS
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 10
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.label.withAlphaComponent(0.2)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        tableView.rowHeight = 120
        
        return tableView
    }()
    
    // MARK: - 라이프사이클 - DS
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        bindSectionData()
        actions()
//        navigation()
        
        tableView.register(SectionTableViewCell.self, forCellReuseIdentifier: Identifiers.sectionTableViewCell)
        
    }
    
    func configure(with gym: Gym) {
        viewModel.setGymInfo(gymName: gym.gymName)
//        headerView.configure(with: gym)
//        climbingGymInfoView.configure(with: gym)
    }
    
    // MARK: - 네비게이션 - DS
    func navigation() {
        viewModel.onItemSelected = { [weak self] (detailItems: [DetailItem]) in
            guard let self else { return }
            
            let detailVM = ClimbingDetailGymVM(detailItems: detailItems)
            let detailVC = ClimbingDetailGymVC(viewModel: detailVM)
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    // MARK: - 데이터 바인딩 - DS
    private func bindSectionData() {
        // gymData와 바인딩하여 UI 업데이트
               viewModel.gymData
                   .compactMap { $0 } // nil이 아닐 때만 처리
                   .observe(on: MainScheduler.instance)
                   .subscribe(onNext: { [weak self] gym in
                       guard let self = self else { return }
                       // Gym 데이터를 헤더와 정보 뷰에 설정
                       self.headerView.configure(with: gym)
//                       self.climbingGymInfoView.configure(with: gym)
                   })
                   .disposed(by: disposeBag)
               
               // isDataLoaded 상태에 따라 UI 초기화
               viewModel.isDataLoaded
                   .filter { $0 } // true일 때만 실행
                   .observe(on: MainScheduler.instance)
                   .subscribe(onNext: { [weak self] _ in
                       guard let self = self else { return }
                       // 데이터 로딩 후 초기 UI 설정
                       self.setupInitialUI()
                   })
                   .disposed(by: disposeBag)
           // ViewModel의 items와 테이블 뷰 바인딩
           viewModel.items
            .bind(to: tableView.rx.items(cellIdentifier: SectionTableViewCell.className, cellType: SectionTableViewCell.self)) { row, item, cell in
                   cell.configure(with: item, completedCount: 0, totalCount: 0)
               }
               .disposed(by: disposeBag)
           
           // 테이블 뷰의 아이템 선택을 ViewModel의 itemSelected로 전달
           tableView.rx.itemSelected
               .bind(to: viewModel.itemSelected)
               .disposed(by: disposeBag)
    }
    
    // 초기 UI 설정 메서드
        private func setupInitialUI() {
            let initialSegmentIndex = viewModel.selectedSegment.value
            headerView.segmentControl.selectedSegmentIndex = initialSegmentIndex
            updateSegmentControlUI(selectedIndex: initialSegmentIndex)
        }
    
    // Segment Control 선택 인덱스에 따른 UI 업데이트
        private func updateSegmentControlUI(selectedIndex: Int) {
            if selectedIndex == 1 {
                tableView.isHidden = true
                climbingGymInfoView.isHidden = false
            } else {
                tableView.isHidden = false
                climbingGymInfoView.isHidden = true
            }
        }
    
    // MARK: - 세그먼트 컨트롤 및 버튼 액션 설정 - DS
        private func actions() {
            headerView.followButton.addAction(UIAction { [weak self] _ in
                guard let self = self else { return }
                
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
            
            // 세그먼트 컨트롤 값 변경 액션 설정
            headerView.segmentControl.addAction(UIAction { [weak self] _ in
                guard let self = self else { return }
                
                let selectedIndex = self.headerView.segmentControl.selectedSegmentIndex
                self.viewModel.selectedSegment.accept(selectedIndex)
                
                // 세그먼트 선택에 따른 UI 업데이트
                self.updateSegmentControlUI(selectedIndex: selectedIndex)
            }, for: .valueChanged)
        }
    
    // MARK: - 레이아웃 설정 - DS
    private func setLayout() {
        view.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        climbingGymInfoView.isHidden = true
        
        [
            headerView,
            tableView,
            climbingGymInfoView
        ].forEach { view.addSubview($0) }
        
        headerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview()
        }
        
        climbingGymInfoView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-16)
        }
    }
}
