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
    
    private var datas: [SettingItem] = [
        SettingItem(section: .notifications, titles: [SettingNameSpace.notifications]),
        SettingItem(section: .policy, titles: [SettingNameSpace.termsOfService, SettingNameSpace.privacyPolic]),
        SettingItem(section: .account, titles: [SettingNameSpace.logout, SettingNameSpace.accountRemove])
    ]
    
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
        bindCell()
    }
    
    func setNavigation() {
        self.title = SettingNameSpace.setting
    }
    
    private func setLayout() {
        view.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(8)
        }
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - 셀 클릭 이벤트 처리 YJ
    private func bindCell() {
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                let selectedTitle = self.datas[indexPath.section].titles[indexPath.row]
                
                switch selectedTitle {
                    
                case SettingNameSpace.logout:
                    self.setLogout()
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - 로그아웃 및 화면전환 YJ
    private func setLogout() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: UserPageNameSpace.logout, style: .default) { [weak self] _ in
            
            self?.viewModel.performLogout()
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: {
                    print("로그아웃 성공")
                    
                    // 로그인 화면으로 전환
                    let loginVC = LoginVC()
                    let navigationController = UINavigationController(rootViewController: loginVC)
                    
                    // 현재 활성화된 씬에서 화면 전환
                    if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                        if let window = scene.windows.first(where: \.isKeyWindow) {
                            window.rootViewController = navigationController
                            window.makeKeyAndVisible()
                        }
                    }
                }, onError: { error in
                    print("로그아웃 실패: \(error)")
                    
                })
                .disposed(by: self?.disposeBag ?? DisposeBag())
        }
        
        let closeAction = UIAlertAction(title: "Close", style: .cancel)
        [logoutAction, closeAction].forEach { actionSheet.addAction($0) }
        present(actionSheet, animated: true)
        
    }
}

// 헤더 바인딩
extension SettingVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas[section].titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingCell.className, for: indexPath) as? SettingCell else {
            fatalError("SettingCell을 가져올 수 없음.")
        }
        
        let item = datas[indexPath.section].titles[indexPath.row]
        cell.configure(with: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch datas[section].section {
        case .notifications:
            return "알림"
        case .policy:
            return "정책"
        case .account:
            return "계정 관리"
        }
    }
    
    // 헤더 높이
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}
