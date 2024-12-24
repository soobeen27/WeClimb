//
//  AlarmManager.swift
//  WeClimb
//
//  Created by Soobeen Jang on 12/24/24.
//
import UIKit
import RxSwift

protocol AlarmManager {
    func moveToMyPage(postUID: String, commentUID: String?)
}

class AlarmManagerImpl: AlarmManager {
    private let disposeBag = DisposeBag()
    
    func moveToMyPage(postUID: String, commentUID: String?) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let tabBarController = windowScene.windows.first?.rootViewController as? UITabBarController else {
            print("탭바컨트롤러 못찾음")
            return
        }
        
        tabBarController.selectedIndex = 3
        
        let mainFeedVM = MainFeedVM()
        mainFeedVM.fetchMyPosts()
        
        mainFeedVM.posts.asDriver()
            .drive(onNext: { [weak self] posts in
                guard let self else { return }

                let postUIDs = posts.map { $0.postUID }
                
                guard let index = postUIDs.firstIndex(of: postUID) else {
                    print("인덱스 못찾음 \(postUID)")
                    return
                }
                
                let mainFeedVC = SFMainFeedVC(viewModel: mainFeedVM, startingIndex: index, feedType: .myPage)
                
                if let navigationController = tabBarController.selectedViewController as? UINavigationController {
                    navigationController.pushViewController(mainFeedVC, animated: true)
                    if let commentUID {
                        guard let post = posts.filter({ $0.postUID == postUID }).first else {
                            print("보여줘야하는 포스트 못찾음 왜지?")
                            return
                        }
                        showCommentModal(presenterVC: navigationController, for: post)
                    }
                } else {
                    print("네비컨트롤러 아님")
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func showCommentModal(presenterVC: UIViewController, for post: Post) {
        let modalVC = CommentModalVC(viewModel: CommentVM(post: post))
        presentModal(presenterVC: presenterVC, modalVC: modalVC)
    }
    
    private func presentModal(presenterVC: UIViewController, modalVC: UIViewController) {
        modalVC.modalPresentationStyle = .pageSheet
        modalVC.isModalInPresentation = false  // 모달 외부 클릭 시 모달 닫기
        
        if let sheet = modalVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]  // 미디움과 라지 크기 조절
            sheet.preferredCornerRadius = 20
            sheet.largestUndimmedDetentIdentifier = nil  //모든 크기에서 배경 흐림 처리(모달 터치와 관련)
            sheet.prefersGrabberVisible = true  // 상단 그랩바
        }
        presenterVC.present(modalVC, animated: true, completion: nil)
    }
}
