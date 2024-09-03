//
//  SettingVC.swift
//  WeClimb
//
//  Created by 강유정 on 9/2/24.
//

import UIKit

import RxSwift

class SettingVC: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel = SettingVM()
    
    private var sections: [SectionModel] = []

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 20
        tableView.isScrollEnabled = false // 스크롤 되지 않도록
        tableView.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        tableView.register(SettingCell.self, forCellReuseIdentifier: SettingCell.className)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        setNavigation()
        setLayout()
        bind()
    }
    
    func setNavigation() {
        self.title = SettingNameSpace.setting
    }
    
    private func setLayout() {
        view.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
        }
    }
    
     private func bind() {
         viewModel.items
             .observe(on: MainScheduler.instance)
             .subscribe(onNext: { [weak self] sections in
                 guard let self = self else { return }
                 
                 // 섹션 업데이트
                 self.sections = sections
                 
                 // 데이터 소스 및 셀 업데이트
                 self.tableView.reloadData()
             })
             .disposed(by: disposeBag)
         
         tableView.delegate = self
         tableView.dataSource = self
     }
 }

// 헤더 바인딩
extension SettingVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingCell.className, for: indexPath) as! SettingCell
        let item = sections[indexPath.section].items[indexPath.row]
        cell.configure(with: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch sections[section].section {
        case .notifications:
            return "알림 설정"
        case .policy:
            return "정책"
        case .account:
            return "계정 관리"
        }
    }
}
    

