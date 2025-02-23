//
//  homeGymSettingVC.swift
//  WeClimb
//
//  Created by 윤대성 on 2/21/25.
//

import UIKit

import SnapKit
import RxCocoa
import RxSwift

class homeGymSettingVC: UIViewController {
    
    var coordinator: homeGymSettingCoordinator?
    
    private let disposeBag = DisposeBag()
    
    private let gymSearchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.layer.borderColor = homeGymSettingConst.Color.placeholderBorderColor.cgColor
        sb.layer.borderWidth = 1
        sb.layer.cornerRadius = 8
        
        sb.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        sb.backgroundColor = .white
        sb.isTranslucent = false
        
        sb.searchTextField.backgroundColor = .white
        sb.searchTextField.clipsToBounds = true
        
        sb.searchTextField.attributedPlaceholder = NSAttributedString(
            string: homeGymSettingConst.Text.placeholderText,
            attributes: [
                .foregroundColor: homeGymSettingConst.Color.placeholderFontColor,
                .font: homeGymSettingConst.Font.placeholderFont,
            ]
        )
        
        return sb
    }()
    
    private let favoriteGymLabel: UILabel = {
        let label = UILabel()
        label.text = homeGymSettingConst.Text.favoriteLabel
        label.font = homeGymSettingConst.Font.titleFont
        label.textColor = homeGymSettingConst.Color.titleColor
        return label
    }()
    
    private let favoriteGymTableView: UITableView = {
        let tableView = UITableView()
        
        return tableView
    }()
    
    init(coordinator: homeGymSettingCoordinator?) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
    
    private func setLayout() {
        view.backgroundColor = .white
        
        [
            gymSearchBar,
            favoriteGymLabel,
            favoriteGymTableView,
        ].forEach { view.addSubview($0) }
        
        gymSearchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(homeGymSettingConst.Size.placeholderHeight)
        }
        
        favoriteGymLabel.snp.makeConstraints {
            $0.top.equalTo(gymSearchBar.snp.bottom).offset(37)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        favoriteGymTableView.snp.makeConstraints {
            $0.top.equalTo(favoriteGymLabel.snp.bottom).offset(21)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
