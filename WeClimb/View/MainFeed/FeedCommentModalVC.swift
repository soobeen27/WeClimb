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
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  private func setTableView() {
    tableView.register(FeedCommentCell.self, forCellReuseIdentifier: Identifiers.commentTableViewCell)
    
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.separatorStyle  = .none
    tableView.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
    
    tableView.rowHeight = UITableView.automaticDimension  //셀 height 유동적으로 설정
    tableView.estimatedRowHeight = 70  //셀 height 기본값 설정(지금 안먹히는 듯..)
//    tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
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
    guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.commentTableViewCell, for: indexPath) as? FeedCommentCell else {
      return UITableViewCell()
    }
    
    cell.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
    cell.selectionStyle = .none
    
    if let image = UIImage(named: "testImage") {
      cell.configure(userImage: image,
                     userName: "iOSClimber",
                     userComment: FeedNameSpace.commentList[indexPath.row],
                     likeCounter: "10")
    }
    return cell
  }
}
