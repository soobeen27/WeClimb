//
//  SearchResultVC.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//

import UIKit

import RxSwift

class SearchResultVC: UIViewController {
    var coordinator: SearchResultCoordinator?
    private let disposeBag = DisposeBag()
    
    private var viewModel: SearchResultVM
    var query: String?
    
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
        textField.layer.borderColor = UIColor.black.cgColor
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
//        rightViewContainer.setCancelButtonAlpha(0)
        
        return textField
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        let closeIcon = UIImage(named: "chevronLeftIcon")?.withRenderingMode(.alwaysTemplate)
        button.setImage(closeIcon, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .black
        return button
    }()
    
    let segmentedControl = CustomSegmentedControl(items: ["전체", "암장", "계정"])
    
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
        tableView.rowHeight = 60
        return tableView
    }()
    
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
            print("해당 쿼리 : \(query)")
            searchTextField.text = query
        }
        
        setLayout()
        bindButtons()
    }
    
    private func setLayout() {
        [searchTextField, segmentedControl, backButton, bottomLineView, tableView]
            .forEach { view.addSubview($0)}
        
        backButton.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalTo(searchTextField)
        }
        
        searchTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.leading.equalTo(backButton.snp.trailing).offset(8)
            $0.height.equalTo(46)
        }
        
        segmentedControl.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom).offset(16)
            $0.height.equalTo(56)
            $0.leading.equalToSuperview().inset(16)
        }
        
        bottomLineView.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(1)
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    private func bindButtons() {
        backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.didTapCancelButton()
            })
            .disposed(by: disposeBag)
    }
    
    private func didTapCancelButton() {
        coordinator?.navigateBackToSearchVC()
    }
}

extension SearchResultVC: UITextFieldDelegate  {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        
        if newText?.isEmpty == true {
            rightViewContainer.setCancelButtonAlpha(0)
        } else {
            rightViewContainer.setCancelButtonAlpha(1)
        }
        return true
    }
}
