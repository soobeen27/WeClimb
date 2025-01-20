//
//  OnboardingCoordinator.swift
//  WeClimb
//
//  Created by 윤대성 on 1/13/25.
//

import UIKit

final class OnboardingCoordinator: BaseCoordinator {
    private let navigationController: UINavigationController
    private let builder: OnboardingBuilder
    private let tabBarController: UITabBarController
    private let tabBarBuilder: TabBarBuilder
    
    init(navigationController: UINavigationController, builder: OnboardingBuilder, tabBarController: UITabBarController, tabBarBuilder: TabBarBuilder) {
        self.navigationController = navigationController
        self.builder = builder
        self.tabBarController = tabBarController
        self.tabBarBuilder = tabBarBuilder
    }
    
    override func start() {
        showLogin()
    }
    
    private func showLogin() {
        let loginCoordinator = LoginCoordinator(navigationController: navigationController, builder: builder)
        
        addDependency(loginCoordinator)
        
        loginCoordinator.start()
        
        loginCoordinator.onFinish = { [weak self] in
            self?.removeDependency(loginCoordinator)
            self?.showPrivacyPolicy()
        }
    }
    
    private func showPrivacyPolicy() {
        let privacyPolicyCoordinator = PrivacyPolicyCoordinator(navigationController: navigationController, builder: builder)
        
        addDependency(privacyPolicyCoordinator)
        
        privacyPolicyCoordinator.start()
        
        privacyPolicyCoordinator.onFinish = { [weak self] in
            self?.removeDependency(privacyPolicyCoordinator)
            self?.showCreateNickname()
        }
    }
    
    private func showCreateNickname() {
        let createNicknameCoordinator = CreateNickNameCoordinator(navigationController: navigationController, builder: builder)
        
        addDependency(createNicknameCoordinator)
        
        createNicknameCoordinator.start()
        
        createNicknameCoordinator.onFinish = { [weak self] in
            self?.removeDependency(createNicknameCoordinator)
            self?.showCreatePersonalDetail()
        }
    }
    
    private func showCreatePersonalDetail() {
        let createPersonalDetailCoordinator = CreatePersonalDetailCoordinator(navigationController: navigationController, builder: builder)
        
        createPersonalDetailCoordinator.start()
        
        addDependency(createPersonalDetailCoordinator)
        createPersonalDetailCoordinator.onFinish = { [weak self] in
            self?.removeDependency(createPersonalDetailCoordinator)
            self?.showRegisterResult()
        }
    }
    
    private func showRegisterResult() {
        let registerResultCoordinator = RegisterResultCoordinator(navigationController: navigationController)
        
        registerResultCoordinator.start()
        
        addDependency(registerResultCoordinator)
        registerResultCoordinator.onFinish = { [weak self] in
            self?.removeDependency(registerResultCoordinator)
            self?.moveToTabBar()
        }
    }
    
    private func moveToTabBar() {
        let tabBarCoordinator = TabBarCoordinator(tabBarController: tabBarController, navigationController: navigationController, builder: tabBarBuilder)
        
        parentCoordinator?.addDependency(tabBarCoordinator)
        parentCoordinator?.removeDependency(self)
        
        tabBarCoordinator.start()
    }
}
