//
//  AppCoordinator.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//

import UIKit

final class AppCoordinator: BaseCoordinator {
    public var navigationController: UINavigationController
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
    }
    
    override func start() {
        // TabBarCoordinator 생성 및 실행
        let tabBarController = UITabBarController()
        let tabBarCoordinator = TabBarCoordinator(tabBarController: tabBarController)
        
        addDependency(tabBarCoordinator)
        tabBarCoordinator.start()
        
        // UIWindow의 rootViewController로 설정
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        
    }
    
    override func childDidFinish(_ coordinator: Coordinator) {
        removeDependency(coordinator) // 자식 Coordinator 제거
    }
}

//    func start() {
//        if Auth.auth().currentUser != nil {
//            FirebaseManager.shared.currentUserInfo { result in
//                switch result {
//                case .success(let user):
//                    if let userName = user.userName, !userName.isEmpty {
//                        let tabBarController = UITabBarController()
//                        let tabBarCoordinator = TabBarCoordinator(tabBarController: tabBarController)
//
//                        tabBarCoordinator.start()
//                        self.childCoordinators.append(tabBarCoordinator)
//
//                        self.window.rootViewController = tabBarController
//                    } else {
//                        self.showLogin()
//                    }
//                case .failure:
//                    self.showLogin()
//                }
//                self.window.makeKeyAndVisible()
//            }
//        } else {
//            showLogin()
//            self.window.makeKeyAndVisible()
//        }
//    }
//
//    private func showLogin() {
//        let navigationController = UINavigationController(rootViewController: LoginVC())
//        window.rootViewController = navigationController
//    }
