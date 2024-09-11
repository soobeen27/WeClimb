//
//  FeedCommentModalVC.swift
//  WeClimb
//
//  Created by 김솔비 on 9/6/24.
//

import UIKit

import SnapKit

class FeedCommentModalVC: UIViewController {
  
  private let tableView = UITableView()
  
  
  private let titleLabel: UILabel = {
      let label = UILabel()
      label.text = "댓 글"
      label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
      label.textAlignment = .center
//      label.textColor = .white
      return label
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
        
    setTableView()
    setLayout()
  }
  
  private func setTableView() {
    tableView.register(FeedCommentCell.self, forCellReuseIdentifier: Identifiers.commentTableViewCell)
    
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.separatorStyle  = .none
    tableView.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
    
    tableView.rowHeight = UITableView.automaticDimension  //셀 height 유동적으로 설정
    tableView.estimatedRowHeight = 70  //셀 height 기본값 설정(지금 안먹히는 듯..)
  }
  
  private func setLayout() {
    view.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
    [titleLabel, tableView]
      .forEach {
        view.addSubview($0)
      }
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(20)
      $0.centerX.equalToSuperview()
    }
    tableView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(20)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
}

extension FeedCommentModalVC: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return FeedNameSpace.commentList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.commentTableViewCell, for: indexPath) as! FeedCommentCell
    
    
    cell.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
    cell.selectionStyle = .none
    
    cell.commentProfileImage.image = UIImage(named: "testImage")
    cell.commentUser.text = "iOSClimber"
    cell.commentLabel.text = FeedNameSpace.commentList[indexPath.row]
    cell.likeButtonCounter.text = "10"
    
    return cell
  }
}
