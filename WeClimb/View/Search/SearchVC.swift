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
    
    var onSelectedGym: ((Gym) -> Void)?
    
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
    
    private let gymTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        tableView.separatorStyle = .none // 구분선 제거
        tableView.register(GymTableViewCell.self, forCellReuseIdentifier: GymTableViewCell.className)
        return tableView
    }()
    
    private let userTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        tableView.separatorStyle = .none // 구분선 제거
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.className)
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
    
    var ShowSegment: Bool = true {
        didSet {
            segmentedControl.isHidden = !ShowSegment
        }
    }
    var nextPush: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        
        setNavigationBar()
        setSearchController()
        setLayout()
        bind()
    }
    
    private func setNavigationBar() {
//        navigationItem.title = SearchNameSpace.title
        self.title = SearchNameSpace.title
        
        // 탭바 빈 문자열로 설정
        if let tabBarItem = self.tabBarItem {
            tabBarItem.title = ""
        }
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    private func setSearchController() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false // 검색바 유지
        definesPresentationContext = false // 검색바 유지
    }
    
    private func setLayout() {
        [segmentedControl, nearbyLabel, gymTableView, userTableView]
            .forEach { view.addSubview($0) }
        
        // 상황에 따라 세그먼트 컨트롤의 위치 변경
        segmentedControl.snp.remakeConstraints {
            if ShowSegment {
                $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
                $0.leading.trailing.equalToSuperview().inset(16)
            } else {
                $0.top.equalTo(view.safeAreaLayoutGuide)
                $0.leading.trailing.equalToSuperview().inset(16)
                $0.height.equalTo(0) 
            }
        }
        
        nearbyLabel.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        gymTableView.snp.makeConstraints {
            $0.top.equalTo(nearbyLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        userTableView.snp.makeConstraints {
            $0.top.equalTo(nearbyLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func bind() {
        // MARK: - Gym TableView 선택 이벤트 처리 - DS
        gymTableView.rx.modelSelected(Gym.self)
            .subscribe(onNext: { [weak self] selectedItem in
                guard let self else { return }
                    
                self.onSelectedGym?(selectedItem)
                
                if self.nextPush {
                    let climbingGymVC = ClimbingGymVC()
                    climbingGymVC.configure(with: selectedItem)
                    
                    navigationController?.navigationBar.prefersLargeTitles = false
                    climbingGymVC.navigation()
                    self.navigationController?.pushViewController(climbingGymVC, animated: true)
                }
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        // MARK: - User TableView 선택 이벤트 처리 - DS
        userTableView.rx.modelSelected(User.self)
            .subscribe(onNext: { [weak self] selectedItem in
                guard let self else { return }
                let userPageVC = UserPageVC()
                userPageVC.configure(with: selectedItem)
                navigationController?.navigationBar.prefersLargeTitles = false
                userPageVC.setNavigation()
                self.navigationController?.pushViewController(userPageVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        // MARK: - Gym Data 바인딩 - DS
        searchViewModel.filteredData
            .bind(to: gymTableView.rx.items(cellIdentifier: GymTableViewCell.className, cellType: GymTableViewCell.self)) { index, model, cell in
                cell.configure(with: model)
            }
            .disposed(by: disposeBag)
        
        // MARK: - User Data 바인딩 - DS
        searchViewModel.userFilteredData
            .bind(to: userTableView.rx.items(cellIdentifier: UserTableViewCell.className, cellType: UserTableViewCell.self)) { index, model, cell in
                cell.configure(with: model)
            }
            .disposed(by: disposeBag)
        
        // MARK: - Gym/User TableView 선택 바인딩 - DS
        searchViewModel.isSelectGym
            .bind { [weak self] isSelectGym in
                self?.gymTableView.isHidden = !isSelectGym
                self?.userTableView.isHidden = isSelectGym
            }.disposed(by: disposeBag)
        
        // MARK: - Segmented Control 선택 이벤트 처리 - DS
        segmentedControl.rx.selectedSegmentIndex
            .subscribe { [weak self] index in
                self?.searchViewModel.isSelectGym.accept(index == 0)
            }.disposed(by: disposeBag)
        
        // MARK: - SearchBar 텍스트 바인딩 - YJ
        searchController.searchBar.rx.text.orEmpty
                .bind(to: searchViewModel.searchText)
                .disposed(by: disposeBag)
        
        // MARK: - SearchBar 텍스트 입력 시작 및 종료 이벤트 처리 - YJ
        searchController.searchBar.rx.textDidBeginEditing
            .subscribe(onNext: { [weak self] in
                // 서치바가 클릭되면 나머지 뷰들을 숨김
                UIView.animate(withDuration: 0.2, animations: {
                    self?.segmentedControl.alpha = 0.0
                    self?.nearbyLabel.alpha = 0.0
//                    self?.gymTableView.alpha = 0.0
//                    self?.userTableView.alpha = 0.0
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
//                    self?.gymTableView.alpha = 1.0
//                    self?.userTableView.alpha = 1.0
                })
            })
            .disposed(by: disposeBag)
    }
}
