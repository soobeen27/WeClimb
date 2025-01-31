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
    private var uploadMenuView: UploadMenuView?
    
    var isUploadViewPresented: Bool {
        return uploadMenuView != nil
    }
    
    private let builder: UploadBuilder

    init(navigationController: UINavigationController, tabBarController: UITabBarController, builder: UploadBuilder) {
        self.navigationController = navigationController
        self.tabBarController = tabBarController
        self.builder = builder
    }
    
    override func start() {
        let uploadView = UploadMenuView()
//        let uploadView = builder.buildUploadMenuView()
        uploadView.alpha = 0
        
        tabBarController.view.addSubview(uploadView)
        
        uploadView.snp.makeConstraints {
            $0.height.equalTo(190 - 54)
            $0.width.equalTo(250)
            $0.centerX.equalTo(tabBarController.view)
            $0.bottom.equalTo(tabBarController.tabBar.snp.top).offset(-16)
        }
        
        UIView.animate(withDuration: 0.3) {
            uploadView.alpha = 1
        }
        
        uploadMenuView = uploadView
    }
    
    func dismissUploadView() {
        guard let uploadView = uploadMenuView else { return }
        
        UIView.animate(withDuration: 0.3, animations: {
            uploadView.alpha = 0
        }) { _ in
            uploadView.removeFromSuperview()
            self.uploadMenuView = nil
        }
    }
    
}
