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
            $0.width.height.equalTo(SearchConst.Common.Size.rightViewSize)
        }
        return container
    }()
    
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = SearchConst.Common.Text.searchFieldPlaceholder
        textField.layer.cornerRadius = SearchConst.Common.Shape.textFieldCornerRadius
        textField.layer.borderWidth = SearchConst.Common.Shape.textFieldBorderWidth
        textField.layer.borderColor = SearchConst.Common.Color.textFieldBorder
        textField.font = SearchConst.Common.Font.textFieldFont
        textField.textColor = SearchConst.Common.Color.textFieldText
        
        let searchIcon = UIImageView(image: SearchConst.Common.Image.searchIcon)
        searchIcon.contentMode = .scaleAspectFit
        let iconWrapper = UIView(frame: SearchConst.Common.Size.searchIconSize)
        iconWrapper.addSubview(searchIcon)
        searchIcon.frame.origin = SearchConst.Common.Spacing.searchIconleftSpacing
        
        textField.leftView = iconWrapper
        textField.leftViewMode = .always
        
        textField.rightView = searchRightViewContainer
        textField.rightViewMode = .whileEditing
        searchRightViewContainer.setCancelButtonAlpha(SearchConst.Common.buttonAlphaHidden)
        
        return textField
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        let backIcon = SearchConst.Common.Image.backIcon
        button.setImage(backIcon, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = SearchConst.SearchResult.Color.backBtnTint
        return button
    }()
    
    let segmentedControl = CustomSegmentedControl(items: [SearchConst.SearchResult.Text.SegmentedItems.all, SearchConst.SearchResult.Text.SegmentedItems.gym, SearchConst.SearchResult.Text.SegmentedItems.account])
    
    private let bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = SearchConst.SearchResult.Color.LineView
        return view
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.register(SearchGymTableCell.self, forCellReuseIdentifier: SearchGymTableCell.className)
        tableView.register(SearchUserTableCell.self, forCellReuseIdentifier: SearchUserTableCell.className)
        tableView.rowHeight = SearchConst.Common.Size.tableViewRowHeight
        return tableView
    }()
    
    private let selectedSegmentIndexSubject = BehaviorSubject<Int>(value: SearchConst.Common.defaultSegmentIndex)
    
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
        applySearchStyle()
        bindUI()
        bindButtons()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle {
            applySearchStyle()
        }
    }

    private func applySearchStyle() {
        switch searchStyle {
        case .defaultSearch:
            if traitCollection.userInterfaceStyle == .dark {
                setDarkModeSearchStyle()
            } else {
                setLightModeSearchStyle()
            }
        case .uploadSearch:
            setUploadSearchStyle()
        }
    }

    private func setDarkModeSearchStyle() {
        view.backgroundColor = SearchConst.Common.Color.viewBackgroundDark
        tableView.backgroundColor = SearchConst.Common.Color.tableViewBackgroundDark
        searchTextField.textColor = SearchConst.Common.Color.textFieldTextDark
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        backButton.tintColor = SearchConst.SearchResult.Color.backBtnTintDark
        bottomLineView.backgroundColor = SearchConst.SearchResult.Color.LineViewDark
    }

    private func setLightModeSearchStyle() {
        view.backgroundColor = SearchConst.Common.Color.viewBackground
        tableView.backgroundColor = SearchConst.Common.Color.tableViewBackground
        searchTextField.textColor = SearchConst.Common.Color.textFieldText
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    private func setUploadSearchStyle() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.barTintColor = SearchConst.Common.Color.navigationBackground
        navigationController?.navigationBar.barStyle = .default

        navigationItem.title = SearchConst.SearchResult.Text.navigationTitle
        
        let closeButton = UIBarButtonItem(
            image: SearchConst.Common.Image.closeIcon,
            style: .plain,
            target: self,
            action: #selector(didTapCloseButton)
        )
        closeButton.tintColor = SearchConst.Common.Color.navigationCloseButtonTint
        navigationItem.leftBarButtonItem = closeButton

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
        
        view.backgroundColor = SearchConst.Common.Color.viewBackgroundDark
        tableView.backgroundColor = SearchConst.Common.Color.tableViewBackgroundDark
        searchTextField.textColor = SearchConst.Common.Color.textFieldTextDark
    }
    
    @objc private func didTapCloseButton() {
        let alert = DefaultAlertVC(alertType: .titleDescription, interfaceStyle: .dark)
        alert.setTitle(SearchConst.Common.Text.Alert.closeAlertTitle, SearchConst.Common.Text.Alert.closeAlertMessage)
        alert.setCustomButtonTitle(SearchConst.Common.Text.Alert.closeAlertConfirmButtonTitle)
        alert.customButtonTitleColor = SearchConst.Common.Color.alertConfirmButton
        
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
        searchTextField.text = SearchConst.Common.Text.emptyText
        searchRightViewContainer.setCancelButtonAlpha(SearchConst.Common.buttonAlphaHidden)
    }
}

extension SearchResultVC: UITextFieldDelegate  {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        
        if newText?.isEmpty == true {
            searchRightViewContainer.setCancelButtonAlpha(SearchConst.Common.buttonAlphaHidden)
        } else {
            searchRightViewContainer.setCancelButtonAlpha(SearchConst.Common.buttonAlphaVisible)
        }
        return true
    }
}
