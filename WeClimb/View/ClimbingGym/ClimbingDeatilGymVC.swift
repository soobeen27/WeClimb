//
//  ClimbingDeatilGymVC.swift
//  WeClimb
//
//  Created by 머성이 on 8/30/24.
//

import UIKit

import SnapKit
import RxCocoa
import RxSwift

class ClimbingDetailGymVC: UIViewController {
    
    let disposeBag = DisposeBag()
    
    // 상세 화면에 표시할 데이터를 담는 프로퍼티
    let detailData = BehaviorRelay<[DetailItem]>(value: [])
    
    // 테이블 뷰 구성
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        bindTableView()
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func bindTableView() {
        tableView.register(SectionDetailTableViewCell.self, forCellReuseIdentifier: Identifiers.sectionDetailTableViewCell)
        
        detailData
            .bind(to: tableView.rx.items(cellIdentifier: Identifiers.sectionDetailTableViewCell, cellType: SectionDetailTableViewCell.self)) { row, detailItem, cell in
                cell.configure(with: detailItem)
            }
            .disposed(by: disposeBag)
    }
}
