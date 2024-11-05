//
//  FeedCommentModalVC.swift
//  WeClimb
//
//  Created by 김솔비 on 9/6/24.
//

//import UIKit
//
//import SnapKit
//
//class CommentModalVC: UIViewController {
//
//  private let tableView = UITableView()
//
//
//  private let titleLabel: UILabel = {
//    let label = UILabel()
//    label.text = "댓 글"
//    label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
//    label.textAlignment = .center
//    //      label.textColor = .white
//    return label
//  }()
//
//  override func viewDidLoad() {
//    super.viewDidLoad()
//
//    setTableView()
//    setLayout()
//  }
//
//  override func viewDidAppear(_ animated: Bool) {
//    super.viewDidAppear(animated)
//  }
//
//  private func setTableView() {
//    tableView.register(CommentCell.self, forCellReuseIdentifier: Identifiers.commentTableViewCell)
//
//    tableView.delegate = self
//    tableView.dataSource = self
//
//    tableView.separatorStyle  = .none
//    tableView.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
//
//    tableView.rowHeight = UITableView.automaticDimension  //셀 height 유동적으로 설정
//    tableView.estimatedRowHeight = 70  //셀 height 기본값 설정(지금 안먹히는 듯..)
////    tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
//  }
//
//  private func setLayout() {
//    view.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
//    [titleLabel, tableView]
//      .forEach {
//        view.addSubview($0)
//      }
//    titleLabel.snp.makeConstraints {
//      $0.top.equalToSuperview().offset(20)
//      $0.centerX.equalToSuperview()
//    }
//    tableView.snp.makeConstraints {
//      $0.top.equalTo(titleLabel.snp.bottom).offset(20)
//      $0.leading.trailing.bottom.equalToSuperview()
//    }
//  }
//}
//
//extension CommentModalVC: UITableViewDelegate, UITableViewDataSource {
//  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    return FeedNameSpace.commentList.count
//  }
//
//  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.commentTableViewCell, for: indexPath) as? CommentCell else {
//      return UITableViewCell()
//    }
//
//    cell.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
//    cell.selectionStyle = .none
//
//    if let image = UIImage(named: "testImage") {
//      cell.configure(userImage: image,
//                     userName: "iOSClimber",
//                     userComment: FeedNameSpace.commentList[indexPath.row],
//                     likeCounter: "10")
//    }
//    return cell
//  }
//}
import UIKit

import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

class CommentModalVC: UIViewController {
    
    private var viewModel: CommentVM
    
    let disposeBag = DisposeBag()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
//        tableView.rowHeight = UITableView.automaticDimension
//        tableView.estimatedRowHeight = 70
        tableView.rowHeight = 70
        tableView.register(CommentCell.self, forCellReuseIdentifier: CommentCell.className)
        return tableView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "댓 글"
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let commentTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "댓글을 입력하세요..."
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        return textField
    }()
    
    private let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("전송", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return button
    }()
    
    init(viewModel: CommentVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        setLayout()
        submitButtonBind()
    }
    
    private func setTableView() {
        viewModel.comments
            .asDriver()
            .drive(tableView.rx
                .items(cellIdentifier: CommentCell.className
                       ,cellType: CommentCell.self)) { index, item, cell in
                cell.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
                cell.selectionStyle = .none
                FirebaseManager.shared.getUserInfoFrom(uid: item.authorUID) { result in
                    switch result {
                    case .success(let user):
                        cell.configure(userImageString: user.profileImage ?? "", userName: user.userName ?? "", userComment: item.content, likeCounter: item.like?.count ?? 0)
                    case .failure(let error):
                        print("Error - :\(error)")
                    }
                }
            }.disposed(by: disposeBag)
    }
    
    private func submitButtonBind() {
        submitButton.rx.tap
            .asSignal()
            .emit { [weak self] _ in
                guard let self else { return }
                print("it's called")
                let userUID = FirebaseManager.shared.currentUserUID()
                let post = self.viewModel.post
                self.viewModel.addComment(userUID: userUID, fromPostUid: post.postUID , content: self.commentTextField.text ?? "")
            }
            .disposed(by: disposeBag)
    }
    
    private func setLayout() {
        view.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        
        [titleLabel, commentTextField, submitButton, tableView].forEach {
            view.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
        }
        
        commentTextField.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16) // 왼쪽 여백 추가
            $0.trailing.equalTo(submitButton.snp.leading).offset(-8) // 버튼과의 간격 설정
            $0.height.equalTo(40) // 텍스트 필드 높이 설정
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10) // 하단에 고정
        }
        
        submitButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16) // 오른쪽 여백 추가
            $0.centerY.equalTo(commentTextField) // 텍스트 필드와 수직 정렬
            $0.width.equalTo(50) // 버튼 너비 설정
            $0.height.equalTo(40) // 버튼 높이 설정
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(commentTextField.snp.top).offset(-10) // 텍스트 필드 위에 위치
        }
    }
}

//extension CommentModalVC: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return FeedNameSpace.commentList.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.commentTableViewCell, for: indexPath) as? CommentCell else {
//            return UITableViewCell()
//        }
//        
//        cell.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
//        cell.selectionStyle = .none
//        
//        if let image = UIImage(named: "testImage") {
//            cell.configure(userImage: image,
//                           userName: "iOSClimber",
//                           userComment: FeedNameSpace.commentList[indexPath.row],
//                           likeCounter: "10")
//        }
//        
//        return cell
//    }
//}
