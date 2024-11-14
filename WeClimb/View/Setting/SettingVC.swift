//
//  SettingVC.swift
//  WeClimb
//
//  Created by 강유정 on 9/2/24.
//

import SafariServices
import UIKit

import RxSwift
import AuthenticationServices
import FirebaseAuth

class SettingVC: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel = SettingVM()
    private let snsAuthVM = SNSAuthVM()
    
    private var datas: [SettingItem] = [
        //        SettingItem(section: .notifications, titles: [SettingNameSpace.notifications]),
        SettingItem(section: .policy, titles: [SettingNameSpace.termsOfService, SettingNameSpace.privacyPolic, SettingNameSpace.inquiry]),
        SettingItem(section: .account, titles: [SettingNameSpace.editProfile, SettingNameSpace.blackList, SettingNameSpace.logout, SettingNameSpace.accountRemove]),
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
        FirebaseManager.shared.getFilteredPost(gymName: "9클라이밍", grade: "빨",hold: "빨", height: [100,200], armReach: [100,200], completion: { snapshot in
            print("snapshot@@@@@@@@@@@@@@@@@@@:::::::::::\(snapshot)")
        })
            .subscribe(onSuccess: { posts in
                print(posts)
                posts.forEach { post in
                    print("@@@@@@@@@@@@@@@@@@@@\(post)")
                }
            }, onFailure: { error in
                print("@@@@@@@@@@@@@이거 왜 실패? \(error)")
            })
            .disposed(by: disposeBag)
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
//            self?.viewModel.deleteUser()
//                .observe(on: MainScheduler.instance)
//                .subscribe(onNext: {
//                    print("회원탈퇴 성공")
//                    self?.navigateToLoginVC() // 로그인 화면으로 전환
//                }, onError: { error in
//                    print("회원탈퇴 실패: \(error.localizedDescription)")
//                })
//                .disposed(by: self?.disposeBag ?? DisposeBag())
            guard let self else { return }
            self.reAuth { result in
                if result {
                    FirebaseManager.shared.userDelete { error in
                        if let error = error {
                            print("Error - Deleting User: \(error)")
                            return
                        }
                        print("User Deleted Successfully")
                        self.navigateToLoginVC()
                    }
                } else {
                    CommonManager.shared.showAlert(from: self, title: "회원 탈퇴에 실패하였습니다.", message: "회원 탈퇴를 위해 재로그인 해주세요.")
                }
            }
        }
        let closeAction = UIAlertAction(title: "Close", style: .cancel)
        [deleteAction, closeAction].forEach { actionSheet.addAction($0) }
        present(actionSheet, animated: true)
    }
    
    func reAuth(completion: @escaping (Bool) -> Void) {
        let loginType = viewModel.checkLoginType()
        switch loginType {
        case .apple:
            snsAuthVM.appleLogin(delegate: self, provider: self)
        case .google:
            snsAuthVM.googleLogin(presenter: self) { [weak self] credential in
                guard let self else { return}
                self.snsAuthVM.reAuthenticate(with: credential) { error in
                    if let error = error {
                        print("Error - reAuth Google: \(error)")
                        completion(false)
                        return
                    }
                    completion(true)
                }
            }
        case .kakao:
            snsAuthVM.kakaoLogin { [weak self] credential in
                guard let self else { return }
                self.snsAuthVM.reAuthenticate(with: credential) { error in
                    if let error = error {
                        print("Error - reAuth Kakao: \(error)")
                        completion(false)
                    }
                    completion(true)
                }
            }
        case .none:
            print("Error - unknown while reAuth")
            completion(false)
        }
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

// MARK: Apple Login ReAuth
extension SettingVC: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

extension SettingVC: ASAuthorizationControllerDelegate {
        func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                guard let nonce = snsAuthVM.currentNonce else {
                    fatalError("Invalid state: A login callback was received, but no login request was sent.")
                }
                guard let appleIDToken = appleIDCredential.identityToken else {
                    print("Unable to fetch identity token")
                    return
                }
                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                    return
                }
                // Initialize a Firebase credential, including the user's full name.
                let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                               rawNonce: nonce,
                                                               fullName: appleIDCredential.fullName)
                // 파이어베이스 재인증
                snsAuthVM.reAuthenticate(with: credential, completion: { error in
                    if let error = error {
                        print("Error - firebase reAuthenticate while deleting Account : \(error)")
                        return
                    }
                    print("Apple ReAuth Succeed!")
                })
            }
        }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
}
