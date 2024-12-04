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

// SettingViewModelImpl 클래스 구현
final class SettingViewModelImpl: SettingViewModel {
    
    private let logoutUseCase: LogoutUseCase
    private let deleteUserUseCase: DeleteAccountUseCase
    private let reAuthUseCase: ReAuthUseCase
    private let webNavigationUseCase: WebPageOpenUseCase
    
    private let disposeBag = DisposeBag()
    private let errorRelay = PublishRelay<String>()
    
    private let datas: [SettingItem] = [
        SettingItem(section: .policy, titles: [SettingNameSpace.termsOfService, SettingNameSpace.privacyPolic, SettingNameSpace.inquiry]),
        SettingItem(section: .account, titles: [SettingNameSpace.editProfile, SettingNameSpace.blackList, SettingNameSpace.logout, SettingNameSpace.accountRemove]),
    ]
    
    // Output에서 사용할 Observable 정의
    private let _navigateToProfile = PublishSubject<Void>()
    private let _navigateToBlackList = PublishSubject<Void>()
    private let _navigateToLogin = PublishSubject<Void>()
    private let _showAlert = PublishSubject<String>()
    
    var navigateToProfile: Observable<Void> { return _navigateToProfile.asObservable() }
    var navigateToBlackList: Observable<Void> { return _navigateToBlackList.asObservable() }
    var navigateToLogin: Observable<Void> { return _navigateToLogin.asObservable() }
    var showAlert: Observable<String> { return _showAlert.asObservable() }
    
    var sectionData: Driver<[SettingItem]> {
        return Observable.just(datas).asDriver(onErrorJustReturn: [])
    }
    
    var error: Observable<String> {
        return errorRelay.asObservable()
    }
    
    init(
        logoutUseCase: LogoutUseCase,
        deleteUserUseCase: DeleteAccountUseCase,
        reAuthUseCase: ReAuthUseCase,
        webNavigationUseCase: WebPageOpenUseCase
    ) {
        self.logoutUseCase = logoutUseCase
        self.deleteUserUseCase = deleteUserUseCase
        self.reAuthUseCase = reAuthUseCase
        self.webNavigationUseCase = webNavigationUseCase
    }
    
    struct Input {
        let cellSelection: Observable<String>
    }
    
    struct Output {
        let action: Observable<SettingAction>
        let error: Observable<String>
    }
    
    func transform(input: Input) -> Output {
        let action = input.cellSelection
            .flatMap { [weak self] title -> Observable<SettingAction> in
                guard let self = self else { return .just(.logout) }
                
                print("변환된 title: \(title)")
                switch title {
                case SettingNameSpace.termsOfService:
                    print("이용 약관 눌린다.")
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
                    self.logoutUseCase.execute()
                    self._navigateToLogin.onNext(())
                    return .just(.logout)
                case SettingNameSpace.accountRemove:
                    self.deleteUserUseCase.execute()
                    return .just(.removeAccount)
                default:
                    return .just(.logout)
                }
            }
            .catch { [weak self] error in
                self?.handleError(error)
                return .just(.logout)
            }
        
        return Output(action: action, error: _showAlert.asObservable())
    }
    
    private func handleError(_ error: Error) {
        _showAlert.onNext("An error occurred: \(error.localizedDescription)")
    }
}
