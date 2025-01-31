//
//  UploadCoordinator.swift
//  WeClimb
//
//  Created by 윤대성 on 12/20/24.
//

import UIKit

import SnapKit

final class UploadCoordinator: BaseCoordinator {
    
    var navigationController: UINavigationController
    private let tabBarController: UITabBarController
    private let builder: UploadBuilder
    private let searchBuilder: SearchBuilder
    
    private var uploadMenuVC: UploadMenuVC?
    
    var isUploadViewPresented: Bool {
        return uploadMenuVC != nil
    }
    
    init(navigationController: UINavigationController, tabBarController: UITabBarController, builder: UploadBuilder, searchBuilder: SearchBuilder) {
        self.navigationController = navigationController
        self.tabBarController = tabBarController
        self.builder = builder
        self.searchBuilder = searchBuilder
    }
    
    override func start() {
        let uploadMenuVC = UploadMenuVC()
        
        uploadMenuVC.onClimbingButtonTapped = { [weak self] in
            self?.navigateToTabIndex()
        }
        
        tabBarController.addChild(uploadMenuVC)
        tabBarController.view.addSubview(uploadMenuVC.view)
        
        uploadMenuVC.view.snp.makeConstraints {
            $0.height.equalTo(190 - 54)
            $0.width.equalTo(250)
            $0.centerX.equalTo(tabBarController.view)
            $0.bottom.equalTo(tabBarController.tabBar.snp.top).offset(-16)
        }
        
        self.uploadMenuVC = uploadMenuVC
    }
    
    func navigateToTabIndex() {
        tabBarController.selectedIndex = 2
        navigateToSearchVC()
        dismissUploadView()
        
        UIView.animate(withDuration: 0.3, animations: {
            self.tabBarController.tabBar.alpha = 0
        }) { _ in
            self.tabBarController.tabBar.isHidden = true
        }
    }
    
    func navigateToSearchVC() {
        let searchCoordinator = SearchCoordinator(navigationController: navigationController, builder: searchBuilder)
        searchCoordinator.navigateToUploadSearch()
    }
}

extension UploadCoordinator {
    func dismissUploadView() {
        guard let uploadViewController = uploadMenuVC else { return }
        
        UIView.animate(withDuration: 0.3, animations: {
            uploadViewController.view.alpha = 0
        }) { _ in
            uploadViewController.view.removeFromSuperview()
            uploadViewController.removeFromParent()
            self.uploadMenuVC = nil
        }
    }
}
