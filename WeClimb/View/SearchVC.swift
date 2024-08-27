//
//  SearchVC.swift
//  WeClimb
//
//  Created by Soo Jang on 8/26/24.
//

import UIKit
import SnapKit

class SearchVC: UIViewController {
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "암장이름, 지역"
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setNavigationBar()
        setSearchController()
    }
    
    private func setNavigationBar() {
        let Label = UILabel()
        Label.text = "Discover"
        Label.textColor = .black
        Label.font = UIFont.systemFont(ofSize: 17)
        
        let leftBarButtonItem = UIBarButtonItem(customView: Label)
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    private func setSearchController() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false // 검색바 유지
        definesPresentationContext = false // 검색바 유지
    }
    
}

extension SearchVC : UISearchResultsUpdating {
    // MARK: - 검색 텍스트에 따라 검색 결과를 업데이트하는 메서드 - YJ
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        print("검색 텍스트: \(searchText)")
    }
}
