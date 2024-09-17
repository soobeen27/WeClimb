//
//  TabBarController.swift
//  WeClimb
//
//  Created by Soo Jang on 8/26/24.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sfMainFeedVC = UINavigationController(rootViewController: SFMainFeedVC())
        let searchVC = UINavigationController(rootViewController: SearchVC())
        let uploadVC = UINavigationController(rootViewController: UploadVC())
        let mypageVC = UINavigationController(rootViewController: MyPageVC())
        
        sfMainFeedVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house"), selectedImage: nil)
        searchVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "magnifyingglass"), selectedImage: nil)
        uploadVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "plus.app"), selectedImage: nil)
        mypageVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person"), selectedImage: nil)
        
        self.setViewControllers([sfMainFeedVC, searchVC, uploadVC, mypageVC], animated: true)
    }
}
