//
//  SettingVM.swift
//  WeClimb
//
//  Created by 강유정 on 9/2/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol SettingViewModel {
    func transform(input: SettingViewModelImpl.Input) -> SettingViewModelImpl.Output
    
    var sectionData: Driver<[SettingItem]> { get }
    
    var error: Observable<String> { get }
    
    func triggerLogout()
    
    func triggerAccountDeletion()
}

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
    private let loginTypeUseCase: LoginTypeUseCase
    
    private let disposeBag = DisposeBag()
    private let errorRelay = PublishRelay<String>()
    
    private let datas: [SettingItem] = [
        SettingItem(section: .policy, titles: [SettingNameSpace.termsOfService, SettingNameSpace.privacyPolic, SettingNameSpace.inquiry]),
        SettingItem(section: .account, titles: [SettingNameSpace.editProfile, SettingNameSpace.blackList, SettingNameSpace.logout, SettingNameSpace.accountRemove]),
    ]
    
    private let navigateToProfileSubject = PublishSubject<Void>()
    private let navigateToBlackListSubject = PublishSubject<Void>()
    private let navigateToLoginSubject = PublishSubject<Void>()
    private let showAlertSubject = PublishSubject<String>()
    private let requestReAuthSubject = PublishSubject<Void>()
    private let accountDeletionResultSubject = PublishSubject<Bool>()
    
    var navigateToProfile: Observable<Void> { return navigateToProfileSubject.asObservable() }
    var navigateToBlackList: Observable<Void> { return navigateToBlackListSubject.asObservable() }
    var navigateToLogin: Observable<Void> { return navigateToLoginSubject.asObservable() }
    var showAlert: Observable<String> { return showAlertSubject.asObservable() }
    var requestReAuth: Observable<Void> { return requestReAuthSubject.asObservable() }
    var accountDeletionResult: Observable<Bool> { return accountDeletionResultSubject.asObservable() }
    
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
        loginTypeUseCase: LoginTypeUseCase
    ) {
        self.logoutUseCase = logoutUseCase
        self.deleteUserUseCase = deleteUserUseCase
        self.webNavigationUseCase = webNavigationUseCase
        self.loginTypeUseCase = loginTypeUseCase
    }
    
    struct Input {
        let cellSelection: Observable<IndexPath>
    }
    
    struct Output {
        let cellData: Observable<[SettingItem]>
        
        let action: Observable<SettingAction>
        let error: Observable<String>
        
        let navigateToLogin: Observable<Void>
        
        let requestReAuth: Observable<Void>
        let accountDeletionResult: Observable<Bool>
    }
    
    func transform(input: Input) -> Output {
        let action = input.cellSelection
            .flatMap { [weak self] indexPath -> Observable<SettingAction> in
                guard let self = self else { return .just(.logout) }
                
                let title = self.datas[indexPath.section].titles[indexPath.row]
                
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
                    self.navigateToProfileSubject.onNext(())
                    return .just(.navigateToProfile)
                case SettingNameSpace.blackList:
                    self.navigateToBlackListSubject.onNext(())
                    return .just(.navigateToBlackList)
                case SettingNameSpace.logout:
                    return .just(.logout)
                case SettingNameSpace.accountRemove:
                    return .just(.removeAccount)
                default:
                    return .just(.logout)
                }
            }
            .catch { [weak self] error in
                self?.handleError(error)
                return .just(.logout)
            }
        
        return Output(cellData: Observable.just(datas), action: action, error: showAlertSubject.asObservable(), navigateToLogin: navigateToLogin, requestReAuth: requestReAuth, accountDeletionResult: accountDeletionResult)
    }
    
    internal func triggerLogout() {
        self.logoutUseCase.execute()
            .subscribe(onNext: { [weak self] in
                self?.navigateToLoginSubject.onNext(())
            }, onError: { error in
                print("로그아웃 실패: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    
    internal func triggerAccountDeletion() {
        loginTypeUseCase.execute()
            .subscribe(onNext: { [weak self] loginType in
                guard let self = self else { return }
                
                if loginType == .apple {
                    self.requestReAuthSubject.onNext(())
                } else {
                    self.deleteUserUseCase.execute { success in
                        self.handleAccountDeletionResult(success)
                    }
                }
            }, onError: { error in
                print("Error: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    
    private func handleAccountDeletionResult(_ success: Bool) {
        accountDeletionResultSubject.onNext(success)
        
        if success {
            self.accountDeletionResultSubject.onNext(true)
        } else {
            self.accountDeletionResultSubject.onNext(false)
        }
    }
    
    private func handleError(_ error: Error) {
        showAlertSubject.onNext("An error occurred: \(error.localizedDescription)")
    }
}
