//
//  SettingVC.swift
//  WeClimb
//
//  Created by 강유정 on 9/2/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import AuthenticationServices
import FirebaseAuth

class SettingVC: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel: SettingViewModel
    private var datas: [SettingItem] = []
    
    private let snsAuthVM = SNSAuthVM()
    
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
        bindSectionData()
        bindNavigateToLogin()
        setLayout()
        bindrequestReAuth()
    }
    
    private func bindSectionData() {
        viewModel.sectionData
            .asDriver()
            .drive(onNext: { [weak self] data in
                self?.datas = data
            })
            .disposed(by: disposeBag)
    }
    
    private func bindNavigateToLogin() {
        viewModel.navigateToLogin
            .subscribe(onNext: { [weak self] in
                self?.navigateToLogin()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindrequestReAuth() {
        viewModel.requestReAuth
            .subscribe(onNext: { [weak self] in
                self?.startAppleReAuth()
            })
            .disposed(by: disposeBag)
    }
    
    private func navigateToProfile() {
        let editPageVC = EditPageVC()
        navigationController?.pushViewController(editPageVC, animated: true)
    }
    
    private func navigateToBlackList() {
        let blackListVC = BlackListVC()
        self.navigationController?.pushViewController(blackListVC, animated: true)
    }
    
    private func showLogoutAlert() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let logoutAction = UIAlertAction(title: SettingNameSpace.logout, style: .default) { [weak self] _ in
            self?.viewModel.triggerLogout()
        }
        
        let closeAction = UIAlertAction(title: "Close", style: .cancel)
        [logoutAction, closeAction].forEach { actionSheet.addAction($0) }
        present(actionSheet, animated: true)
    }
    
    private func navigateToLogin() {
        let loginVC = LoginVC()
        let navigationController = UINavigationController(rootViewController: loginVC)
        
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let window = scene.windows.first(where: \.isKeyWindow) {
                window.rootViewController = navigationController
                window.makeKeyAndVisible()
            }
        }
    }
    
    private func showAccountDeletionAlert() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: SettingNameSpace.accountRemove, style: .destructive) { [weak self] _ in
            self?.confirmAccountDeletion()
        }
        
        let closeAction = UIAlertAction(title: "Close", style: .cancel)
        
        [deleteAction, closeAction].forEach { actionSheet.addAction($0) }
        present(actionSheet, animated: true)
    }

    private func confirmAccountDeletion() {
        let alert = Alert()
        alert.showAlert(from: self, title: "계정 삭제", message: "삭제하시겠습니까?", includeCancel: true) { [weak self] in
            self?.triggerAccountDeletion()
        }
    }

    private func triggerAccountDeletion() {
        viewModel.triggerAccountDeletion()
        
        viewModel.accountDeletionResult
            .subscribe(onNext: { [weak self] result in
                guard let self else { return }
                self.handleAccountDeletionResult(result)
            })
            .disposed(by: disposeBag)
    }

    private func handleAccountDeletionResult(_ result: Bool) {
        if result {
            navigateToLogin()
        } else {
            let alert = Alert()
            alert.showAlert(from: self, title: "회원 탈퇴 실패", message: "회원 탈퇴를 위해 재로그인 해주세요.")
        }
    }
    
    private func startAppleReAuth() {
        self.snsAuthVM.appleLogin(delegate: self, provider: self)
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
}

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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTitle = datas[indexPath.section].titles[indexPath.row]
        
        let input = SettingViewModelImpl.Input(cellSelection: Observable.just(selectedTitle))
        let output = viewModel.transform(input: input)

        output.action
            .subscribe(onNext: { [weak self] action in
                switch action {
                case .navigateToProfile:
                    self?.navigateToProfile()
                case .navigateToBlackList:
                    self?.navigateToBlackList()
                case .logout:
                    self?.showLogoutAlert()
                case .removeAccount:
                    self?.showAccountDeletionAlert()
                default:
                    break
                }
            })
            .disposed(by: disposeBag)

        output.error
            .subscribe(onNext: { [weak self] errorMessage in
                let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
                alert.addAction(.init(title: "OK", style: .default))
                self?.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
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
                FirebaseManager.shared.userDelete { [weak self] error in
                    guard let self else { return }
                    if let error = error {
                        print("Error - deleting apple account \(error)")
                    }
                    print("account from apple deleted")
                    self.navigateToLogin()
                }
            })
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
}
