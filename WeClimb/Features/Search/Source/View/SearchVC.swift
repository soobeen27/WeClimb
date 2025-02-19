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
    var armReach: Int?
}

enum SearchStyle {
    case defaultSearch
    case uploadSearch
}

class SearchVC: UIViewController, UITextFieldDelegate {
    var coordinator: SearchCoordinator?
    
    var toSearchResult: ((String) -> Void)?
    var toUploadSearchResult: ((String) -> Void)?
    var toUploalMediaPost: ((SearchResultItem) -> Void)?
    
    private let searchStyle: SearchStyle
    
    private let disposeBag = DisposeBag()
    
    private let searchRightViewContainer: SearchFieldRightView = {
        let container = SearchFieldRightView()
        
        container.snp.makeConstraints {
            $0.width.height.equalTo(SearchConst.Size.rightViewSize)
        }
        return container
    }()
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = SearchConst.Text.searchFieldPlaceholder
        textField.layer.cornerRadius = SearchConst.Shape.textFieldCornerRadius
        textField.layer.borderWidth = SearchConst.Shape.textFieldBorderWidth
        textField.layer.borderColor = SearchConst.Color.textFieldBorderColor
        textField.font = SearchConst.Font.textFieldFont
        textField.textColor = SearchConst.Color.textFieldTextColor
        
        return textField
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = SearchConst.Text.recentVisitTitle
        label.font = SearchConst.Font.textLabelFont
        label.textColor = SearchConst.Color.textLabelTextColor
        label.textAlignment = .left
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.register(SearchGymTableCell.self, forCellReuseIdentifier: SearchGymTableCell.className)
        tableView.register(SearchUserTableCell.self, forCellReuseIdentifier: SearchUserTableCell.className)
        tableView.rowHeight = SearchConst.Size.tableViewRowHeight
        return tableView
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        let closeIcon = SearchConst.Image.closeIcon
        button.setImage(closeIcon, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = SearchConst.Color.cancelBtnTintColor
        button.alpha = SearchConst.buttonAlphaHidden
        return button
    }()
    
    private let savedRecentVisitItemsSubject = BehaviorSubject<[SearchResultItem]>(value: [])
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchTextField.alpha = SearchConst.buttonAlphaVisible
        cancelButton.alpha = SearchConst.buttonAlphaVisible
        
        loadRecentVisitItems()
        
        let searchIcon = SearchConst.Image.searchIcon
        searchIcon.contentMode = .scaleAspectFit
        
        let iconWrapper = UIView(frame: SearchConst.Size.searchIconSize)
        iconWrapper.addSubview(searchIcon)
        searchIcon.frame.origin = SearchConst.Spacing.searchIconleftSpacing
        
        searchTextField.leftView = iconWrapper
        searchTextField.leftViewMode = .always
        
        searchTextField.rightView = searchRightViewContainer
        searchTextField.rightViewMode = .whileEditing
        searchRightViewContainer.setCancelButtonAlpha(SearchConst.buttonAlphaHidden)
    }
    
    init(searchStyle: SearchStyle = .defaultSearch) {
        self.searchStyle = searchStyle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        searchTextField.delegate = self
        
        setLayout()
        bindTableView()
        bindButtons()
        applySearchStyle()
    }
    
    private func applySearchStyle() {
        let isDarkMode = traitCollection.userInterfaceStyle == .dark
        
        if isDarkMode {
            setupUploadSearchStyle()
        } else {
            switch searchStyle {
            case .defaultSearch:
                return
            case .uploadSearch:
                setupUploadSearchStyle()
            }
        }
    }
    
    private func setupUploadSearchStyle() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.barTintColor = UIColor.fillSolidDarkBlack
        
        navigationItem.title = "편집"
        
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.customFont(style: .heading2SemiBold)
        ]
        
        let backIcon = UIImage(named: "closeIcon")?.withRenderingMode(.alwaysTemplate)
        let backButton = UIBarButtonItem(image: backIcon, style: .plain, target: self, action: #selector(didTapCloseButton))
        backButton.tintColor = .white
        
        navigationItem.leftBarButtonItem = backButton
        
        view.backgroundColor = UIColor.fillSolidDarkBlack
        self.tableView.backgroundColor = UIColor.fillSolidDarkBlack
        self.searchTextField.textColor = UIColor.white
        self.titleLabel.textColor = UIColor.white
    }
    
    @objc private func didTapCloseButton() {
        let alert = DefaultAlertVC(alertType: .titleDescription, interfaceStyle: .dark)
        alert.setTitle("정말 나가시겠어요?", "입력된 내용은 저장되지 않아요.")
        alert.setCustomButtonTitle("삭제")
        alert.customButtonTitleColor = UIColor.init(hex: "FB283E")  //StatusNegative
        
        alert.customAction = { [weak self] in
            self?.tabBarController?.selectedIndex = 0
            self?.tabBarController?.tabBar.isHidden = false
            UIView.animate(withDuration: 0.1, animations: {
                self?.tabBarController?.tabBar.alpha = 1
            })
        }
        
        alert.modalPresentationStyle = .overCurrentContext
        alert.modalTransitionStyle = .crossDissolve
        present(alert, animated: false, completion: nil)
    }
    
    private func setLayout() {
        [searchTextField, titleLabel, tableView, cancelButton]
            .forEach { view.addSubview($0)}
        
        searchTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(SearchConst.Search.Spacing.textFieldSpacing)
            $0.leading.trailing.equalToSuperview().inset(SearchConst.Search.Spacing.textFieldSpacing)
            $0.height.equalTo(SearchConst.Search.Size.textFieldHeight)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom).offset(SearchConst.Search.Spacing.titleLabelSpacing)
            $0.height.equalTo(SearchConst.Search.Size.titleLabelHeight)
            $0.leading.equalToSuperview().inset(SearchConst.Search.Spacing.titleLabelSpacing)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        cancelButton.snp.makeConstraints {
            $0.width.height.equalTo(SearchConst.Search.Size.cancelButtonSize)
            $0.trailing.equalToSuperview().offset(SearchConst.Search.Spacing.cancelBtnRightSpacing)
            $0.centerY.equalTo(searchTextField)
        }
    }
    
    private func loadRecentVisitItems() {
        if let savedData = UserDefaults.standard.value(forKey: SearchConst.UserDefaultsKeys.recentVisitItems) as? Data {
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
                    let gymCell = tableView.dequeueReusableCell(withIdentifier: SearchGymTableCell.className, for: IndexPath(row: row, section: SearchConst.defaultSectionNumbers)) as! SearchGymTableCell
                    gymCell.configure(with: item, searchStyle: self.searchStyle)
                    
                    gymCell.onDelete = { [weak self] itemToDelete in
                        self?.deleteItem(itemToDelete, at: row)
                    }
                    gymCell.selectionStyle = .none
                    
                    cell = gymCell
                } else {
                    let userCell = tableView.dequeueReusableCell(withIdentifier: SearchUserTableCell.className, for: IndexPath(row: row, section: SearchConst.defaultSectionNumbers)) as! SearchUserTableCell
                    userCell.configure(with: item, searchStyle: self.searchStyle)
                    
                    userCell.onDelete = { [weak self] itemToDelete in
                        self?.deleteItem(itemToDelete, at: row)
                    }
                    userCell.selectionStyle = .none
                    
                    cell = userCell
                }
                return cell
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(SearchResultItem.self)
            .bind(onNext: { [weak self] item in
                guard let self = self else { return }
                
                if self.searchStyle == .uploadSearch {
                    self.toUploalMediaPost?(item)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func deleteItem(_ item: SearchResultItem, at index: Int) {
        do {
            var currentItems = try savedRecentVisitItemsSubject.value()
            
            currentItems.remove(at: index)
            
            if let encodedData = try? JSONEncoder().encode(currentItems) {
                UserDefaults.standard.set(encodedData, forKey: SearchConst.UserDefaultsKeys.recentVisitItems)
            }
            
            savedRecentVisitItemsSubject.onNext(currentItems)
            
            tableView.reloadData()
        } catch {
            print("Error while deleting item: \(error)")
        }
    }
    
    private func bindButtons() {
        searchRightViewContainer.cancelButtonTapObservable
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
    
    func didTapCancelButton() {
        searchTextField.text = SearchConst.Text.emptyText
        searchTextField.resignFirstResponder()
        searchTextField.layer.borderColor = UIColor.lineOpacityNormal.cgColor
        
        self.searchTextField.snp.updateConstraints {
            $0.leading.equalToSuperview().offset(SearchConst.Search.Spacing.textFieldSpacing)
            $0.trailing.equalToSuperview().offset(-SearchConst.Search.Spacing.textFieldSpacing)
        }
        
        self.cancelButton.snp.updateConstraints {
            $0.trailing.equalToSuperview().offset(SearchConst.Search.Spacing.returnCancelBtnRightSpacing)
        }
        
        self.cancelButton.alpha = SearchConst.buttonAlphaHidden
    }
    
    func didTapSmallCancelButton() {
        searchTextField.text = SearchConst.Text.emptyText
        searchRightViewContainer.setCancelButtonAlpha(SearchConst.buttonAlphaHidden)
    }
}

extension SearchVC {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if searchStyle == .uploadSearch {
            return
        }
        
        searchTextField.layer.borderWidth = SearchConst.Shape.textFieldBorderWidth
        searchTextField.layer.borderColor = UIColor.fillSolidDarkBlack.cgColor
        
        self.searchTextField.snp.updateConstraints {
            $0.leading.equalToSuperview().offset(SearchConst.Search.Spacing.textFieldSpacing)
            $0.trailing.equalToSuperview().offset(SearchConst.Search.Spacing.updatedTextFieldRightSpacing)
        }
        
        self.cancelButton.alpha = SearchConst.buttonAlphaVisible
        self.cancelButton.snp.updateConstraints {
            $0.trailing.equalToSuperview().offset(SearchConst.Search.Spacing.updatedCancelBtnRightSpacing)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        
        if newText?.isEmpty == true {
            searchRightViewContainer.setCancelButtonAlpha(SearchConst.buttonAlphaHidden)
        } else {
            searchRightViewContainer.setCancelButtonAlpha(SearchConst.buttonAlphaVisible)
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if let searchText = textField.text, !searchText.isEmpty {
            self.searchTextField.alpha = SearchConst.buttonAlphaHidden
            self.cancelButton.alpha = SearchConst.buttonAlphaHidden
            
            switch searchStyle {
            case .defaultSearch:
                self.toSearchResult?(searchText)
            case .uploadSearch:
                self.toUploadSearchResult?(searchText)
            }
        }
        
        return true
    }
}

