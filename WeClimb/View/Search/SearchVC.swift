//
//  SearchVC.swift
//  WeClimb
//
//  Created by Soo Jang on 8/26/24.
//

import UIKit

import RxSwift
import SnapKit

class SearchVC: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let searchViewModel = SearchViewModel()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = SearchNameSpace.placeholder
        return searchController
    }()
    
    private let nearbyLabel: UILabel = {
        let label = UILabel()
        label.text = SearchNameSpace.nearby
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        tableView.separatorStyle = .none // 구분선 제거
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.className)
        return tableView
    }()
    
    // 세그먼트 컨트롤 - DS
    private let segmentedControl: UISegmentedControl = {
        let items = ["암장", "유저검색"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = .systemBackground // 배경색 설정 (필요에 따라 수정 가능)
        return segmentedControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        
        setNavigationBar()
        setSearchController()
        setLayout()
        bind()
    }
    
    private func setNavigationBar() {
        self.title = SearchNameSpace.title
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    private func setSearchController() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false // 검색바 유지
        definesPresentationContext = false // 검색바 유지
    }
    
    private func setLayout() {
        [segmentedControl, nearbyLabel, tableView]
            .forEach { view.addSubview($0) }
        
        // 세그먼트 컨트롤의 위치 설정
        segmentedControl.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.leading.trailing.equalToSuperview().inset(15)
        }
        
        nearbyLabel.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(15)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(nearbyLabel.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func bind() {
        searchViewModel.data
            .bind(to: tableView.rx.items(cellIdentifier: SearchTableViewCell.className, cellType: SearchTableViewCell.self)) { index, model, cell in
                cell.configure(with: model)
            }
            .disposed(by: disposeBag)
        
        // 셀 선택 이벤트 처리
        tableView.rx.modelSelected(SearchModel.self)
            .subscribe(onNext: { [weak self] selectedGym in
                let climbingGymVC = ClimbingGymVC()
                climbingGymVC.configure(with: selectedGym)
                self?.navigationController?.pushViewController(climbingGymVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        // 세그먼트 컨트롤 선택 이벤트 처리
        segmentedControl.rx.selectedSegmentIndex
            .subscribe(onNext: { [weak self] index in
                // 선택된 세그먼트에 따라 다른 데이터를 처리하거나 UI 업데이트
                if index == 0 {
                    print("암장 탭 선택됨")
                    // 암장 관련 데이터 처리
                } else {
                    print("유저검색 탭 선택됨")
                    // 유저검색 관련 데이터 처리
                }
            })
            .disposed(by: disposeBag)
    }
}

extension SearchVC : UISearchResultsUpdating {
    // MARK: - 검색 텍스트에 따라 검색 결과를 업데이트하는 메서드 - YJ
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        print("검색 텍스트: \(searchText)")
    }
}
