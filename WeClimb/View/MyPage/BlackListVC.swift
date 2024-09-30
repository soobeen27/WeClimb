//
//  BlackListVC.swift
//  WeClimb
//
//  Created by 머성이 on 9/26/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

class BlackListVC: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel = BlackListVM()
    
    private let blackListTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .darkGray
        tableView.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        tableView.tableFooterView = UIView() // 빈 셀 숨기기
        tableView.register(BlackListCell.self, forCellReuseIdentifier: BlackListCell.className)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        naviUI()
        
//        bindViewModel()
    }
    
//    private func bindViewModel() {
//        // ViewModel의 blackList를 TableView에 바인딩
//        viewModel.blackList
//            .bind(to: blackListTableView.rx.items(cellIdentifier: BlackListCell.className, cellType: BlackListCell.self)) { index, userUID, cell in
//                cell.configure(icon: UIImage(named: "defaultUser"), name: userUID)
//                
//                cell.manageButton.addAction(UIAction { [weak self] _ in
//                    self?.showManageAlert(for: userUID)
//                }, for: .touchUpInside)
//            }
//            .disposed(by: disposeBag)
//        
//        // 로딩 상태 바인딩
//        viewModel.isLoading
//            .observe(on: MainScheduler.instance)
//            .subscribe(onNext: { isLoading in
//                if isLoading {
//                    // 로딩 표시 (예: 로딩 인디케이터)
//                } else {
//                    // 로딩 해제
//                }
//            })
//            .disposed(by: disposeBag)
//    }
    
    private func naviUI() {
        self.title = "차단 목록"
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        
        [
            blackListTableView
        ].forEach { view.addSubview($0) }
        
        blackListTableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
//    private func showManageAlert(for userUID: String) {
//            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//            let unblockAction = UIAlertAction(title: "차단 해제", style: .destructive) { [weak self] _ in
//                self?.viewModel.removeFromBlackList(userUID: userUID)
//            }
//            let cancelAction = UIAlertAction(title: "취소", style: .cancel)
//            
//            alert.addAction(unblockAction)
//            alert.addAction(cancelAction)
//            
//            present(alert, animated: true)
//        }
}
