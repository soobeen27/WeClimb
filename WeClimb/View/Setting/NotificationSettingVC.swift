//
//  NotificationSetting.swift
//  WeClimb
//
//  Created by Soobeen Jang on 12/19/24.
//
import UIKit

import Firebase
import FirebaseAuth
import SnapKit
import RxSwift
import RxCocoa

class NotificationSettingVC: UIViewController {
    
    private let db = Firestore.firestore()
    private var userUID: String?
    private var notifiSetting: [Bool] = [false, false, false]
    private let disposeBag = DisposeBag()
    
    private let data = BehaviorRelay<[(type: NotificationSetting, isOn: Bool)]>.init(value: NotificationSetting.allCases.map { type in
        (type: type, isOn: false)
    })
    
    private let notificationSettingTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(NotificationSettingTableCell.self,
                           forCellReuseIdentifier: NotificationSettingTableCell.className)
        tableView.isScrollEnabled = false
        tableView.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setLayout()
        getUserUID()
        notificationSettingTableViewBind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getNotificationSetting()
    }
    
    private func notificationSettingTableViewBind() {
        data.bind(to: notificationSettingTableView.rx.items(cellIdentifier: NotificationSettingTableCell.className, cellType: NotificationSettingTableCell.self)) { [weak self] indexPath, data, cell in
            guard let self else { return }
            cell.configure(title: data.type.description, isOn: data.isOn)
            cell.selectionStyle = .none
            cell.disposeBag = DisposeBag()
            cell.rightSwitch.rx.isOn
                .skip(1)
                .distinctUntilChanged()
                .asDriver(onErrorJustReturn: false)
                .drive(onNext: { [weak self] isOn in
                    guard let self else { return }
                    self.notificationSettingToggle(type: data.type, isOn: isOn)
                })
                .disposed(by: cell.disposeBag)
        }
        .disposed(by: disposeBag)
    }

    private func setNavigationBar() {
        navigationItem.title = "알림"   
    }
    
    private func setLayout() {
        self.view.addSubview(notificationSettingTableView)
        
        notificationSettingTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func notificationSettingToggle(type: NotificationSetting, isOn: Bool) {
        guard let userUID else { return }
        let userRef = db.collection("users").document(userUID)
        userRef.updateData([type.fieldName : isOn]) { error in
            if let error {
                print("토글 누르다 에러남: \(error)")
            }
        }
    }
    
    private func getNotificationSetting() {
            guard let userUID else { return }
            let userRef = db.collection("users").document(userUID)
            userRef.getDocument { [weak self] snapshot, error in
                guard let self else { return }
                if let error {
                    print("notificationSetting 가져오다 에러남: \(error)")
                    return
                } else {
                    guard let snapshot else { return }
                    guard let data = snapshot.data() else {
                        let currentData = self.data.value
                        let newData = currentData.map {
                            ($0.type, true)
                        }
                        self.data.accept(newData)
                        return
                    }
                    var newData: [(NotificationSetting, Bool)] = []
                    NotificationSetting.allCases.forEach { setting in
                        newData.append((setting, data[setting.fieldName] as? Bool ?? true))
                    }
                    self.data.accept(newData)
            }
        }
    }
    
    private func getUserUID() {
        userUID = Auth.auth().currentUser?.uid
    }
}

enum NotificationSetting: CaseIterable {
//    case all
    case like
    case comment
    
    var description: String {
        switch self {
//        case .all: return "모든 알림"
        case .like: return "좋아요 알림"
        case .comment: return "댓글 알림"
        }
    }
    
    var fieldName: String {
        switch self {
//        case .all: return "allNotification"
        case .like: return "likeNotification"
        case .comment: return "commentNotification"
        }
    }
}
