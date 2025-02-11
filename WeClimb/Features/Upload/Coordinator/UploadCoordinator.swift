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
            navigationController: navigationController, gymItem: gymItem)

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
    }

    private func presentLevelFilter(gymName: String) {
        let levelHoldFilterModalCoordinator = LevelHoldFilterCoordinator(
            navigationController: navigationController,
            builder: levelHoldFilterBuilder, gymName: gymName)
        addDependency(levelHoldFilterModalCoordinator)
        levelHoldFilterModalCoordinator.start()
        
        // ✅ LevelHoldFilterVC에서 클로저를 설정하여 값을 저장
        levelHoldFilterModalCoordinator.onLevelHoldFiltersApplied = { [weak self] levelFilters, holdFilters in
               guard let self = self else { return }

               print("Coordinator에서 받은 레벨: \(levelFilters), 홀드: \(holdFilters)")

               // ✅ 필터 값을 저장
               self.selectedLevelFilters = levelFilters
               self.selectedHoldFilters = holdFilters
           }

    }
    
    private func presentHoldFilter(gymName: String) {
        let levelHoldFilterModalCoordinator = LevelHoldFilterCoordinator(
            navigationController: navigationController,
            builder: levelHoldFilterBuilder, gymName: gymName)
        addDependency(levelHoldFilterModalCoordinator)
        levelHoldFilterModalCoordinator.startHoldIndex()
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
