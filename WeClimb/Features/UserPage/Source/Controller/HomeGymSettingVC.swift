//
//  HomeGymSettingVC.swift
//  WeClimb
//
//  Created by 윤대성 on 2/21/25.
//

import UIKit

import SnapKit
import RxCocoa
import RxSwift

class HomeGymSettingVC: UIViewController {
    
    var coordinator: HomeGymSettingCoordinator?
    
    private let disposeBag = DisposeBag()
    private let viewModel: HomeGymSettingVM
    
    private let gymSearchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.layer.borderColor = HomeGymSettingConst.Color.placeholderBorderColor.cgColor
        sb.layer.borderWidth = 1
        sb.layer.cornerRadius = 8
        
        sb.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        sb.backgroundColor = .white
        sb.isTranslucent = false
        
        sb.searchTextField.backgroundColor = .white
        sb.searchTextField.clipsToBounds = true
        
        sb.searchTextField.attributedPlaceholder = NSAttributedString(
            string: HomeGymSettingConst.Text.placeholderText,
            attributes: [
                .foregroundColor: HomeGymSettingConst.Color.placeholderFontColor,
                .font: HomeGymSettingConst.Font.placeholderFont,
            ]
        )
        
        return sb
    }()
    
    private let homeGymLabel: UILabel = {
        let label = UILabel()
        label.text = HomeGymSettingConst.Text.favoriteLabel
        label.font = HomeGymSettingConst.Font.titleFont
        label.textColor = HomeGymSettingConst.Color.titleColor
        return label
    }()
    
    private let homeGymTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(HomeGymSettingCell.self, forCellReuseIdentifier: HomeGymSettingCell.identifier)
        tableView.rowHeight = 60
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    init(viewModel: HomeGymSettingVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setupNavigationBar()
        bindViewModel()
    }
    
    private func setLayout() {
        view.backgroundColor = .white
        
        [
            gymSearchBar,
            homeGymLabel,
            homeGymTableView,
        ].forEach { view.addSubview($0) }
        
        gymSearchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(HomeGymSettingConst.Size.placeholderHeight)
        }
        
        homeGymLabel.snp.makeConstraints {
            $0.top.equalTo(gymSearchBar.snp.bottom).offset(37)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        homeGymTableView.snp.makeConstraints {
            $0.top.equalTo(homeGymLabel.snp.bottom).offset(21)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.title = ProfileSettingConst.Text.homeGymSettingTitle
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: ProfileSettingConst.Font.naviTitleFont,
            .foregroundColor: ProfileSettingConst.Color.naviTitleFontColor
        ]
        navigationController?.navigationBar.titleTextAttributes = titleAttributes

        let backButtonImage = ProfileSettingConst.Image.backButtonSymbolImage
        let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(backButtonTapped))
        
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func backButtonTapped() {
        coordinator?.showReturnPage()
    }
    
    private func bindViewModel() {
        let input = HomeGymSettingImpl.Input(
            searchQuery: gymSearchBar.rx.text.orEmpty.asObservable(),
            selectHomeGymImage: homeGymTableView.rx.modelSelected(Gym.self).asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.filteredGyms
            .drive(homeGymTableView.rx.items(cellIdentifier: HomeGymSettingCell.identifier, cellType: HomeGymSettingCell.self)) { _, gym, cell in
                let isSelected = output.selectedHomeGymImage
                    .map { $0?.gymName == gym.gymName }
                    .asObservable()
                
                cell.configure(with: gym, isSelected: isSelected)
                
                output.gymImageURLs
                    .map { $0[gym.gymName] ?? nil }
                    .drive(onNext: { url in
                        cell.updateGymImage(with: url)
                    })
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        output.selectedHomeGymImage
            .drive(onNext: { gym in
                print("선택된 홈짐: \(gym?.gymName ?? "없음")")
            })
            .disposed(by: disposeBag)
    }
}
