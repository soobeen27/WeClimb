//
//  FeedReportModalVC.swift
//  WeClimb
//
//  Created by 김솔비 on 9/10/24.
//

import UIKit

import SnapKit

class FeedReportModalVC: UIViewController {
    
    private let tableView = UITableView()
    
    private let reportLabel: UILabel = {
        let label = UILabel()
        label.text = FeedNameSpace.reportLabel
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        setLayout()
    }
    
    private func setTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Identifiers.reportTableViewCell)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorInset.left = 0
        tableView.separatorColor = UIColor.systemGray3
        tableView.backgroundColor = UIColor(hex: "#0C1014")
    }
    
    private func setLayout() {
        view.backgroundColor = UIColor(hex: "#0C1014")
        
        [reportLabel, tableView]
            .forEach {
                view.addSubview($0)
            }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(reportLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }
        reportLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.leading.equalToSuperview().inset(16)
        }
    }
}

extension FeedReportModalVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FeedNameSpace.reportReasons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: Identifiers.reportTableViewCell)
//        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.reportTableViewCell, for:indexPath)
        
        cell.textLabel?.text = FeedNameSpace.reportReasons[indexPath.row]
        cell.textLabel?.textColor = .white
        cell.backgroundColor = UIColor(hex: "#0C1014")

        return cell
    }
    
    //셀 높이 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
