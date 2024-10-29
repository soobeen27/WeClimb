//
//  SearchVC.swift
//  WeClimb
//
//  Created by Soo Jang on 8/26/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

class SearchVC: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let searchViewModel = SearchViewModel()
    
    private var lastSearchText: String = ""
    private var lastSegmentIndex: Int = 0
    
    var onSelectedGym: ((Gym) -> Void)?
    
    var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = SearchNameSpace.placeholder
        return searchController
    }()
    
    // 내 주변 암장 표시
    //    private let nearbyLabel: UILabel = {
    //        let label = UILabel()
    //        label.text = " " //SearchNameSpace.nearby
    //        label.textAlignment = .left
    //        label.font = UIFont.systemFont(ofSize: 13)
    //        return label
    //    }()
    
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
    
    // MARK: - 뷰 라이프 사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setSearchController()
        setLayout()
        bind()
        setupKeyboardDismissOnScroll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchController.isActive = true
        // 검색어와 세그먼트 상태 복원
        searchController.searchBar.text = lastSearchText
        segmentedControl.selectedSegmentIndex = lastSegmentIndex
        searchViewModel.isSelectGym.accept(lastSegmentIndex == 0)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 검색어와 세그먼트 상태 저장
        lastSearchText = searchController.searchBar.text ?? ""
        lastSegmentIndex = segmentedControl.selectedSegmentIndex
        
        searchController.isActive = false
    }
    
    // MARK: - 바인딩 설정
    private func bind() {
        bindSegmentControl()
        bindGymTableViewSelection()
        bindUserTableViewSelection()
        bindSearchBar()
        bindGymData()
        bindUserData()
    }
    
    func setupKeyboardDismissOnScroll() {
        gymTableView.rx.willBeginDragging
            .subscribe(onNext: { [weak self] _ in
                // 키보드가 활성화된 상태에서만 키보드를 숨김
                if self?.searchController.searchBar.isFirstResponder == true {
                    self?.searchController.searchBar.resignFirstResponder()
                }
            })
            .disposed(by: disposeBag)
        
        userTableView.rx.willBeginDragging
            .subscribe(onNext: { [weak self] _ in
                if self?.searchController.searchBar.isFirstResponder == true {
                    self?.searchController.searchBar.resignFirstResponder()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setNavigationBar() {
        // 네비게이션 타이틀 설정
        navigationItem.title = SearchNameSpace.title
        
        // 탭바 빈 문자열로 설정
        if let tabBarItem = self.tabBarItem {
            tabBarItem.title = ""
        }
        
        // Large Titles 비활성화 및 작은 타이틀 설정
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func setSearchController() {
        navigationItem.searchController = searchController
        
        // 검색 바가 숨겨지지 않도록 설정
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = false
    }
    
    private func setLayout() {
        view.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        
        [segmentedControl, gymTableView, userTableView]
            .forEach { view.addSubview($0) }
        
        // 상황에 따라 세그먼트 컨트롤의 위치 변경
        segmentedControl.snp.makeConstraints {
            if ShowSegment {
                $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
                $0.leading.trailing.equalToSuperview().inset(16)
            } else {
                $0.top.equalTo(view.safeAreaLayoutGuide)
                $0.leading.trailing.equalToSuperview().inset(16)
                $0.height.equalTo(0)
            }
        }
        
        //        nearbyLabel.snp.makeConstraints {
        //            $0.top.equalTo(segmentedControl.snp.bottom).offset(10)
        //            $0.leading.trailing.equalToSuperview().inset(16)
        //        }
        
        gymTableView.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        userTableView.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    // MARK: - Segment Control 바인딩
    private func bindSegmentControl() {
        // 세그먼트 선택 상태 초기화
        searchViewModel.isSelectGym.accept(lastSegmentIndex == 0)
        
        // Segmented Control 선택 이벤트 처리
        segmentedControl.rx.selectedSegmentIndex
            .subscribe(onNext: { [weak self] index in
                guard let self = self else { return }
                self.searchViewModel.isSelectGym.accept(index == 0)
            })
            .disposed(by: disposeBag)
        
        // Gym/User TableView 선택 바인딩
        searchViewModel.isSelectGym
            .bind { [weak self] isSelectGym in
                self?.gymTableView.isHidden = !isSelectGym
                self?.userTableView.isHidden = isSelectGym
            }.disposed(by: disposeBag)
    }
    
    // MARK: - TableView 선택 이벤트 바인딩 (Gym)
    private func bindGymTableViewSelection() {
        gymTableView.rx.modelSelected(Gym.self)
            .subscribe(onNext: { [weak self] selectedItem in
                guard let self = self else { return }
                
                self.onSelectedGym?(selectedItem)
                
                if self.nextPush {
                    let climbingGymVC = ClimbingGymVC()
                    climbingGymVC.configure(with: selectedItem)
                    
                    self.navigationController?.navigationBar.prefersLargeTitles = false
                    self.navigationController?.pushViewController(climbingGymVC, animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - TableView 선택 이벤트 바인딩 (User)
    private func bindUserTableViewSelection() {
        userTableView.rx.modelSelected(User.self)
            .subscribe(onNext: { [weak self] selectedItem in
                guard let self = self else { return }
                
                // 선택한 유저의 인덱스 가져오기
                guard let selectedIndex = self.userTableView.indexPathForSelectedRow?.row,
                      let userUID = self.searchViewModel.getUserUID(at: selectedIndex) else {
                    print("유저 UID를 가져올 수 없습니다.")
                    return
                }
                
//                let userPageVC = UserPageVC()
//                userPageVC.configure(with: selectedItem)
//                userPageVC.userUID = userUID
                let userPageVM = UserPageVM()
                userPageVM.fetchUserInfo(userName: selectedItem.userName ?? "이름 찾을 수 없음")
                
                let userPageVC = UserPageVC(viewModel: userPageVM)
                
                self.navigationController?.navigationBar.prefersLargeTitles = false
                self.navigationController?.pushViewController(userPageVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - SearchBar 검색 텍스트 변경 처리
    private func bindSearchBar() {
        // 검색바 텍스트 바인딩
        searchController.searchBar.rx.text.orEmpty
            .bind(to: searchViewModel.searchText)
            .disposed(by: disposeBag)
        
        // SearchBar 텍스트 변경에 따라 유저 검색 실행
        searchViewModel.searchText
            .distinctUntilChanged()
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .filter { !$0.isEmpty }
            .subscribe(onNext: { [weak self] query in
                guard let self = self else { return }
                self.searchViewModel.fetchSearchUsers()  // 검색어에 맞는 유저 검색 실행
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - TableView 데이터 바인딩 (Gym)
    private func bindGymData() {
        searchViewModel.filteredData
            .bind(to: gymTableView.rx.items(cellIdentifier: GymTableViewCell.className, cellType: GymTableViewCell.self)) { index, model, cell in
                cell.configure(with: model)
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - TableView 데이터 바인딩 (User)
    private func bindUserData() {
        searchViewModel.userFilteredData
            .bind(to: userTableView.rx.items(cellIdentifier: UserTableViewCell.className, cellType: UserTableViewCell.self)) { index, model, cell in
                cell.configure(with: model)
            }
            .disposed(by: disposeBag)
    }
}
