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
    private var gymData: SearchModel?
    
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
        navigation()
        
        tableView.register(SectionTableViewCell.self, forCellReuseIdentifier: Identifiers.sectionTableViewCell)
        
    }
    
    func configure(with data: SearchModel) {
        self.gymData = data
    }
    
    // MARK: - 네비게이션 - DS
    private func navigation() {
        viewModel.onItemSelected = { [weak self] (detailItems: [DetailItem]) in
            guard let self else { return }
            
            let detailVM = ClimbingDetailGymVM(detailItems: detailItems)
            let detailVC = ClimbingDetailGymVC(viewModel: detailVM)
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    // MARK: - 액션 설정 (버튼, 세그먼트 컨트롤) - DS
    private func actions() {
        headerView.followButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            if self.headerView.followButton.title(for: .normal) == ClimbingGymNameSpace.follow {
                self.headerView.followButton.setTitle(ClimbingGymNameSpace.unFollow, for: .normal)
            } else {
                self.headerView.followButton.setTitle(ClimbingGymNameSpace.follow, for: .normal)
            }
        }, for: .touchUpInside)
        
        headerView.segmentControl.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            let selectedIndex = self.headerView.segmentControl.selectedSegmentIndex
            self.viewModel.selectedSegment.accept(selectedIndex)
            
            if selectedIndex == 1 {
                self.tableView.isHidden = true
                self.climbingGymInfoView.isHidden = false
            } else {
                self.tableView.isHidden = false
                self.climbingGymInfoView.isHidden = true
            }
        }, for: .valueChanged)
    }
    
    // MARK: - 데이터 바인딩 - DS
    private func bindSectionData() {
        viewModel.dummys
            .bind(to: tableView.rx.items(cellIdentifier: Identifiers.sectionTableViewCell, cellType: SectionTableViewCell.self)) { row, item, cell in
                // Detail Items에 대한 ViewModel 생성
                let detailVM = ClimbingDetailGymVM(detailItems: item.detailItems)
                
                // detailData의 개수를 완료된 항목 수로 설정
                let completedCount = detailVM.numberOfDetails()
                let totalCount = item.itemCount
                
                // 셀 설정
                cell.configure(with: item, completedCount: completedCount, totalCount: totalCount)
            }
            .disposed(by: disposeBag)
        
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.viewModel.itemSelected.onNext(indexPath)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - 레이아웃 설정 - DS
    private func setLayout() {
        view.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        
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
        
        climbingGymInfoView.isHidden = true
    }
}
