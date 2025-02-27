//
//  UserProfileSettingCoordinator.swift
//  WeClimb
//
//  Created by 윤대성 on 2/24/25.
//

import UIKit

final class UserProfileSettingCoordinator: BaseCoordinator {
    var navigationController: UINavigationController
    private let builder: UserPageBuilder
    
    var onFinish: ((UserProfileSettingEvent) -> Void)?
    
    init(navigationController: UINavigationController, builder: UserPageBuilder) {
        self.navigationController = navigationController
        self.builder = builder
    }
    
    override func start() {
        showUserProfileSettingPage()
    }
    
    private func showUserProfileSettingPage() {
        let profileSettingPage = builder.buildUserProfileSettingPage()
        profileSettingPage.hidesBottomBarWhenPushed = true
        profileSettingPage.coordinator = self
        
        navigationController.pushViewController(profileSettingPage, animated: true)
    }
    
    func showReturnPage() {
        navigationController.popViewController(animated: true)
    }
    
    func showHomeGymPage(_ event: UserProfileSettingEvent) {
        self.onFinish?(.homeGymPage)
    }
}
