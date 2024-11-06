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
    private var isLoggedIn: Bool = Auth.auth().currentUser != nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }
    
    private func setView() {
//        let sfMainFeedVC = UINavigationController(rootViewController: SFMainFeedVC())
        let sfMainFeedVC = UINavigationController(rootViewController: SFMainFeedVC(viewModel: MainFeedVM(), startingIndex: 0, feedType: .mainFeed))
        let searchVC = UINavigationController(rootViewController: SearchVC())
        
        // 선택된 아이템 색상 설정
        self.tabBar.tintColor = UIColor.label
        
        // 선택되지 않은 아이템 색상 설정
        self.tabBar.unselectedItemTintColor = .gray
        
        let feedBarNormalImage = UIImage(systemName: "house")
        let feedBarSelectedImage = UIImage(systemName: "house")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        
        sfMainFeedVC.tabBarItem = UITabBarItem(title: nil, image: feedBarNormalImage, selectedImage: feedBarSelectedImage)
        searchVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "magnifyingglass"), selectedImage: nil)
        
        let myPageVC: UIViewController
        let uploadVC: UIViewController
        
        if isLoggedIn {
            myPageVC = UINavigationController(rootViewController: MyPageVC())
            myPageVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person"), selectedImage: nil)
            
            uploadVC = UINavigationController(rootViewController: UploadVC())
            uploadVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "plus.app"), selectedImage: nil)
        } else {
            myPageVC = UINavigationController(rootViewController: GuestVC())
            myPageVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person"), selectedImage: nil)
            
            uploadVC = UINavigationController(rootViewController: GuestVC())
            uploadVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "plus.app"), selectedImage: nil)
        }
        self.setViewControllers([sfMainFeedVC, searchVC, uploadVC, myPageVC], animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let currentIsLoggedIn = Auth.auth().currentUser != nil
        if currentIsLoggedIn != isLoggedIn {
            isLoggedIn = currentIsLoggedIn
            setView()
        }
        
        if self == self.tabBarController?.viewControllers?[0] {
            self.tabBarController?.tabBar.tintColor = .white
        } else {
            self.tabBarController?.tabBar.tintColor = UIColor.label
        }
    }
}
