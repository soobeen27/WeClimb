////
////  SettingVM.swift
////  WeClimb
////
////  Created by 강유정 on 9/2/24.
////
//
//import FirebaseAuth
//import FirebaseCore
//import GoogleSignIn
//import RxSwift
//
//protocol SettingViewModelProtocol {
//    func tranform(input: SettingViewModel.Input) -> SettingViewModel.Output
//}
//
//class SettingViewModel: SettingViewModelProtocol {
//    
//    private let webPageUseCase: WebPageOpenUseCase
//    private let logoutUseCase: LogoutUseCase
//    private let deleteAccountUseCase: DeleteAccountUseCase
//    
//    private let disposeBag = DisposeBag()
//    
//    init(
//        webPageUseCase: WebPageOpenUseCase,
//        logoutUseCase: LogoutUseCase,
//        deleteAccountUseCase: DeleteAccountUseCase
//    ) {
//        self.webPageUseCase = webPageUseCase
//        self.logoutUseCase = logoutUseCase
//        self.deleteAccountUseCase = deleteAccountUseCase
//    }
//    
//    struct Input {
//        let selectedCell: Observable<CellType>
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
