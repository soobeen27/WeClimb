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
        tableView.separatorStyle = .none
//        tableView.separatorColor = .darkGray
        tableView.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        tableView.tableFooterView = UIView() // 빈 셀 숨기기
        tableView.register(BlackListCell.self, forCellReuseIdentifier: BlackListCell.className)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        naviUI()
        bindTableView()
        
        viewModel.fetchBlackList()
    }
    
    private func naviUI() {
        self.title = "차단 목록"
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        
        view.addSubview(blackListTableView)
        
        blackListTableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        blackListTableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
//     TableView 바인딩
    private func bindTableView() {
        viewModel.blackListedUsers
            .bind(to: blackListTableView.rx.items(cellIdentifier: BlackListCell.className, cellType: BlackListCell.self)) { [weak self] row, user, cell in
                guard let self else { return }
                
                // 각 셀에 유저 정보 설정
                cell.configure(with: user)
                
                // 차단 해제 버튼 눌렀을 때 처리
                cell.manageButton.rx.tap
                    .bind { [weak self] in
                        guard let self = self else { return }
                        let uid = self.viewModel.blackListedUIDs.value[row]
                        self.viewModel.unblockUser(uid: uid) { success in
                            if success {
                                print("차단 해제 완료")
                                self.viewModel.fetchBlackList()  // 차단 해제 후 목록 갱신
                            } else {
                                print("차단 해제 실패")
                            }
                        }
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
    }
}

extension BlackListVC: UITableViewDelegate {
    // 셀 높이 조정 (셀 자체 높이)
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    // 셀 사이에 간격 추가
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
}
