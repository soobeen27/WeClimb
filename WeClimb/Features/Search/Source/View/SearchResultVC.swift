//
//  SearchResultVC.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//

import UIKit

import RxSwift
import RxCocoa

class SearchResultVC: UIViewController {
    var coordinator: SearchResultCoordinator?
    
    var toUpoadVC: ((SearchResultItem) -> Void)?
    
    private let disposeBag = DisposeBag()
    
    private var viewModel: SearchResultVM
    var query: String?
    
    private var searchStyle: SearchStyle
    
    private lazy var searchRightViewContainer: SearchFieldRightView = {
        let container = SearchFieldRightView()
        
        container.snp.makeConstraints {
            $0.width.height.equalTo(SearchConst.Size.rightViewSize)
        }
        return container
    }()
    
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = SearchConst.Text.searchFieldPlaceholder
        textField.layer.cornerRadius = SearchConst.Shape.textFieldCornerRadius
        textField.layer.borderWidth = SearchConst.Shape.textFieldBorderWidth
        textField.layer.borderColor = SearchConst.Color.textFieldBorderColor
        textField.font = SearchConst.Font.textFieldFont
        textField.textColor = SearchConst.Color.textFieldTextColor
        
        let searchIcon = UIImageView(image: SearchConst.Image.searchIcon)
        searchIcon.contentMode = .scaleAspectFit
        let iconWrapper = UIView(frame: SearchConst.Size.searchIconSize)
        iconWrapper.addSubview(searchIcon)
        searchIcon.frame.origin = SearchConst.Spacing.searchIconleftSpacing
        
        textField.leftView = iconWrapper
        textField.leftViewMode = .always
        
        textField.rightView = searchRightViewContainer
        textField.rightViewMode = .whileEditing
        searchRightViewContainer.setCancelButtonAlpha(SearchConst.buttonAlphaHidden)
        
        return textField
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        let backIcon = SearchConst.Image.backIcon
        button.setImage(backIcon, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = SearchConst.Color.backBtnTintColor
        return button
    }()
    
    let segmentedControl = CustomSegmentedControl(items: [SearchConst.Text.SegmentedItems.all, SearchConst.Text.SegmentedItems.gym, SearchConst.Text.SegmentedItems.account])
    
    private let bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = LevelHoldFilterConst.Color.lightLineColor
        return view
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.register(SearchGymTableCell.self, forCellReuseIdentifier: SearchGymTableCell.className)
        tableView.register(SearchUserTableCell.self, forCellReuseIdentifier: SearchUserTableCell.className)
        tableView.rowHeight = SearchConst.Size.tableViewRowHeight
        return tableView
    }()
    
    private let selectedSegmentIndexSubject = BehaviorSubject<Int>(value: SearchConst.defaultSegmentIndex)
    
    init(viewModel: SearchResultVM, searchStyle: SearchStyle) {
          self.viewModel = viewModel
          self.searchStyle = searchStyle
          super.init(nibName: nil, bundle: nil)
      }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self
        
        if let query = query {
            searchTextField.text = query
        }
        
        setLayout()
        bindUI()
        bindButtons()
        applySearchStyle()
    }
    
    private func applySearchStyle() {
        let isDarkMode = traitCollection.userInterfaceStyle == .dark
        
        switch searchStyle {
        case .defaultSearch:
            return
        case .uploadSearch:
            setupDarkModeSearchStyle()
        }
        
        if isDarkMode {
            setupDarkModeSearchStyle()
        }
    }

    private func setupDarkModeSearchStyle() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.barTintColor = SearchConst.SearchResult.Color.navigationBackground

        navigationItem.title = SearchConst.SearchResult.Text.navigationTitle
        
        let backButton = UIBarButtonItem(
            image: SearchConst.SearchResult.Image.navigationBackIcon,
            style: .plain,
            target: self,
            action: #selector(didTapCloseButton)
        )
        backButton.tintColor = SearchConst.Search.Color.navigationBackButtonTint
        navigationItem.leftBarButtonItem = backButton

        self.backButton.isHidden = true
        segmentedControl.isHidden = true
        bottomLineView.isHidden = true
        
        searchTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(SearchConst.SearchResult.Spacing.textFieldTopSpacing)
            $0.trailing.equalToSuperview().inset(SearchConst.SearchResult.Spacing.textFieldRightSpacing)
            $0.leading.equalToSuperview().inset(SearchConst.SearchResult.Spacing.textFieldRightSpacing)
            $0.height.equalTo(SearchConst.SearchResult.Size.textFieldHeight)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom).offset(SearchConst.SearchResult.Spacing.tableViewTopOffset)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        view.backgroundColor = SearchConst.SearchResult.Color.viewBackground
        tableView.backgroundColor = SearchConst.SearchResult.Color.tableViewBackground
        searchTextField.textColor = SearchConst.SearchResult.Color.searchTextFieldText
    }
    
    @objc private func didTapCloseButton() {
        let alert = DefaultAlertVC(alertType: .titleDescription, interfaceStyle: .dark)
        alert.setTitle(SearchConst.Search.Text.closeAlertTitle, SearchConst.Search.Text.closeAlertMessage)
        alert.setCustomButtonTitle(SearchConst.Search.Text.closeAlertConfirmButtonTitle)
        alert.customButtonTitleColor = SearchConst.Search.Color.alertConfirmButton
        
        alert.customAction = { [weak self] in
            self?.tabBarController?.selectedIndex = SearchConst.Search.TabBar.defaultIndex
            self?.tabBarController?.tabBar.isHidden = false
            UIView.animate(
                withDuration: SearchConst.Search.Animation.fadeDuration,
                animations: {
                    self?.tabBarController?.tabBar.alpha = SearchConst.Search.Animation.visibleAlpha
                }
            )
        }
        
        alert.modalPresentationStyle = .overCurrentContext
        alert.modalTransitionStyle = .crossDissolve
        present(alert, animated: false, completion: nil)
    }
    
    private func setLayout() {
        [searchTextField, segmentedControl, backButton, bottomLineView, tableView]
            .forEach { view.addSubview($0)}
        
        backButton.snp.makeConstraints {
            $0.width.height.equalTo(SearchConst.SearchResult.Size.backBtnSize)
            $0.leading.equalToSuperview().offset(SearchConst.SearchResult.Spacing.backBtnleftSpacing)
            $0.centerY.equalTo(searchTextField)
        }
        
        searchTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(SearchConst.SearchResult.Spacing.textFieldTopSpacing)
            $0.trailing.equalToSuperview().inset(SearchConst.SearchResult.Spacing.textFieldRightSpacing)
            $0.leading.equalTo(backButton.snp.trailing).offset(SearchConst.SearchResult.Spacing.textFieldLeftSpacing)
            $0.height.equalTo(SearchConst.SearchResult.Size.textFieldHeight)
        }
        
        segmentedControl.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom).offset(SearchConst.SearchResult.Spacing.segmentTopSpacing)
            $0.height.equalTo(SearchConst.SearchResult.Size.segmentHeight)
            $0.leading.equalToSuperview().inset(SearchConst.SearchResult.Spacing.segmentRightSpacing)
            $0.trailing.equalToSuperview()
        }
        
        bottomLineView.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(SearchConst.SearchResult.Spacing.bottomLineTopSpacing)
            $0.height.equalTo(SearchConst.SearchResult.Size.bottomLineHeight)
            $0.leading.trailing.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    private func bindUI() {
        let saveItemSubject = PublishSubject<SearchResultItem>()
        
        let searchText = Observable.merge(
            searchTextField.rx.text.orEmpty
                .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
                .distinctUntilChanged()
        )
        
        let input = SearchResultVMImpl.Input(
            query: searchText.asObservable(),
            selectedSegment: selectedSegmentIndexSubject.asObservable(),
            SavedRecentVisitItems: saveItemSubject
        )
        
        let output = viewModel.transform(input: input)
        
        output.items
            .map { items in
                if self.searchStyle == .uploadSearch {
                    return items.filter { $0.type == .gym }
                }
                return items
            }
            .bind(to: tableView.rx.items) { (tableView, index, item) in
                switch item.type {
                case .gym:
                    let cell = tableView.dequeueReusableCell(withIdentifier: SearchGymTableCell.className) as! SearchGymTableCell
                    cell.configure(with: item, searchStyle: self.searchStyle)
                    cell.shouldShowDeleteButton = false
                    cell.selectionStyle = .none
                    return cell
                    
                case .user:
                    let cell = tableView.dequeueReusableCell(withIdentifier: SearchUserTableCell.className) as! SearchUserTableCell
                    cell.configure(with: item, searchStyle: self.searchStyle)
                    cell.shouldShowDeleteButton = false
                    cell.selectionStyle = .none
                    return cell
                }
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(SearchResultItem.self)
            .bind(onNext: { [weak self] item in
                guard let self = self else { return }
                
                if self.searchStyle == .uploadSearch {
                    self.toUpoadVC?(item)
                } else {
                    saveItemSubject.onNext(item)
                }
            })
            .disposed(by: disposeBag)
        
        segmentedControl.onSegmentChanged = { [weak self] selectedIndex in
            self?.selectedSegmentIndexSubject.onNext(selectedIndex)
        }
    }
    
    private func bindButtons() {
        backButton.rx.tap
            .bind { [weak self] in
                self?.didTapCancelButton()
            }
            .disposed(by: disposeBag)
        
        searchRightViewContainer.cancelButtonTapObservable
            .bind { [weak self] in
                self?.didTapSmallCancelButton()
            }
            .disposed(by: disposeBag)
    }
    
    private func didTapCancelButton() {
        coordinator?.navigateBackToSearchVC()
        }
   
    private func didTapSmallCancelButton() {
        searchTextField.text = SearchConst.Text.emptyText
        searchRightViewContainer.setCancelButtonAlpha(SearchConst.buttonAlphaHidden)
    }
}

extension SearchResultVC: UITextFieldDelegate  {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        
        if newText?.isEmpty == true {
            searchRightViewContainer.setCancelButtonAlpha(SearchConst.buttonAlphaHidden)
        } else {
            searchRightViewContainer.setCancelButtonAlpha(SearchConst.buttonAlphaVisible)
        }
        return true
    }
}
