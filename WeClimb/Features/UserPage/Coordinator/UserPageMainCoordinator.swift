//
//  UserPageMainCoordinator.swift
//  WeClimb
//
//  Created by 윤대성 on 12/20/24.
//

import UIKit

final class UserPageMainCoordinator: BaseCoordinator {
    var navigationController: UINavigationController
    private let builder: UserPageBuilder
    
    init(navigationController: UINavigationController, builder: UserPageBuilder) {
        self.navigationController = navigationController
        self.builder = builder
    }
    
    override func start() {
        showUserPageVC()
    }
    
    private func showUserPageVC() {
        let userPageCoordinator = UserPageCoordinator(navigationController: navigationController, builder: builder)
        
        addDependency(userPageCoordinator)
        
        userPageCoordinator.start()
        
        userPageCoordinator.onFinish = { [weak self] in
            self?.removeDependency(userPageCoordinator)
            // 다음으로 갈 곳
        }
    }
    
    
//    override func start() {
//        let userPageVC = UserPageVC()
//        userPageVC.coordinator = self
//        navigationController.pushViewController(userPageVC, animated: true)
//    }
}
