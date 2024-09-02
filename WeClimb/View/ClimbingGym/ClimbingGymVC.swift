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
    
    // MARK: - 공통 헤더 뷰 - DS
    private let headerView = GymHeaderView()
    
    // MARK: - 테이블 뷰 구성 - DS
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.lightGray
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 10
        tableView.separatorStyle = .singleLine // 기본 구분선 스타일
        tableView.separatorColor = .black // 구분선 색상
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15) // 좌우 여백
        
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
    
    // MARK: - 네비게이션 - DS
    private func navigation() {
        viewModel.onItemSelected = { [weak self] (detailItems: [DetailItem]) in  // 타입 명시
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
            if self.headerView.followButton.title(for: .normal) == UploadNameSpace.follow {
                self.headerView.followButton.setTitle(UploadNameSpace.unFollow, for: .normal)
            } else {
                self.headerView.followButton.setTitle(UploadNameSpace.follow, for: .normal)
            }
        }, for: .touchUpInside)
        
        headerView.segmentControl.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            self.viewModel.selectedSegment.accept(self.headerView.segmentControl.selectedSegmentIndex)
        }, for: .valueChanged)
    }
    
    // MARK: - 데이터 바인딩 - DS
    private func bindSectionData() {
        viewModel.dummys
            .bind(to: tableView.rx.items(cellIdentifier: Identifiers.sectionTableViewCell, cellType: UITableViewCell.self)) { row, item, cell in
                cell.textLabel?.text = item.name
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
            tableView
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
    }
}
