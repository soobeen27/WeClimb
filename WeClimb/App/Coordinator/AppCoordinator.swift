//
//  AppCoordinator.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//

import UIKit

import RxSwift
import FirebaseAuth

final class AppCoordinator: BaseCoordinator {
    private let window: UIWindow
    private let navigationController: UINavigationController
    private let appDIContainer: AppDIContainer
    private let disposeBag = DisposeBag()
    
    init(window: UIWindow, navigationController: UINavigationController, appDIContainer: AppDIContainer) {
        self.window = window
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }
    
    override func start() {
        let userReadDataSource = appDIContainer.resolve(UserReadDataSource.self)
//        showOnboardingFlow()
//        window.makeKeyAndVisible()
        if Auth.auth().currentUser != nil {
            userReadDataSource.myInfo()
                .observe(on: MainScheduler.instance)
                .subscribe(onSuccess: { [weak self] user in
                    guard let self else { return }
                    if let userName = user?.userName, !userName.isEmpty {
                        self.showMainTabBar()
                    } else {
                        self.showOnboardingFlow()
                    }
                    self.window.makeKeyAndVisible()
                }, onFailure: { [weak self] _ in
                    guard let self else { return }
                    self.showOnboardingFlow()
                    self.window.makeKeyAndVisible()
                })
                .disposed(by: disposeBag)
        } else {
            showOnboardingFlow()
            window.makeKeyAndVisible()
        }
    }
    
    override func childDidFinish(_ coordinator: Coordinator) {
        removeDependency(coordinator) // 자식 Coordinator 제거
    }
    
    private func showMainTabBar() {
        let tabBarBuilder = appDIContainer.resolve(TabBarBuilder.self)
        
        let tabBarController = UITabBarController()
        
        let tabBarCoordinator = TabBarCoordinator(
            tabBarController: tabBarController,
            navigationController: navigationController,
            builder: tabBarBuilder)
        
        tabBarCoordinator.start()
        addDependency(tabBarCoordinator)
        
//        window.rootViewController = tabBarController
        window.rootViewController = navigationController
    }
    
    private func showOnboardingFlow() {
        let tabBarController = UITabBarController()
        
        let onboardingCoordinator = OnboardingCoordinator(
            navigationController: navigationController,
            builder: appDIContainer.resolve(OnboardingBuilder.self),
            tabBarController: tabBarController,
            tabBarBuilder: appDIContainer.resolve(TabBarBuilder.self)
        )
        
        addDependency(onboardingCoordinator)
        onboardingCoordinator.start()
        
        window.rootViewController = navigationController
    }
//    private func showLogin() {
//        let loginBuilder = appDIContainer.resolve(OnboardingBuilder.self)
//        
//        let loginVC = loginBuilder.buildLogin()
//        let navigationController = UINavigationController(rootViewController: loginVC)
//        
//        let loginCoordinator = LoginCoordinator(navigationController: navigationController, builder: loginBuilder)
//        
//        loginCoordinator.start()
//        addDependency(loginCoordinator)
//        
//        window.rootViewController = navigationController
//    }
}
