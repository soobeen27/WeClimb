//
//  SettingVM.swift
//  WeClimb
//
//  Created by 강유정 on 9/2/24.
//

//import FirebaseAuth
//import FirebaseCore
//import GoogleSignIn
//import RxSwift

//protocol SettingViewModelProtocol {
//    func tranform(input: UserListViewModel.Input) -> UserListViewModel.Output
//}
//
//class SettingViewModel: SettingViewModelProtocol {
//    
//    private let webPageUseCase: WebPageOpenUseCaseProtocol
//    private let logoutUseCase: LogoutUseCaseProtocol
//    private let deleteAccountUseCase: DeleteAccountUseCaseProtocol
//    
//    private let disposeBag = DisposeBag()
//    
//    init(
//        webPageUseCase: WebPageOpenUseCaseProtocol,
//        logoutUseCase: LogoutUseCaseProtocol,
//        deleteAccountUseCase: DeleteAccountUseCaseProtocol,
//    ) {
//        self.webPageUseCase = webPageUseCase
//        self.logoutUseCase = logoutUseCase
//        self.deleteAccountUseCase = deleteAccountUseCase
//    }
//    
//    struct Input {
//        let selectedCell: PublishRelay<CellType>
////        let currentUser: Observable<User>
//    }
//    
//    struct Output {
//        
//        let error: Observable<Error>
//    }
//    
//    public func tranform(input: Input) -> Output {
//        input.selectedCell.bind { [weak self] cell in
//            guard let self else { return }
//            switch self.CellType {
//            case SettingNameSpace.termsOfService:
//                return webPageUseCase.openWebPage(urlString: "https://www.notion.so/iosclimber/104292bf48c947b2b3b7a8cacdf1d130")
//            case SettingNameSpace.privacyPolic:
//                return webPageUseCase.openWebPage(urlString: "https://www.notion.so/iosclimber/146cdb8937944e18a0e055c892c52928")
//            case SettingNameSpace.inquiry:
//                return webPageUseCase.openWebPage(urlString: "https://forms.gle/UUaJmFeLAyuFXFFS9")
//            case SettingNameSpace.editProfile:
//                return Observable.just(.editProfile)
//            case SettingNameSpace.blackList:
//                return Observable.just(.blackList)
//            case SettingNameSpace.logout:
//                return logoutUser()
//            case SettingNameSpace.accountRemove:
//                return deleteUser(currentUser: currentUser)
//            default:
//                return Observable.just(.none)
//            }
//        }
//    }
//}
//
//public enum CellType: String {
//    case var termsOfService = "termsOfService"
//    case privacyPolic = "privacyPolic"
//    case inquiry = "inquiry"
//    case editProfile = "editProfile"
//    case blackList = "blackList"
//    case logout = "logout"
//    case deleteAccount = "deleteAccount"
//    
//    var title: String {
//        switch self {
//        case .termsOfService: return "이용 약관"
//        case .privacyPolic: return "개인 정보 처리 방침"
//        case .inquiry: return "문의하기"
//        case .editProfile: return "프로필 수정"
//        case .blackList: return "차단 목록"
//        case .logout: return "로그아웃"
//        case .deleteAccount: return "계정 삭제"
//        }
//    }
//}

import Foundation
import RxSwift
import RxCocoa

protocol SettingViewModel {
    func transform(input: SettingViewModelImpl.Input) -> SettingViewModelImpl.Output
}

public final class SettingViewModelImpl: SettingViewModel {
    private let logoutUseCase: LogoutUseCase
    private let deleteUserUseCase: DeleteAccountUseCase
    private let reAuthUseCase: ReAuthUseCaseProtocol
    private let webNavigationUseCase: WebPageOpenUseCase
    
    private let disposeBag = DisposeBag()
    private let error = PublishRelay<String>()
    
    public init(
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
    
    // MARK: - Input/Output 구조화
    
    public struct Input {
        let logout: Observable<Void>
        let deleteUser: Observable<Void>
        let reAuth: Observable<Void>
        let openWeb: Observable<String>
    }
    
    public struct Output {
        let logoutResult: Observable<Void>
        let deleteUserResult: Observable<Void>
        let reAuthResult: Observable<Bool>
        let webNavigationResult: Observable<Void>
        let error: Observable<String>
    }
    
    public func transform(input: Input) -> Output {
        let logoutResult = input.logout
            .flatMap { [weak self] _ -> Observable<Void> in
                guard let self = self else { return .just(()) }
                return self.logoutUseCase.execute()
                    .catch { error in
                        self.error.accept("로그아웃 실패: \(error.localizedDescription)")
                        return .just(())  // 빈 Observable을 반환
                    }
            }
        
        let deleteUserResult = input.deleteUser
            .flatMap { [weak self] _ -> Observable<Void> in
                guard let self = self else { return .just(()) }
                return self.reAuthUseCase.execute()
                    .flatMap { isAuthenticated -> Observable<Void> in
                        guard isAuthenticated else {
                            self.error.accept("재인증 실패")
                            return .just(())  // 빈 Observable을 반환
                        }
                        return self.deleteUserUseCase.execute()
                            .catch { error in
                                self.error.accept("회원 탈퇴 실패: \(error.localizedDescription)")
                                return .just(())  // 빈 Observable을 반환
                            }
                    }
                    .catch { error in
                        self.error.accept("회원 탈퇴 과정에서 오류 발생: \(error.localizedDescription)")
                        return .just(())  // 빈 Observable을 반환
                    }
            }
        
        let reAuthResult = input.reAuth
            .flatMap { [weak self] _ -> Observable<Bool> in
                guard let self = self else { return .just(false) }
                return self.reAuthUseCase.execute()
                    .catch { error in
                        self.error.accept("재인증 실패: \(error.localizedDescription)")
                        return .just(false)
                    }
            }
        
        let webNavigationResult = input.openWeb
            .flatMap { [weak self] urlString -> Observable<Void> in
                guard let self = self else { return .just(()) }
                
                return self.webNavigationUseCase.openWeb(urlString: urlString)
                    .catch { error in
                        // 웹 페이지 열기 실패시 오류 메시지를 처리하고 빈 Observable을 반환
                        self.error.accept("웹 페이지 열기 실패: \(error.localizedDescription)")
                        return Observable.empty()  // 빈 Observable을 반환
                    }
            }
        
        return Output(
            logoutResult: logoutResult,
            deleteUserResult: deleteUserResult,
            reAuthResult: reAuthResult,
            webNavigationResult: webNavigationResult,
            error: error.asObservable()
        )
    }
}
