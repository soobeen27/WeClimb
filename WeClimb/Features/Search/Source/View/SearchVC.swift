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

enum SearchResultType: Codable {
    case gym
    case user
}

struct SearchResultItem: Codable {
    var type: SearchResultType
    var name: String
    var imageName: String
    var location: String?
    var height: Int?
}

class SearchVC: UIViewController, UITextFieldDelegate {
    var coordinator: SearchCoordinator?
    
    private let disposeBag = DisposeBag()
    
    private lazy var rightViewContainer: TextFieldRightView = {
        let container = TextFieldRightView()
        
        container.snp.makeConstraints {
            $0.width.height.equalTo(30)
        }
        return container
    }()
    
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "검색하기"
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lineOpacityNormal.cgColor
        textField.font = .customFont(style: .body2Medium)
        textField.textColor = .black
        
        let searchIcon = UIImageView(image: UIImage(named: "searchIcon"))
        searchIcon.contentMode = .scaleAspectFit
        let iconWrapper = UIView(frame: CGRect(x: 0, y: 0, width: 20 + 12 + 8, height: 20))
        iconWrapper.addSubview(searchIcon)
        searchIcon.frame.origin = CGPoint(x: 12, y: 0)
        
        textField.leftView = iconWrapper
        textField.leftViewMode = .always
        
        textField.rightView = rightViewContainer
        textField.rightViewMode = .whileEditing
        rightViewContainer.setCancelButtonAlpha(0)
        
        return textField
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
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        let closeIcon = UIImage(named: "closeIcon")?.withRenderingMode(.alwaysTemplate)
        button.setImage(closeIcon, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .black
        button.alpha = 0
        return button
    }()
    
    private let savedRecentVisitItemsSubject = BehaviorSubject<[SearchResultItem]>(value: [])
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchTextField.alpha = 1
        cancelButton.alpha = 1
        
        loadRecentVisitItems()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        searchTextField.delegate = self
        
        setLayout()
        bindTableView()
        bindButtons()
    }
    
    private func setLayout() {
        [searchTextField, titleLabel, tableView, cancelButton]
            .forEach { view.addSubview($0)}
        
        searchTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(46)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom).offset(16)
            $0.height.equalTo(56)
            $0.leading.equalToSuperview().inset(16)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        cancelButton.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.trailing.equalToSuperview().offset(48)
            $0.centerY.equalTo(searchTextField)
        }
    }
    
    private func loadRecentVisitItems() {
        if let savedData = UserDefaults.standard.value(forKey: "recentVisitItems") as? Data {
            let decoder = JSONDecoder()
            if let decodedItems = try? decoder.decode([SearchResultItem].self, from: savedData) {
                savedRecentVisitItemsSubject.onNext(decodedItems)
            } else {
                print("Error: 데이터 디코딩 실패")
            }
        } else {
            print("No saved data found.")
        }
    }

    private func bindTableView() {
        savedRecentVisitItemsSubject
            .bind(to: tableView.rx.items) { tableView, row, item in
                let cell: UITableViewCell
                if item.type == .gym {
                    let gymCell = tableView.dequeueReusableCell(withIdentifier: SearchGymTableCell.className, for: IndexPath(row: row, section: 0)) as! SearchGymTableCell
                    gymCell.configure(with: item)
                    
                    gymCell.onDelete = { [weak self] itemToDelete in
                        self?.deleteItem(itemToDelete, at: row)
                    }
                    
                    cell = gymCell
                } else {
                    let userCell = tableView.dequeueReusableCell(withIdentifier: SearchUserTableCell.className, for: IndexPath(row: row, section: 0)) as! SearchUserTableCell
                    userCell.configure(with: item)
                    
                    userCell.onDelete = { [weak self] itemToDelete in
                        self?.deleteItem(itemToDelete, at: row)
                    }
                    
                    cell = userCell
                }
                return cell
            }
            .disposed(by: disposeBag)
    }
    
    private func deleteItem(_ item: SearchResultItem, at index: Int) {
        do {
            var currentItems = try savedRecentVisitItemsSubject.value()
            
            currentItems.remove(at: index)
            
            if let encodedData = try? JSONEncoder().encode(currentItems) {
                UserDefaults.standard.set(encodedData, forKey: "recentVisitItems")
            }
            
            savedRecentVisitItemsSubject.onNext(currentItems)
            
            tableView.reloadData()
        } catch {
            print("Error while deleting item: \(error)")
        }
    }
    
    private func bindButtons() {
        rightViewContainer.cancelButtonTapObservable
            .bind { [weak self] in
                self?.didTapSmallCancelButton()
            }
            .disposed(by: disposeBag)

        cancelButton.rx.tap
            .bind { [weak self] in
                self?.didTapCancelButton()
            }
            .disposed(by: disposeBag)
    }
}

extension SearchVC {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.borderColor = UIColor.fillSolidDarkBlack.cgColor
        
        self.searchTextField.snp.updateConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-48)
        }
        
        self.cancelButton.alpha = 1
        self.cancelButton.snp.updateConstraints {
            $0.trailing.equalToSuperview().offset(-16)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        
        if newText?.isEmpty == true {
            rightViewContainer.setCancelButtonAlpha(0)
        } else {
            rightViewContainer.setCancelButtonAlpha(1)
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if let searchText = textField.text, !searchText.isEmpty {
            self.searchTextField.alpha = 0
            self.cancelButton.alpha = 0
            coordinator?.navigateToSearchResult(query: searchText)
        }
        
        return true
    }
    
    func didTapCancelButton() {
        searchTextField.text = ""
        searchTextField.resignFirstResponder()
        searchTextField.layer.borderColor = UIColor.lineOpacityNormal.cgColor
        
        self.searchTextField.snp.updateConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        self.cancelButton.snp.updateConstraints {
            $0.trailing.equalToSuperview().offset(16)
        }
        
        self.cancelButton.alpha = 0
    }
    
    func didTapSmallCancelButton() {
        searchTextField.text = ""
        rightViewContainer.setCancelButtonAlpha(0)
    }
}
