//
//  AppCoordinator.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//

import UIKit

final class AppCoordinator: BaseCoordinator {
    private let window: UIWindow
    private let navigationController: UINavigationController
    private let tabBarCoordinator: TabBarCoordinator
    
    init(window: UIWindow,
         navigationController: UINavigationController,
         tabBarCoordinator: TabBarCoordinator) {
        self.window = window
        self.navigationController = navigationController
        self.tabBarCoordinator = tabBarCoordinator
    }
    
    override func start() {
        showMainFlow()
    }
    
    private func showMainFlow() {
        addDependency(tabBarCoordinator)
        tabBarCoordinator.start()
        
        window.rootViewController = tabBarCoordinator.tabBarController
        window.makeKeyAndVisible()
    }
    
//    private func showLoginFlow() {
//        let loginCoordinator = LoginCoordinator(
//            navigationController: navigationController,
//            builder: loginBuilder
//        )
//        
//        addDependency(loginCoordinator)
//        loginCoordinator.start()
//        
//        window.rootViewController = navigationController
//        window.makeKeyAndVisible()
//    }
    
    
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
