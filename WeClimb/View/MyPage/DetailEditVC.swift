//
//  DetailEditVC.swift
//  WeClimb
//
//  Created by 강유정 on 8/31/24.
//

import UIKit

import RxSwift
import SnapKit

class DetailEditVC: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel = EditPageVM()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 10
        tableView.isScrollEnabled = false // 스크롤 되지 않도록
        tableView.separatorStyle = .none // 구분선 제거
        tableView.register(DetailEditCell.self, forCellReuseIdentifier: DetailEditCell.className)
        return tableView
    }()
    
    override func viewDidLoad() {
        setColor()
        setNavigation()
        setLayout()
        bind()
    }
    
    // MARK: - 커스텀 색상 YJ
    private func setColor() {
        view.backgroundColor = UIColor {
            switch $0.userInterfaceStyle {
            case .dark:
                return UIColor(named: "BackgroundColor") ?? .black
            default:
                return UIColor.systemGroupedBackground
            }
        }
    }
    
    func setNavigation() {
        self.title = MypageNameSpace.edit
    }
    
    private func setLayout() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(30)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(40)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func bind() {
        viewModel.items
            .bind(to: tableView.rx.items(cellIdentifier: DetailEditCell.className, cellType: DetailEditCell.self)) { row, model, cell in
                cell.configure(with: model)
            }
            .disposed(by: disposeBag)
    }
}
