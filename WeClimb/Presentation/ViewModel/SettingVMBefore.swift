//
//  beforeSettingVM.swift
//  WeClimb
//
//  Created by 강유정 on 11/29/24.
//

//import FirebaseAuth
//import FirebaseCore
//import GoogleSignIn
//import RxSwift
//
//class SettingVM {
//    // MARK: - 파이어베이스 로그아웃 YJ
//    func LogoutUser() -> Observable<Void> {
//        return Observable.create { observer in
//            do {
//                try Auth.auth().signOut()
//                observer.onNext(())
//                observer.onCompleted()
//            } catch {
//                observer.onError(error)
//            }
//            return Disposables.create()
//        }
//    }
//    
//    // MARK: - 파이어베이스 회원탈퇴 YJ
//    //근데 이거 왜 필요함?
////    func deleteUser() -> Observable<Void> {
////        return Observable.create { observer in
////            FirebaseManager.shared.userDelete()
////            observer.onNext(())
////            observer.onCompleted()
////            return Disposables.create()
////        }
////    }
//    
//    func checkLoginType() -> LoginType {
//        guard let user = Auth.auth().currentUser else { return .none }
//        
//        let snsType = user.providerData.first.map { $0.providerID } ?? "unknown"
//        
//        print(snsType)
//        
//        switch snsType {
//        case "google.com":
//            return .google
//        case "apple.com":
//            return .apple
//        case "oidc.kakao":
//            return .kakao
//        default:
//            return .none
//        }
//    }
//}
