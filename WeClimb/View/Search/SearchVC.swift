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
        navigationItem.title = SearchNameSpace.title
//        self.title = SearchNameSpace.title
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
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        nearbyLabel.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(nearbyLabel.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func bind() {
        searchViewModel.filteredData
//            .debug()
            .bind(to: tableView.rx.items(cellIdentifier: SearchTableViewCell.className, cellType: SearchTableViewCell.self)) { index, model, cell in
//                print("모델 데이터: \(model)")
                cell.configure(with: model)
            }
            .disposed(by: disposeBag)
        
        // 셀 선택 이벤트 처리
        tableView.rx.modelSelected(Gym.self)
            .subscribe(onNext: { [weak self] selectedItem in
                guard let self = self else { return }
                
                let segmentIndex = self.segmentedControl.selectedSegmentIndex
                
                if segmentIndex == 0 {
                    let climbingGymVC = ClimbingGymVC()
                    climbingGymVC.configure(with: selectedItem)
                    
                    navigationController?.navigationBar.prefersLargeTitles = false
                    climbingGymVC.navigation()
                    self.navigationController?.pushViewController(climbingGymVC, animated: true)
                    
                } else {
                    
                    let userPageVC = UserPageVC()
                    navigationController?.navigationBar.prefersLargeTitles = false
                    userPageVC.setNavigation()
                    self.navigationController?.pushViewController(userPageVC, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
//        // 세그먼트 컨트롤 선택 이벤트 처리
//        segmentedControl.rx.selectedSegmentIndex
//            .subscribe(onNext: { [weak self] index in
//                guard let self else { return }
//                // 선택된 세그먼트에 따라 다른 데이터를 처리하거나 UI 업데이트
//                if index == 0 {
//                    print("암장 탭 선택됨")
//                    // 암장 관련 데이터 처리
//                    self.searchViewModel.filteredData
//                        .bind(to: self.tableView.rx.items(cellIdentifier: SearchTableViewCell.className, cellType: SearchTableViewCell.self)) { index, model, cell in
//                            cell.configure(with: model)
//                        }
//                        .disposed(by: self.disposeBag)
//                } else {
//                    print("유저검색 탭 선택됨")
//                    // 유저검색 관련 데이터 처리
//                    self.searchViewModel.userFilteredData
//                        .bind(to: self.tableView.rx.items(cellIdentifier: SearchTableViewCell.className, cellType: SearchTableViewCell.self)) { index, model, cell in
//                            cell.configure(with: model)
//                        }
//                        .disposed(by: self.disposeBag)
//                }
//            })
//            .disposed(by: disposeBag)
        
        searchController.searchBar.rx.text.orEmpty
                .bind(to: searchViewModel.searchText)
                .disposed(by: disposeBag)
        
        searchController.searchBar.rx.textDidBeginEditing
            .subscribe(onNext: { [weak self] in
                // 서치바가 클릭되면 나머지 뷰들을 숨김
                UIView.animate(withDuration: 0.2, animations: {
                    self?.segmentedControl.alpha = 0.0
                    self?.nearbyLabel.alpha = 0.0
                    self?.tableView.alpha = 0.0
                })
                
                UIView.animate(withDuration: 0.6, animations: {
                    self?.segmentedControl.alpha = 1
                })
            })
            .disposed(by: disposeBag)
        
        searchController.searchBar.rx.textDidEndEditing
            .subscribe(onNext: { [weak self] in
                // 서치바에서 나갈 때 나머지 뷰들을 다시 보이게 함
                UIView.animate(withDuration: 0.2, animations: {
                    self?.nearbyLabel.alpha = 1.0
                    self?.tableView.alpha = 1.0
                })
            })
            .disposed(by: disposeBag)
    }
}
