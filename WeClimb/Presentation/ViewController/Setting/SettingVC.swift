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

class SettingVC: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel: SettingViewModel
    private var datas: [SettingItem] = []
    
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
        bindViewModel()
        setLayout()
    }

    private func bindViewModel() {
        viewModel.sectionData
            .asDriver()
            .drive(onNext: { [weak self] data in
                self?.datas = data
            })
            .disposed(by: disposeBag)
        
        // 2. ViewModel의 transform 메서드 호출
        let output = viewModel.transform(input: SettingViewModelImpl.Input(cellSelection: Observable.empty()))  // 초기값
        
        // 3. Output에서 action 구독
        output.action
            .subscribe(onNext: { [weak self] action in
                switch action {
                case .navigateToProfile:
                    self?.navigateToProfile()
                case .navigateToBlackList:
                    self?.navigateToBlackList()
                case .logout:
                    self?.setAlert()
                    self?.navigateToLogin()
                case .removeAccount:
                    self?.removeAccount()
                default:
                    break
                }
                print("셀 클릭 처리 완료")
            })
            .disposed(by: disposeBag)

        // 4. 에러 처리
        output.error
            .subscribe(onNext: { [weak self] errorMessage in
                let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
                alert.addAction(.init(title: "OK", style: .default))
                self?.present(alert, animated: true)
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
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func navigateToProfile() {
        let editPageVC = EditPageVC()
        navigationController?.pushViewController(editPageVC, animated: true)
    }
    
    private func navigateToBlackList() {
        let blackListVC = BlackListVC()
        self.navigationController?.pushViewController(blackListVC, animated: true)
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
    
    private func setAlert() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let logoutAction = UIAlertAction(title: SettingNameSpace.logout, style: .default)
        let closeAction = UIAlertAction(title: "Close", style: .cancel)
        [logoutAction, closeAction].forEach { actionSheet.addAction($0) }
        present(actionSheet, animated: true)
    }
    
    private func removeAccount() {
        // 계정 삭제 처리
    }
}

extension SettingVC: UITableViewDelegate, UITableViewDataSource {
    
    // UITableViewDataSource
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

    // UITableViewDelegate
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
        // 선택된 셀의 title 가져오기
        let selectedTitle = datas[indexPath.section].titles[indexPath.row]
        
        print("선택된 셀: \(selectedTitle)")  // 선택된 셀 출력

        // ViewModel에 선택된 셀의 title을 전달하고, Output을 구독
        let input = SettingViewModelImpl.Input(cellSelection: Observable.just(selectedTitle))
        
        let output = viewModel.transform(input: input)  // transform 호출

        // Output에서 action 구독
        output.action
            .subscribe(onNext: { [weak self] action in
                switch action {
                case .navigateToProfile:
                    self?.navigateToProfile()
                case .navigateToBlackList:
                    self?.navigateToBlackList()
                case .logout:
                    self?.navigateToLogin()
                case .removeAccount:
                    self?.removeAccount()
                default:
                    break
                }
                print("셀 클릭 처리 완료")
            })
            .disposed(by: disposeBag)

        // 에러 처리 구독
        output.error
            .subscribe(onNext: { [weak self] errorMessage in
                let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
                alert.addAction(.init(title: "OK", style: .default))
                self?.present(alert, animated: true)
            })
            .disposed(by: disposeBag)

        // 셀 클릭 후 선택 상태 해제
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
