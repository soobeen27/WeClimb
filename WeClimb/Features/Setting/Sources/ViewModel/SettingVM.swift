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
    func triggerAccountDeletion(presentProvider: @escaping PresenterProvider)
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
    private let deleteAccountUseCase: DeleteAccountUseCase
    private let webNavigationUseCase: WebPageOpenUseCase
    private let loginTypeUseCase: LoginTypeUseCase
    private let reAuthUseCase: ReAuthUseCase
    
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
    private let requestGoogleLoginSubject = PublishSubject<Void>()
    
    var navigateToProfile: Observable<Void> { return navigateToProfileSubject.asObservable() }
    var navigateToBlackList: Observable<Void> { return navigateToBlackListSubject.asObservable() }
    var navigateToLogin: Observable<Void> { return navigateToLoginSubject.asObservable() }
    var showAlert: Observable<String> { return showAlertSubject.asObservable() }
    var requestReAuth: Observable<Void> { return requestReAuthSubject.asObservable() }
    var accountDeletionResult: Observable<Bool> { return accountDeletionResultSubject.asObservable() }
    var requestGoogleLogin: Observable<Void> { return requestGoogleLoginSubject.asObservable() }
    
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
        loginTypeUseCase: LoginTypeUseCase,
        reAuthUseCase:ReAuthUseCase
    ) {
        self.logoutUseCase = logoutUseCase
        self.deleteAccountUseCase = deleteUserUseCase
        self.webNavigationUseCase = webNavigationUseCase
        self.loginTypeUseCase = loginTypeUseCase
        self.reAuthUseCase = reAuthUseCase
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
        let requestGoogleLogin: Observable<Void>
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
        
        return Output(cellData: Observable.just(datas), action: action, error: showAlertSubject.asObservable(), navigateToLogin: navigateToLogin, requestReAuth: requestReAuth, accountDeletionResult: accountDeletionResult, requestGoogleLogin: requestGoogleLogin)
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
    
    internal func triggerAccountDeletion(presentProvider: @escaping PresenterProvider) {
        print("로그인 타입 가져오는 중...")
        
        loginTypeUseCase.execute()
            .flatMap { [weak self] loginType -> Completable in
                guard let self = self else { return .error(FuncError.unknown) }

                switch loginType {
                case .google:
                    print("Google 로그인 타입 선택됨")
                    self.requestGoogleLoginSubject.onNext(())
                    return self.reAuthUseCase.execute(loginType: .google, presentProvider: presentProvider)
//                        .andThen(self.deleteAccountUseCase.execute())
                        .catch { error in
                            print("로그인 재인증 실패: \(error)")  // 에러 객체 자체 출력
                            return .error(FuncError.unknown)
                        }
                case .apple:
                    print("Apple 로그인 타입 선택됨")
                    return self.reAuthUseCase.execute(loginType: .apple, presentProvider: nil)
//                        .andThen(self.deleteAccountUseCase.execute())
                        .catch { error in
                            print("로그인 재인증 실패: \(error)")  // 에러 객체 자체 출력
                            return .error(FuncError.unknown)
                        }
                case .kakao:
                    print("Kakao 로그인 타입 선택됨")
                    return self.reAuthUseCase.execute(loginType: .kakao, presentProvider: nil)
//                        .andThen(self.deleteAccountUseCase.execute())
                        .catch { error in
                            print("로그인 재인증 실패: \(error)")  // 에러 객체 자체 출력
                            return .error(FuncError.unknown)
                        }
                case .none:
                    print("로그인 타입이 없음")
                    return .error(FuncError.unknown)
                }
            }
            .subscribe(
                onError: { [weak self] error in
                    self?.handleAccountDeletionResult(false)
                    print("Error 발생: \(error.localizedDescription)")
                },
                onCompleted: { [weak self] in
                    print("계정 삭제 완료")
                    self?.handleAccountDeletionResult(true)
                    self?.navigateToLoginSubject.onNext(())
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func handleAccountDeletionResult(_ success: Bool) {
//        accountDeletionResultSubject.onNext(success)
        
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
