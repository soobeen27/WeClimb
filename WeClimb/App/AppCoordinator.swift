//
//  AppCoordinator.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//

import UIKit

final class AppCoordinator: BaseCoordinator {
    public var navigationController: UINavigationController
    public let appDIcontainer: AppDIContainer
    
    init(navigationController: UINavigationController, appDIcontainer: AppDIContainer) {
        self.navigationController = navigationController
        self.appDIcontainer = appDIcontainer
    }
    
    override func start() {
        
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
}
