//
//  SearchVC.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//

import UIKit

import SnapKit

import RxSwift
import RxCocoa

enum ItemType {
    case gym
    case user
}

struct Item {
    var type: ItemType
    var name: String
    var imageName: String
    var location: String?
    var height: Double?
}

class SearchVC: UIViewController, UISearchBarDelegate {
    var coordinator: SearchCoordinator?
    
    private let disposeBag = DisposeBag()
    
    private var items = BehaviorRelay<[Item]>(value: [])
    
    private let dummyItems: [Item] = [
        Item(type: .gym, name: "더 클라임", imageName: "gym_image1", location: "서울시 강남구", height: nil),
        Item(type: .user, name: "홍길동", imageName: "user_image1", location: nil, height: 180.0),
        Item(type: .gym, name: "9클라이밍", imageName: "gym_image2", location: "서울시 마포구", height: nil),
        Item(type: .user, name: "홍길동", imageName: "user_image2", location: nil, height: 175.0)
    ]
    
        private let searchBar: UISearchBar = {
            let searchBar = UISearchBar()
            searchBar.placeholder = "검색하기"
    
            searchBar.heightAnchor.constraint(equalToConstant: 46).isActive = true
            searchBar.layer.cornerRadius = 8
            searchBar.layer.borderWidth = 1
            searchBar.layer.borderColor = UIColor.lineOpacityNormal.cgColor
            searchBar.setImage(UIImage(named: "searchIcon"), for: .search, state: .normal)
    
            let searchTextField = searchBar.searchTextField
            searchTextField.backgroundColor = .clear
    
            if let searchField = searchBar.value(forKey: "searchField") as? UITextField {
                searchField.font = .customFont(style: .body2Medium)
                
                searchTextField.attributedPlaceholder = NSAttributedString(
                       string: "검색하기",
                       attributes: [
                        .foregroundColor: UIColor.labelAssistive
                       ]
                   )
    
            }
    
            return searchBar
        }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "최근 방문"
        label.font = UIFont.customFont(style: .label1SemiBold)
        label.textColor = .labelStrong
        label.textAlignment = .left
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.register(SearchGymTableCell.self, forCellReuseIdentifier: SearchGymTableCell.className)
        tableView.register(SearchUserTableCell.self, forCellReuseIdentifier: SearchUserTableCell.className)
        tableView.rowHeight = 60
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setNavigation()
        setLayout()
        bindTableView()
        
        items.accept(dummyItems)
    }
    
    private func setNavigation() {
        navigationItem.titleView = searchBar

        searchBar.snp.makeConstraints {
            $0.height.equalTo(46)
            $0.top.equalTo(navigationController!.navigationBar).inset(16)
            $0.leading.equalTo(navigationController!.navigationBar).offset(16)
            $0.trailing.equalTo(navigationController!.navigationBar).offset(-16)
            $0.bottom.equalTo(navigationController!.navigationBar)
        }
    }
    
    private func setLayout() {
        [titleLabel, tableView].forEach { view.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(56)
            $0.leading.equalToSuperview().inset(16)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    private func bindTableView() {
        items
            .bind(to: tableView.rx.items) { tableView, row, item in
                let cell: UITableViewCell
                if item.type == .gym {
                    let gymCell = tableView.dequeueReusableCell(withIdentifier: SearchGymTableCell.className, for: IndexPath(row: row, section: 0)) as! SearchGymTableCell
                    gymCell.configure(with: item)
                    cell = gymCell
                } else {
                    let userCell = tableView.dequeueReusableCell(withIdentifier: SearchUserTableCell.className, for: IndexPath(row: row, section: 0)) as! SearchUserTableCell
                    userCell.configure(with: item)
                    cell = userCell
                }
                return cell
            }
            .disposed(by: disposeBag)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
