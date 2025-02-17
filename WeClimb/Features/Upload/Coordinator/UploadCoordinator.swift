//
//  UploadCoordinator.swift
//  WeClimb
//
//  Created by 윤대성 on 12/20/24.
//

import SnapKit
import UIKit

final class UploadCoordinator: BaseCoordinator {
    var navigationController: UINavigationController
    private let tabBarController: UITabBarController
    private let builder: UploadBuilder
    private let searchBuilder: SearchBuilder
    private let levelHoldFilterBuilder: LevelHoldFilterBuilder
    
    private var uploadMenuVC: UploadMenuVC?
    
    var isUploadViewPresented: Bool {
        return uploadMenuVC != nil
    }
    
    var onLevelHoldFiltersApplied: ((String, String) -> Void)?
    
    init(
        navigationController: UINavigationController,
        tabBarController: UITabBarController,
        builder: UploadBuilder,
        searchBuilder: SearchBuilder,
        levelHoldFilterBuilder: LevelHoldFilterBuilder
    ) {
        self.navigationController = navigationController
        self.tabBarController = tabBarController
        self.builder = builder
        self.searchBuilder = searchBuilder
        self.levelHoldFilterBuilder = levelHoldFilterBuilder
    }
    
    override func start() {
        showUploadMenu()
    }
    
    private func showUploadMenu() {
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
        
        UIView.animate(
            withDuration: 0.3,
            animations: {
                self.tabBarController.tabBar.alpha = 0
            }
        ) { _ in
            self.tabBarController.tabBar.isHidden = true
        }
    }
    
    private func navigateToSearchVC() {
        let searchCoordinator = SearchCoordinator(
            navigationController: navigationController, builder: searchBuilder)
        addDependency(searchCoordinator)
        searchCoordinator.navigateToUploadSearch()
        
        searchCoordinator.onUploadSearchFinish = { [weak self] query in
            self?.removeDependency(searchCoordinator)
            self?.navigateToSearchResultVC(query: query)
        }
    }
    
    func navigateToSearchResultVC(query: String) {
        let searchResultCoordinator = SearchResultCoordinator(
            navigationController: navigationController, builder: searchBuilder)
        addDependency(searchResultCoordinator)
        searchResultCoordinator.query = query
        searchResultCoordinator.navigateToUploadSearchResult()
        
        searchResultCoordinator.onFinish = { [weak self] result in
            self?.removeDependency(searchResultCoordinator)
            self?.navigateToUploadMedia(gymItem: result)
        }
    }
    
    private func navigateToUploadMedia(gymItem: SearchResultItem) {
        let uploadMediaCoordinator = UploadMediaCoordinator(
            navigationController: navigationController, gymItem: gymItem, builder: builder)
        
        parentCoordinator?.addDependency(uploadMediaCoordinator)
        parentCoordinator?.removeDependency(self)
        
        uploadMediaCoordinator.start()
        
        uploadMediaCoordinator.LevelFilterGymName = { [weak self] gymName in
            self?.presentLevelFilter(gymName: gymName)
            return gymName
        }
        
        uploadMediaCoordinator.holdFilterGymName = { [weak self] gymName in
            self?.presentHoldFilter(gymName: gymName)
            return gymName
        }
        
        self.onLevelHoldFiltersApplied = { levelFilters, holdFilters in
            uploadMediaCoordinator.onLevelHoldFiltersApplied?(levelFilters, holdFilters)
        }
        
        uploadMediaCoordinator.onFinish = { [weak self] mediaData in
            self?.navigateToUploadPostVC(gymName: gymItem.name, mediaItems: mediaData)
        }
        
        uploadMediaCoordinator.onDismiss = { [weak self] in
            guard let self = self else { return }
            
            self.navigationController.popToRootViewController(animated: true)
            
            self.tabBarController.selectedIndex = 0
            self.tabBarController.tabBar.isHidden = false
            UIView.animate(withDuration: 0.1, animations: {
                self.tabBarController.tabBar.alpha = 1
            })
        }
    }
    
    private func presentLevelFilter(gymName: String) {
        let levelHoldFilterModalCoordinator = LevelHoldFilterCoordinator(
            navigationController: navigationController,
            builder: levelHoldFilterBuilder,
            gymName: gymName)
        
        addDependency(levelHoldFilterModalCoordinator)
        levelHoldFilterModalCoordinator.start()
        
        levelHoldFilterModalCoordinator.onLevelHoldFiltersApplied = { [weak self] levelFilters, holdFilters in
            guard let self = self else { return }
            
            self.onLevelHoldFiltersApplied?(levelFilters, holdFilters)
        }
    }
    
    private func presentHoldFilter(gymName: String) {
        let levelHoldFilterModalCoordinator = LevelHoldFilterCoordinator(
            navigationController: navigationController,
            builder: levelHoldFilterBuilder,
            gymName: gymName)
        
        addDependency(levelHoldFilterModalCoordinator)
        levelHoldFilterModalCoordinator.startHoldIndex()
        
        levelHoldFilterModalCoordinator.onLevelHoldFiltersApplied = { [weak self] levelFilters, holdFilters in
            guard let self = self else { return }
            
            self.onLevelHoldFiltersApplied?(levelFilters, holdFilters)
        }
    }
    
    func navigateToUploadPostVC(gymName: String, mediaItems: [MediaUploadData]) {
        let uploadPostCoordinator = UploadPostCoordinator(
            navigationController: navigationController, gymName: gymName, mediaItems: mediaItems, builder: builder)
        addDependency(uploadPostCoordinator)
        uploadPostCoordinator.start()
        
        uploadPostCoordinator.onDismiss = { [weak self] in
            guard let self = self else { return }
            
            self.navigationController.popToRootViewController(animated: true)

            self.tabBarController.selectedIndex = 0
            self.tabBarController.tabBar.isHidden = false
            UIView.animate(withDuration: 0.1, animations: {
                self.tabBarController.tabBar.alpha = 1
            })
        }
    }
}

extension UploadCoordinator {
    func dismissUploadView() {
        guard let uploadViewController = uploadMenuVC else { return }
        
        UIView.animate(
            withDuration: 0.3,
            animations: {
                uploadViewController.view.alpha = 0
            }
        ) { _ in
            uploadViewController.view.removeFromSuperview()
            uploadViewController.removeFromParent()
            self.uploadMenuVC = nil
        }
    }
}
