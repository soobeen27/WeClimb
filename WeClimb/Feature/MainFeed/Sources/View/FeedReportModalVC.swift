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
    private var userName: String?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = FeedNameSpace.reportTitle
//        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    private let reportLabel: UILabel = {
        let label = UILabel()
        label.text = FeedNameSpace.reportLabel
        label.textColor = .gray
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserInfo()
       
        setTableView()
        setLayout()
    }
    
    private func setTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Identifiers.reportTableViewCell)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorInset.left = 0
        tableView.separatorColor = UIColor.systemGray3.withAlphaComponent(0.5)
        tableView.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
    }
     
    //현재 유저 정보를 가져와 닉네임 설정 - DS
    func fetchUserInfo() {
        FirebaseManager.shared.currentUserInfo { [weak self] result in
            switch result {
            case .success(let user):
                self?.userName = user.userName
//                print("\(user.userName)")
            case .failure(let error):
                print("현재 유저 정보 가져오기 에러: \(error.localizedDescription)")
            }
        }
    }
    
    private func setLayout() {
        view.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        
        [titleLabel, reportLabel, tableView]
            .forEach {
                view.addSubview($0)
            }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(reportLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
          $0.top.equalToSuperview().offset(20)
          $0.centerX.equalToSuperview()
        }
        reportLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(25)
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
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        cell.backgroundColor = UIColor(named: "BackgroundColor") ?? .black

        return cell
    }
    
    //셀 이벤트 클릭 이벤트 - DS
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let userName = userName else {
            print("유저 네임을 가지고 오지 못했습니다..")
            return
        }
        
        let selectedReport = FeedNameSpace.reportReasons[indexPath.row]
        
        FirebaseManager.shared.userReport(content: selectedReport, userName: userName) { result in
            switch result {
            case .success():
                print("신고가 성공적으로 전송되었습니다.")
            case .failure(let error):
                print("신고 전송 중 오류 발생: \(error.localizedDescription)")
            }
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let alert = Alert()
            alert.showAlert(from: self,
                            title: "알림",
                            message: "신고 완료")
        }
    }
}
    
    //셀 높이 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
