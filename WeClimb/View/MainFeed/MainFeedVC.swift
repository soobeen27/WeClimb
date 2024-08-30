//
//  MainFeedVC.swift
//  WeClimb
//
//  Created by Soo Jang on 8/26/24.
//

import UIKit

import SnapKit

class MainFeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setTableView()
        setLayout()
    }
    
    private func setNavigationBar() {
        self.title = "WeClimb"
        self.navigationController?.navigationBar.prefersLargeTitles = true
//        self.navigationController?.hidesBarsOnSwipe = true
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        appearance.shadowColor = .clear
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
    }
    
    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none  //셀 사이 라인 삭제
        tableView.register(MainFeedTabelCell.self, forCellReuseIdentifier: "MainFeedTabelCell")
    }
    
    private func setLayout() {        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5  //추후 변경
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 540
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainFeedTabelCell", for: indexPath) as? MainFeedTabelCell else {
            return UITableViewCell()
        }

        if let image = UIImage(named: "testImage") {
            cell.configure(userProfileImage: image, userName: "더 클라임 신림",
                           address: "서울시 관악구 신림동", caption: "클라이밍 재밌다아아아아아아아아아아아아아아아아아아아아아아아아아",
                           level: "V6", sector: "1섹터", dDay: "D-14", likeCounter: "444")
        }
        
        // 컬렉션 뷰의 데이터 소스 및 델리게이트 설정
        cell.collectionView.delegate = self
        cell.collectionView.dataSource = self
        cell.selectionStyle = .none
        
        return cell
    }
}

extension MainFeedVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YourCollectionViewCellIdentifier", for: indexPath)
        
        return cell
    }
}
