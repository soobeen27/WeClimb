//
//  PostCommentVC.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

class PostCommentVC: UIViewController {
    
    weak var coordinator: PostCommentCoordinator?
    
    private let commentVM: PostCommentVM
    
    private let postItem: PostItem
    private let disposeBag = DisposeBag()
    private let commentCellDatasRelay = BehaviorRelay<[CommentCellData]>.init(value: [])
    private let cellLongPressed = PublishRelay<(commentUID: String, authorUID: String)>()
    
    private let titleView = CommentTitleView()
    private let textFieldView = CommentTFView()
    private let commentTableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = CommentConsts.backgroundColor
        tv.separatorStyle = .none
        tv.register(PostCommentTableCell.self, forCellReuseIdentifier: PostCommentTableCell.className)
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        bindViewModel()
        bindTableView()
    }
    
    init(viewModel: PostCommentVM, postItem: PostItem) {
        self.commentVM = viewModel
        self.postItem = postItem
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bindViewModel() {
        let input = PostCommentVMImpl.Input(postItem: Observable.just(postItem), sendButtonTap: textFieldView.sendButtonTap, cellLongPressed: cellLongPressed)
        let output = commentVM.transform(input: input)
        output.commentCellDatas.bind(to: commentCellDatasRelay).disposed(by: disposeBag)
        output.postOwnerName
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { [weak self] name in
                guard let self else { return }
                self.textFieldView.postOwnerName = name
            })
            .disposed(by: disposeBag)
        
        cellLongPressed.subscribe(onNext: { data in
            print(data)
        }).disposed(by: disposeBag)
    }
    
    private func bindTableView() {
        commentCellDatasRelay
            .bind(to: commentTableView.rx
                .items(
                    cellIdentifier: PostCommentTableCell.className,
                    cellType: PostCommentTableCell.self))
                    { [weak self] (row, item, cell) in
                        guard let self else { return }
                        cell.configure(data: item)
                        cell.longPress.bind(to: self.cellLongPressed).disposed(by: cell.disposeBag)
                    }.disposed(by: disposeBag)
    }
    
    private func setLayout() {
        view.backgroundColor = CommentConsts.backgroundColor
        
        [titleView, textFieldView, commentTableView]
            .forEach { view.addSubview($0) }
        
        titleView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(CommentConsts.titleViewHeight)
        }
        
        textFieldView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(CommentConsts.TextFieldView.Size.height)
        }
        
        commentTableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(titleView.snp.bottom)
            $0.bottom.equalTo(textFieldView.snp.top)
        }
    }
    
//    private func actionSheet(for comment: Comment) {
//        var actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
////        guard let user = Auth.auth().currentUser else { return }
//        
//        if comment.authorUID == user.uid {
//            actionSheet = deleteActionSheet(comment: comment)
//        } else {
//            actionSheet = reportBlockActionSheet(comment: comment)
//        }
//        
//        self.present(actionSheet, animated: true, completion: nil)
//    }
    
    private func deleteActionSheet(comment: Comment) -> UIAlertController {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "삭제하기", style: .destructive) { [weak self] _ in
            guard let self else { return }
            let alert = Alert()
            alert.showAlert(from: self, title: "댓글 삭제", message: "삭제하시겠습니까?", includeCancel: true) {
//                self.viewModel.deleteComments(commentUID: comment.commentUID)
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        [deleteAction, cancelAction]
            .forEach {
                actionSheet.addAction($0)
            }
        return actionSheet
    }
    
    private func reportBlockActionSheet(comment: Comment) -> UIAlertController {
           let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
           
           let reportAction = UIAlertAction(title: "신고하기", style: .default) { [weak self] _ in
   //            self?.reportModal()
//               let modalVC = FeedReportModalVC()
//               self?.presentModal(modalVC: modalVC)
           }
           let blockAction = UIAlertAction(title: "차단하기", style: .destructive) { [weak self] _ in
               guard let self else { return }
//               self.blockUser(authorUID: comment.authorUID)
           }
           let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
           
           [reportAction, blockAction, cancelAction]
               .forEach {
                   actionSheet.addAction($0)
               }
           return actionSheet
       }
//       
//       //MARK: - 차단하기 관련 메서드
//       private func blockUser(authorUID: String) {
//           FirebaseManager.shared.addBlackList(blockedUser: authorUID) { [weak self] success in
//               guard let self else { return }
//               let alert = Alert()
//               if success {
//                   print("차단 성공: \(authorUID)")
//                   alert.showAlert(from: self, title: "차단 완료", message: "")
//               } else {
//                   print("차단 실패: \(authorUID)")
//                   alert.showAlert(from: self, title: "차단 실패", message: "차단을 실패했습니다. 다시 시도해주세요.")
//               }
//           }
//       }

}
