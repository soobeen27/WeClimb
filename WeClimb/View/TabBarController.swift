//
//  TabBarController.swift
//  WeClimb
//
//  Created by Soo Jang on 8/26/24.
//

import UIKit
import FirebaseAuth

class TabBarController: UITabBarController {
    
    private let viewModel = MyPageVM()
    var myPage: UIViewController = UIViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sfMainFeedVC = UINavigationController(rootViewController: SFMainFeedVC())
        let searchVC = UINavigationController(rootViewController: SearchVC())
        let uploadVC = UINavigationController(rootViewController: UploadVC())
        
        // 선택된 아이템 색상 설정
        self.tabBar.tintColor = UIColor.label
        
        // 선택되지 않은 아이템 색상 설정
        self.tabBar.unselectedItemTintColor = .gray
        
        let feedBarNormalImage = UIImage(systemName: "house")
        let feedBarSelectedImage = UIImage(systemName: "house")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        
        sfMainFeedVC.tabBarItem = UITabBarItem(title: nil, image: feedBarNormalImage, selectedImage: feedBarSelectedImage)
        searchVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "magnifyingglass"), selectedImage: nil)
        uploadVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "plus.app"), selectedImage: nil)
        
        let myPageVC: UIViewController
        if Auth.auth().currentUser != nil {
            myPageVC = UINavigationController(rootViewController: MyPageVC())
            myPageVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person"), selectedImage: nil)
        } else {
            myPageVC = UINavigationController(rootViewController: GuestVC())
            myPageVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person"), selectedImage: nil)
        }
        self.setViewControllers([sfMainFeedVC, searchVC, uploadVC, myPageVC], animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self == self.tabBarController?.viewControllers?[0] {
            self.tabBarController?.tabBar.tintColor = .white
        } else {
            self.tabBarController?.tabBar.tintColor = UIColor.label
        }
    }
    
}
