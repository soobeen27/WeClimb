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
    
    var onFinish: (() -> Void)?
    
    init(navigationController: UINavigationController, builder: UserPageBuilder) {
        self.navigationController = navigationController
        self.builder = builder
    }
    
    override func start() {
        showUserProfileSettingPage()
    }
    
    private func showUserProfileSettingPage() {
        let profileSettingPage = builder.buildUserProfileSettingPage()
        profileSettingPage.coordinator = self
        
        navigationController.pushViewController(profileSettingPage, animated: true)
    }
}
