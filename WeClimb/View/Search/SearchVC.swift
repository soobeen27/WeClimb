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
        tableView.separatorStyle = .none // 구분선 제거
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchNameSpace.id)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
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
        [nearbyLabel, tableView]
            .forEach { view.addSubview($0) }
        
        nearbyLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(15)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(nearbyLabel.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func bind() {
        searchViewModel.data
            .bind(to: tableView.rx.items(cellIdentifier: SearchNameSpace.id, cellType: SearchTableViewCell.self)) { index, data, cell in
                cell.configure(with: data.image, title: data.title, address: data.address)
            }
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
