//
//  FeedCommentModalVC.swift
//  WeClimb
//
//  Created by 김솔비 on 9/6/24.
//
import UIKit

import SnapKit
import RxSwift
import RxCocoa
import Kingfisher
import FirebaseAuth

class CommentModalVC: UIViewController, UIScrollViewDelegate {
    
    private var viewModel: CommentVM
    
    let disposeBag = DisposeBag()
    private var lastContentOffset: CGPoint = .zero
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        tableView.rowHeight = 70
        tableView.register(CommentCell.self, forCellReuseIdentifier: CommentCell.className)
        return tableView
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "댓 글"
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var commentTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "댓글 추가.."
        textField.layer.cornerRadius = 20
        textField.layer.masksToBounds = true
        textField.backgroundColor = UIColor.secondarySystemFill
        textField.font = UIFont.systemFont(ofSize: 14)
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.rightView = paddingView
        textField.rightViewMode = .always
        return textField
    }()
    
    private let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("전송", for: .normal)
        button.setTitleColor(UIColor.white , for: .normal)
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
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
        setKeyboard()
        setTextField()
        setProfileImageView()
    }
    
    private func setTableView() {
        viewModel.comments
            .asDriver()
            .drive(tableView.rx
                .items(cellIdentifier: CommentCell.className
                       ,cellType: CommentCell.self)) { [weak self] index, item, cell in
                guard let self else { return }
                cell.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
                cell.selectionStyle = .none
                FirebaseManager.shared.getUserInfoFrom(uid: item.authorUID) { result in
                    switch result {
                    case .success(let user):
                        cell.configure(commentCellVM: CommentCellVM(user: user, comment: item, post: self.viewModel.post))
                    case .failure(let error):
                        print("Error - :\(error)")
                    }
                }
                cell.longPress
                    .asDriver(onErrorJustReturn: nil)
                    .throttle(.milliseconds(3000))
                    .drive(onNext: { [weak self] comment in
                        guard let self, let comment else { return }
                        self.actionSheet(for: comment)
                        print("Long Pressed")
                    
                    })
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
        
    private func setProfileImageView() {
        FirebaseManager.shared.currentUserInfo { [weak self] result in
            switch result {
            case .success(let user):
                if let imageString = user.profileImage {
                    let imageURL = URL(string: imageString)
                    self?.profileImageView.kf.setImage(with: imageURL)
                } else {
                    self?.profileImageView.image = UIImage(named: "testStone")
                }
            case .failure(let error):
                print("Error - \(#file) \(#function)")
            }
        }
    }
    
    private func setTextField() {
        commentTextField.rx.text
            .asDriver()
            .drive(onNext: { [weak self] text in
                guard let self else { return }
                if let text, !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    self.submitButton.isEnabled = true
                    self.submitButton.backgroundColor = .systemBlue
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func submitButtonBind() {
        submitButton.rx.tap
            .asSignal()
            .throttle(.milliseconds(2000))
            .emit { [weak self] _ in
                guard let self else { return }
                let userUID = FirebaseManager.shared.currentUserUID()
                let post = self.viewModel.post
                self.viewModel.addComment(userUID: userUID, fromPostUid: post.postUID, content: self.commentTextField.text ?? "")
                self.commentTextField.text = nil
                self.submitButton.isEnabled = false
                self.submitButton.backgroundColor = nil
            }
            .disposed(by: disposeBag)
    }
    
    private func setKeyboard() {
//        tableView.keyboardDismissMode = .interactive
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { [weak self] notification in
                guard let userInfo = notification.userInfo,
                      let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
                      let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
                      let curveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt,
                      let self
                else { return }
                let animationOption = UIView.AnimationOptions(rawValue: curveValue << 16)
                
                UIView.animate(withDuration: duration, delay: 0, options: animationOption) {
                    self.commentTextField.snp.updateConstraints {
//                        $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-keyboardFrame.height + 10)
                        $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(keyboardFrame.height - 10)
                        self.view.layoutIfNeeded()
                    }
                }
            })
            .disposed(by: disposeBag)
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { [weak self] notification in
                guard let userInfo = notification.userInfo,
                      let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
                      let curveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt,
                      let self
                else { return }
                let animationOption = UIView.AnimationOptions(rawValue: curveValue << 16)

                UIView.animate(withDuration: duration, delay: 0, options: animationOption) {
                    self.commentTextField.snp.updateConstraints {
                        $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-10)
//                        $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
                        self.view.layoutIfNeeded()
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func actionSheet(for comment: Comment) {
        var actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        guard let user = Auth.auth().currentUser else { return }
        
        if comment.authorUID == user.uid {
            actionSheet = deleteActionSheet(comment: comment)
        } else {
            actionSheet = reportBlockActionSheet(comment: comment)
        }
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    private func deleteActionSheet(comment: Comment) -> UIAlertController {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "삭제하기", style: .destructive) { [weak self] _ in
            guard let self else { return }
            self.viewModel.deleteComments(commentUID: comment.commentUID)
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
            let modalVC = FeedReportModalVC()
            self?.presentModal(modalVC: modalVC)
        }
        let blockAction = UIAlertAction(title: "차단하기", style: .destructive) { [weak self] _ in
            guard let self else { return }
            self.blockUser(authorUID: comment.authorUID)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        [reportAction, blockAction, cancelAction]
            .forEach {
                actionSheet.addAction($0)
            }
        return actionSheet
    }
    
    //MARK: - 차단하기 관련 메서드
    private func blockUser(authorUID: String) {
        FirebaseManager.shared.addBlackList(blockedUser: authorUID) { [weak self] success in
            guard let self else { return }
            
            if success {
                print("차단 성공: \(authorUID)")
                CommonManager.shared.showAlert(from: self, title: "차단 완료", message: "")
            } else {
                print("차단 실패: \(authorUID)")
                CommonManager.shared.showAlert(from: self, title: "차단 실패", message: "차단을 실패했습니다. 다시 시도해주세요.")
            }
        }
    }

    private func setLayout() {
        view.overrideUserInterfaceStyle = .dark
        view.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        
        [titleLabel, commentTextField, submitButton, tableView, profileImageView].forEach {
            view.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
        }
        profileImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(8)
            $0.trailing.equalTo(commentTextField.snp.leading).offset(-8)
            $0.centerY.equalTo(commentTextField) // 텍스트 필드와 수직 정렬
            $0.size.equalTo(40)
        }
        
        commentTextField.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(8)
            $0.trailing.equalTo(submitButton.snp.leading).offset(-8) // 버튼과의 간격 설정
            $0.height.equalTo(40) // 텍스트 필드 높이 설정
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
//            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        submitButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(8) // 오른쪽 여백 추가
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

extension CommentModalVC: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        
        if currentOffset + 30 < lastContentOffset.y {
            self.view.endEditing(true)
        }
        lastContentOffset = scrollView.contentOffset
    }
}
