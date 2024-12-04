//
//  SettingVM.swift
//  WeClimb
//
//  Created by 강유정 on 9/2/24.
//

import Foundation
import RxSwift
import RxCocoa

// SettingViewModel 프로토콜 정의
protocol SettingViewModel {
    var sectionData: Driver<[SettingItem]> { get }
    var error: Observable<String> { get }
    func transform(input: SettingViewModelImpl.Input) -> SettingViewModelImpl.Output
    
    func triggerLogout()
    var _navigateToLogin: PublishSubject<Void> {get}
}

// SettingAction enum 정의
enum SettingAction {
    case openTermsOfService
    case openPrivacyPolicy
    case openInquiry
    case navigateToProfile
    case navigateToBlackList
    case logout
    case removeAccount
}
final class SettingViewModelImpl: SettingViewModel {

    private let logoutUseCase: LogoutUseCase
    private let deleteUserUseCase: DeleteAccountUseCase
    private let webNavigationUseCase: WebPageOpenUseCase
    private let loginRepository: LoginRepository

    private let disposeBag = DisposeBag()
    private let errorRelay = PublishRelay<String>()

    private let datas: [SettingItem] = [
        SettingItem(section: .policy, titles: [SettingNameSpace.termsOfService, SettingNameSpace.privacyPolic, SettingNameSpace.inquiry]),
        SettingItem(section: .account, titles: [SettingNameSpace.editProfile, SettingNameSpace.blackList, SettingNameSpace.logout, SettingNameSpace.accountRemove]),
    ]

    private let _navigateToProfile = PublishSubject<Void>()
    private let _navigateToBlackList = PublishSubject<Void>()
    internal let _navigateToLogin = PublishSubject<Void>()
    private let _showAlert = PublishSubject<String>()
    private let _requestReAuth = PublishSubject<Void>()  // 재인증 요청 신호

    var navigateToProfile: Observable<Void> { return _navigateToProfile.asObservable() }
    var navigateToBlackList: Observable<Void> { return _navigateToBlackList.asObservable() }
    var navigateToLogin: Observable<Void> { return _navigateToLogin.asObservable() }
    var showAlert: Observable<String> { return _showAlert.asObservable() }
    var requestReAuth: Observable<Void> { return _requestReAuth.asObservable() } // 뷰컨으로 재인증 요청 전달

    var sectionData: Driver<[SettingItem]> {
        return Observable.just(datas).asDriver(onErrorJustReturn: [])
    }

    var error: Observable<String> {
        return errorRelay.asObservable()
    }

    init(
        logoutUseCase: LogoutUseCase,
        deleteUserUseCase: DeleteAccountUseCase,
        webNavigationUseCase: WebPageOpenUseCase,
        loginRepository: LoginRepository
    ) {
        self.logoutUseCase = logoutUseCase
        self.deleteUserUseCase = deleteUserUseCase
        self.webNavigationUseCase = webNavigationUseCase
        self.loginRepository = loginRepository
    }

    struct Input {
        let cellSelection: Observable<String>
    }

    struct Output {
        let action: Observable<SettingAction>
        let error: Observable<String>
        let requestReAuth: Observable<Void> // 재인증 요청을 뷰컨으로 전달
    }

    func transform(input: Input) -> Output {
        let action = input.cellSelection
            .flatMap { [weak self] title -> Observable<SettingAction> in
                guard let self = self else { return .just(.logout) }

                switch title {
                case SettingNameSpace.termsOfService:
                    self.webNavigationUseCase.openWeb(urlString: "https://www.notion.so/iosclimber/104292bf48c947b2b3b7a8cacdf1d130")
                    return .just(.openTermsOfService)
                case SettingNameSpace.privacyPolic:
                    self.webNavigationUseCase.openWeb(urlString: "https://www.notion.so/iosclimber/146cdb8937944e18a0e055c892c52928")
                    return .just(.openPrivacyPolicy)
                case SettingNameSpace.inquiry:
                    self.webNavigationUseCase.openWeb(urlString: "https://forms.gle/UUaJmFeLAyuFXFFS9")
                    return .just(.openInquiry)
                case SettingNameSpace.editProfile:
                    self._navigateToProfile.onNext(())
                    return .just(.navigateToProfile)
                case SettingNameSpace.blackList:
                    self._navigateToBlackList.onNext(())
                    return .just(.navigateToBlackList)
                case SettingNameSpace.logout:
                    return .just(.logout)
                case SettingNameSpace.accountRemove:
                    return self.handleAccountRemoval() // 계정 삭제 처리
                default:
                    return .just(.logout)
                }
            }
            .catch { [weak self] error in
                self?.handleError(error)
                return .just(.logout)
            }

        return Output(action: action, error: _showAlert.asObservable(), requestReAuth: _requestReAuth.asObservable()) // 재인증 신호를 반환
    }

    internal func triggerLogout() {
        self.logoutUseCase.execute()
        _navigateToLogin.onNext(())
    }

    private func handleAccountRemoval() -> Observable<SettingAction> {
        let loginType = loginRepository.getLoginType()

        if loginType == .apple {
            // Apple 로그인 시 재인증을 요청하는 신호 보내기
            print("Apple 로그인 - 계정 삭제를 위해 재인증 요청") // 디버그 프린트
            _requestReAuth.onNext(()) // 재인증 요청
            return .just(.removeAccount) // 계정 삭제는 뷰컨에서 처리
        } else {
            print("Apple 외 로그인 - 바로 계정 삭제") // 디버그 프린트
            deleteAccount()
            return .just(.removeAccount)
        }
    }

    private func deleteAccount() {
        print("계정 삭제 시작") // 디버그 프린트
        deleteUserUseCase.execute()
        print("계정 삭제 완료") // 디버그 프린트
    }

    private func handleError(_ error: Error) {
        _showAlert.onNext("An error occurred: \(error.localizedDescription)")
    }
}
