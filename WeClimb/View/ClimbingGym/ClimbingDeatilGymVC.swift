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
    
    private let disposeBag = DisposeBag()
    private let viewModel: ClimbingDetailGymVM
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .lightGray
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 10
        return tableView
    }()
    
    init(viewModel: ClimbingDetailGymVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        bindTableView()
    }
    
    private func setupLayout() {
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func bindTableView() {
        tableView.register(SectionDetailTableViewCell.self, forCellReuseIdentifier: Identifiers.sectionDetailTableViewCell)
        
        viewModel.detailData
            .bind(to: tableView.rx.items(cellIdentifier: Identifiers.sectionDetailTableViewCell, cellType: SectionDetailTableViewCell.self)) { row, detailItem, cell in
                cell.configure(with: detailItem)
            }
            .disposed(by: disposeBag)
    }
}
