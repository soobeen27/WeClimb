//
//  SettingVC.swift
//  WeClimb
//
//  Created by 강유정 on 9/2/24.
//

import SafariServices
import UIKit

import RxSwift

class SettingVC: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel = SettingVM()
    
    private var datas: [SettingItem] = [
        //        SettingItem(section: .notifications, titles: [SettingNameSpace.notifications]),
        SettingItem(section: .policy, titles: [SettingNameSpace.termsOfService, SettingNameSpace.privacyPolic]),
        SettingItem(section: .account, titles: [SettingNameSpace.editProfile, SettingNameSpace.logout, SettingNameSpace.accountRemove]),
        SettingItem(section: .account, titles: [SettingNameSpace.blackList, SettingNameSpace.logout, SettingNameSpace.accountRemove])
    ]
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 20
        tableView.isScrollEnabled = false // 스크롤 되지 않도록
        tableView.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        tableView.register(SettingCell.self, forCellReuseIdentifier: SettingCell.className)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
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
                case SettingNameSpace.termsOfService:
                    self.openWeb(urlString: "https://www.notion.so/iosclimber/104292bf48c947b2b3b7a8cacdf1d130")
                case SettingNameSpace.privacyPolic:
                    self.openWeb(urlString: "https://www.notion.so/iosclimber/146cdb8937944e18a0e055c892c52928")
                case SettingNameSpace.inquiry:
                          self.openWeb(urlString: "https://forms.gle/UUaJmFeLAyuFXFFS9")
                case SettingNameSpace.editProfile:
                    self.setEditProfile()
                case SettingNameSpace.blackList:
                    self.blackListMove()
                case SettingNameSpace.logout:
                    self.setLogout()
                case SettingNameSpace.accountRemove:
                    self.setDeleteUser()
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
    
    
    // MARK: - 웹 페이지 열기 YJ
    private func openWeb(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true, completion: nil)
    }
    
    
    // MARK: - 프로필 편집 화면 전환
    private func setEditProfile() {
        let editPageVC = EditPageVC()
        navigationController?.pushViewController(editPageVC, animated: true)
    }
    
    // MARK: - 차단목록 화면전환 DS
    private func blackListMove() {
        let blackListVC = BlackListVC()
        self.navigationController?.pushViewController(blackListVC, animated: true)
    }
    
    
    // MARK: - 로그아웃 및 화면전환 YJ
    private func setLogout() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let logoutAction = UIAlertAction(title: SettingNameSpace.logout, style: .default) { [weak self] _ in
            self?.viewModel.LogoutUser()
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: {
                    print("로그아웃 성공")
                    self?.navigateToLoginVC() // 로그인 화면으로 전환
                }, onError: { error in
                    print("로그아웃 실패: \(error)")
                })
                .disposed(by: self?.disposeBag ?? DisposeBag())
        }
        let closeAction = UIAlertAction(title: "Close", style: .cancel)
        [logoutAction, closeAction].forEach { actionSheet.addAction($0) }
        present(actionSheet, animated: true)
    }
    
    
    // MARK: - 회원탈퇴 및 화면전환 YJ
    private func setDeleteUser() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: SettingNameSpace.accountRemove, style: .destructive) { [weak self] _ in
            self?.viewModel.deleteUser()
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: {
                    print("회원탈퇴 성공")
                    self?.navigateToLoginVC() // 로그인 화면으로 전환
                }, onError: { error in
                    print("회원탈퇴 실패: \(error.localizedDescription)")
                })
                .disposed(by: self?.disposeBag ?? DisposeBag())
        }
        let closeAction = UIAlertAction(title: "Close", style: .cancel)
        [deleteAction, closeAction].forEach { actionSheet.addAction($0) }
        present(actionSheet, animated: true)
    }
    
    
    // MARK: - 로그인 화면으로 전환 YJ
    private func navigateToLoginVC() {
        let loginVC = LoginVC()
        let navigationController = UINavigationController(rootViewController: loginVC)
        
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let window = scene.windows.first(where: \.isKeyWindow) {
                window.rootViewController = navigationController
                window.makeKeyAndVisible()
            }
        }
    }
}

// 헤더 바인딩
extension SettingVC: UITableViewDelegate, UITableViewDataSource {
    
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
