//
//  EditPageVC.swift
//  WeClimb
//
//  Created by 강유정 on 8/29/24.
//

import UIKit

import RxSwift
import SnapKit

class EditPageVC: UIViewController {
    
    private let viewModel = EditPageViewModel()
    private let disposeBag = DisposeBag()
    
    private let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 20
        tableView.register(EditPageCell.self, forCellReuseIdentifier: EditPageCell.className)
        return tableView
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .systemGroupedBackground
        
        setNavigation()
        setLayout()
        bind()
    }
    
    func setNavigation() {
        self.title = MypageNameSpace.edit
        }
    
    private func setLayout() {
        [profileImage, tableView]
            .forEach { view.addSubview($0) }
        
        profileImage.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(100)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(profileImage.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(340)
        }
    }
    
    private func bind() {
        viewModel.items
            .bind(to: tableView.rx.items(cellIdentifier: EditPageCell.className, cellType: EditPageCell.self)) { row, item, cell in
                 cell.configure(with: item.title, info: item.info)
             }
             .disposed(by: disposeBag)
     }
    
}
