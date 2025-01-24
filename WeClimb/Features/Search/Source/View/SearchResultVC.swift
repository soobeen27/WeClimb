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
    private let disposeBag = DisposeBag()
    
    private var viewModel: SearchResultVM
    var query: String?
    
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
        
        let searchIcon = SearchConst.Image.searchIcon
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

    init(viewModel: SearchResultVM) {
        self.viewModel = viewModel
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
        
        let input = SearchResultVMImpl.Input(
            query: searchTextField.rx.text.orEmpty.asObservable(),
            selectedSegment: selectedSegmentIndexSubject.asObservable(),
              SavedRecentVisitItems: saveItemSubject
        )
        
        let output = viewModel.transform(input: input)
        
        output.items
            .bind(to: tableView.rx.items) { (tableView, index, item) in
                switch item.type {
                case .gym:
                    let cell = tableView.dequeueReusableCell(withIdentifier: SearchGymTableCell.className) as! SearchGymTableCell
                    cell.configure(with: item)
                    cell.shouldShowDeleteButton = false
                    return cell
                case .user:
                    let cell = tableView.dequeueReusableCell(withIdentifier: SearchUserTableCell.className) as! SearchUserTableCell
                    cell.configure(with: item)
                    cell.shouldShowDeleteButton = false
                    return cell
                }
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(SearchResultItem.self)
            .bind(onNext: { [weak self] item in
                guard self != nil else { return }
                saveItemSubject.onNext(item)
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
