//
//  SettingVC.swift
//  WeClimb
//
//  Created by 강유정 on 9/2/24.
//

import UIKit
import RxSwift

//import SafariServices
//import UIKit
//
//import RxSwift
//import AuthenticationServices
//import FirebaseAuth
//
//class SettingVC: UIViewController {
//    
//    private let disposeBag = DisposeBag()
//    private let viewModel = SettingVM()
//    private let snsAuthVM = SNSAuthVM()
//    
//    private var datas: [SettingItem] = [
//        //        SettingItem(section: .notifications, titles: [SettingNameSpace.notifications]),
//        SettingItem(section: .policy, titles: [SettingNameSpace.termsOfService, SettingNameSpace.privacyPolic, SettingNameSpace.inquiry]),
//        SettingItem(section: .account, titles: [SettingNameSpace.editProfile, SettingNameSpace.blackList, SettingNameSpace.logout, SettingNameSpace.accountRemove]),
//    ]
//    
//    private let tableView: UITableView = {
//        let tableView = UITableView()
//        tableView.layer.cornerRadius = 20
//        tableView.isScrollEnabled = false // 스크롤 되지 않도록
//        tableView.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
//        tableView.register(SettingCell.self, forCellReuseIdentifier: SettingCell.className)
//        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
//        return tableView
//    }()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
//        setNavigation()
//        setLayout()
//        bindCell()
//    }
//    
//    func setNavigation() {
//        self.title = SettingNameSpace.setting
//    }
//    
//    private func setLayout() {
//        view.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
//        view.addSubview(tableView)
//        
//        tableView.snp.makeConstraints {
//            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
//            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
//            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(8)
//        }
//        tableView.dataSource = self
//        tableView.delegate = self
//    }
//    
//    // MARK: - 셀 클릭 이벤트 처리 YJ
//    private func bindCell() {
//        tableView.rx.itemSelected
//            .subscribe(onNext: { [weak self] indexPath in
//                guard let self = self else { return }
//                let selectedTitle = self.datas[indexPath.section].titles[indexPath.row]
//                
//                switch selectedTitle {
//                case SettingNameSpace.termsOfService:
//                    self.openWeb(urlString: "https://www.notion.so/iosclimber/104292bf48c947b2b3b7a8cacdf1d130")
//                case SettingNameSpace.privacyPolic:
//                    self.openWeb(urlString: "https://www.notion.so/iosclimber/146cdb8937944e18a0e055c892c52928")
//                case SettingNameSpace.inquiry:
//                    self.openWeb(urlString: "https://forms.gle/UUaJmFeLAyuFXFFS9")
//                case SettingNameSpace.editProfile:
//                    self.setEditProfile()
//                case SettingNameSpace.blackList:
//                    self.blackListMove()
//                case SettingNameSpace.logout:
//                    self.setLogout()
//                case SettingNameSpace.accountRemove:
//                    self.setDeleteUser()
//                default:
//                    break
//                }
//            })
//            .disposed(by: disposeBag)
//    }
//    
//    // MARK: - 웹 페이지 열기 YJ
//    private func openWeb(urlString: String) {
//        guard let url = URL(string: urlString) else { return }
//        let safariVC = SFSafariViewController(url: url)
//        present(safariVC, animated: true, completion: nil)
//    }
//    
//    
//    // MARK: - 프로필 편집 화면 전환
//    private func setEditProfile() {
//        let editPageVC = EditPageVC()
//        navigationController?.pushViewController(editPageVC, animated: true)
//    }
//    
//    // MARK: - 차단목록 화면전환 DS
//    private func blackListMove() {
//        let blackListVC = BlackListVC()
//        self.navigationController?.pushViewController(blackListVC, animated: true)
//    }
//    
//    
//    // MARK: - 로그아웃 및 화면전환 YJ
//    private func setLogout() {
//        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        
//        let logoutAction = UIAlertAction(title: SettingNameSpace.logout, style: .default) { [weak self] _ in
//            self?.viewModel.LogoutUser()
//                .observe(on: MainScheduler.instance)
//                .subscribe(onNext: {
//                    print("로그아웃 성공")
//                    self?.navigateToLoginVC() // 로그인 화면으로 전환
//                }, onError: { error in
//                    print("로그아웃 실패: \(error)")
//                })
//                .disposed(by: self?.disposeBag ?? DisposeBag())
//        }
//        let closeAction = UIAlertAction(title: "Close", style: .cancel)
//        [logoutAction, closeAction].forEach { actionSheet.addAction($0) }
//        present(actionSheet, animated: true)
//    }
//    
//    
//    // MARK: - 회원탈퇴 및 화면전환 YJ
//    private func setDeleteUser() {
//        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        
//        let deleteAction = UIAlertAction(title: SettingNameSpace.accountRemove, style: .destructive) { [weak self] _ in
//            guard let self else { return }
//            let alert = Alert()
//            alert.showAlert(from: self, title: "계정 삭제",
//                            message: "삭제하시겠습니까?",
//                            includeCancel: true) { [weak self] in
//                guard let self else { return }
//                self.reAuth { [weak self] result in
//                    guard let self else { return }
//                    if result {
//                        FirebaseManager.shared.userDelete { error in
//                            if let error = error {
//                                print("Error - Deleting User: \(error)")
//                                return
//                            }
//                            DispatchQueue.main.async { [weak self] in
//                                guard let self else { return }
//                                self.navigateToLoginVC()
//                            }
//                        }
//                    } else {
//                        let alert = Alert()
//                        alert.showAlert(from: self, title: "회원 탈퇴에 실패하였습니다.", message: "회원 탈퇴를 위해 재로그인 해주세요.")
//                    }
//                }
//            }
//        }
//        let closeAction = UIAlertAction(title: "Close", style: .cancel)
//        [deleteAction, closeAction].forEach { actionSheet.addAction($0) }
//        present(actionSheet, animated: true)
//    }
//    
//    func reAuth(completion: @escaping (Bool) -> Void) {
//        let loginType = viewModel.checkLoginType()
//        switch loginType {
//        case .apple:
//            snsAuthVM.appleLogin(delegate: self, provider: self)
//        case .google:
//            snsAuthVM.googleLogin(presenter: self) { [weak self] credential in
//                guard let self else { return}
//                self.snsAuthVM.reAuthenticate(with: credential) { error in
//                    if let error = error {
//                        print("Error - reAuth Google: \(error)")
//                        completion(false)
//                        return
//                    }
//                    completion(true)
//                }
//            }
//        case .kakao:
//            snsAuthVM.kakaoLogin { [weak self] credential in
//                guard let self else { return }
//                self.snsAuthVM.reAuthenticate(with: credential) { error in
//                    if let error = error {
//                        print("Error - reAuth Kakao: \(error)")
//                        completion(false)
//                    }
//                    completion(true)
//                }
//            }
//        case .none:
//            print("Error - unknown while reAuth")
//            completion(false)
//        }
//    }
//    
//    
//    // MARK: - 로그인 화면으로 전환 YJ
//    private func navigateToLoginVC() {
//        let loginVC = LoginVC()
//        let navigationController = UINavigationController(rootViewController: loginVC)
//        
//        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
//            if let window = scene.windows.first(where: \.isKeyWindow) {
//                window.rootViewController = navigationController
//                window.makeKeyAndVisible()
//            }
//        }
//    }
//}
//
//// 헤더 바인딩
//extension SettingVC: UITableViewDelegate, UITableViewDataSource {
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return datas.count
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return datas[section].titles.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingCell.className, for: indexPath) as? SettingCell else {
//            fatalError("SettingCell을 가져올 수 없음.")
//        }
//        
//        let item = datas[indexPath.section].titles[indexPath.row]
//        cell.configure(with: item)
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        switch datas[section].section {
//        case .notifications:
//            return "알림"
//        case .policy:
//            return "정책"
//        case .account:
//            return "계정 관리"
//        }
//    }
//    
//    // 헤더 높이
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 40
//    }
//}
//
//// MARK: Apple Login ReAuth
//extension SettingVC: ASAuthorizationControllerPresentationContextProviding {
//    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
//        return self.view.window!
//    }
//}
//
//extension SettingVC: ASAuthorizationControllerDelegate {
//        func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
//            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
//                guard let nonce = snsAuthVM.currentNonce else {
//                    fatalError("Invalid state: A login callback was received, but no login request was sent.")
//                }
//                guard let appleIDToken = appleIDCredential.identityToken else {
//                    print("Unable to fetch identity token")
//                    return
//                }
//                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
//                    print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
//                    return
//                }
//                // Initialize a Firebase credential, including the user's full name.
//                let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
//                                                               rawNonce: nonce,
//                                                               fullName: appleIDCredential.fullName)
//                // 파이어베이스 재인증
//                snsAuthVM.reAuthenticate(with: credential, completion: { error in
//                    if let error = error {
//                        print("Error - firebase reAuthenticate while deleting Account : \(error)")
//                        return
//                    }
//                    print("Apple ReAuth Succeed!")
//                    FirebaseManager.shared.userDelete { [weak self] error in
//                        guard let self else { return }
//                        if let error = error {
//                            print("Error - deleting apple account \(error)")
//                        }
//                        print("account from apple deleted")
//                        self.navigateToLoginVC()
//                    }
//                })
//            }
//        }
//    
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
//        // Handle error.
//        print("Sign in with Apple errored: \(error)")
//    }
//}

class SettingVC: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel: SettingViewModel
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 20
        tableView.isScrollEnabled = false
        tableView.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        tableView.register(SettingCell.self, forCellReuseIdentifier: SettingCell.className)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return tableView
    }()
    
    init(viewModel: SettingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        bindViewModel()
        setLayout()
    }
    
    private func bindViewModel() {
        let input = SettingViewModelImpl.Input(
            logout: tableView.rx.itemSelected
                .filter { $0.row == 2 }
                .map { _ in },
            deleteUser: tableView.rx.itemSelected
                .filter { $0.row == 3 }
                .map { _ in },
            reAuth: tableView.rx.itemSelected
                .filter { $0.row == 4 }
                .map { _ in },
            openWeb: tableView.rx.itemSelected
                .filter { $0.row == 0 }
                .map { _ in "https://example.com" }
        )
        
        let output = viewModel.transform(input: input)
        
        output.logoutResult
            .subscribe(onNext: { [weak self] in
                self?.navigateToLoginVC()
            })
            .disposed(by: disposeBag)
        
        output.deleteUserResult
            .subscribe(onNext: { [weak self] in
                self?.navigateToLoginVC()
            })
            .disposed(by: disposeBag)
        
        output.reAuthResult
            .subscribe(onNext: { success in
                if success {
                    print("재인증 성공")
                } else {
                    print("재인증 실패")
                }
            })
            .disposed(by: disposeBag)
        
        output.webNavigationResult
            .subscribe(onNext: { _ in
            })
            .disposed(by: disposeBag)
        
        output.error
            .subscribe(onNext: { [weak self] error in
                self?.showError(error)
            })
            .disposed(by: disposeBag)
    }
    
    private func setLayout() {
        view.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(8)
        }
//        tableView.dataSource = self
//        tableView.delegate = self
    }
    
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
    
    private func showError(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
