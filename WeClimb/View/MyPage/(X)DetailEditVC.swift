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
    private let viewModel: DetailEditVM
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 10
        tableView.isScrollEnabled = false // 스크롤 되지 않도록
        tableView.separatorStyle = .none // 구분선 제거
        tableView.register(DetailEditCell.self, forCellReuseIdentifier: DetailEditCell.className)
        return tableView
    }()
    
    init(viewModel: DetailEditVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
     
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
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
        // 네비게이션바 타이틀 설정
        viewModel.selectedItem
            .map { $0.title + " 변경" }
            .bind(to: rx.title) 
            .disposed(by: disposeBag)
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
        viewModel.selectedItem
            .map { [$0] } // 단일 항목을 배열로 변환
            .bind(to: tableView.rx.items(cellIdentifier: DetailEditCell.className, cellType: DetailEditCell.self)) { row, item, cell in
                cell.configure(with: item)
            }
            .disposed(by: disposeBag)
    }
}
