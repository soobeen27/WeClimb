//
//  SceneDelegate.swift
//  WeClimb
//
//  Created by Soo Jang on 8/26/24.
//

import UIKit
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import FirebaseAuth
import FirebaseRemoteConfig

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        if Auth.auth().currentUser != nil {
            FirebaseManager.shared.currentUserInfo { result in
                switch result {
                case .success(let user):
                    if let userName = user.userName, !userName.isEmpty {
                        window.rootViewController = TabBarController()
                    } else {
                        window.rootViewController = UINavigationController(rootViewController: LoginVC())
                    }
                case .failure(let error):
                    print("유저 정보를 가져오는 데 실패했습니다: \(error)")
                    window.rootViewController = UINavigationController(rootViewController: LoginVC())
                }
                window.makeKeyAndVisible()
                self.window = window
                self.checkAppVersion()
            }
        } else {
            // 사용자가 로그인되어 있지 않으면 LoginVC로 이동
            window.rootViewController = UINavigationController(rootViewController: LoginVC())
            window.makeKeyAndVisible()
            self.window = window
            self.checkAppVersion()
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    func checkAppVersion() {
            let remoteConfig = RemoteConfig.remoteConfig()
            let settings = RemoteConfigSettings()
            settings.minimumFetchInterval = 43200
            remoteConfig.configSettings = settings
            // Fetch remote config values
            remoteConfig.fetchAndActivate { [weak self] status, error in
                guard let self else { return }
                if status == .successFetchedFromRemote || status == .successUsingPreFetchedData {
                    self.evaluateVersion(remoteConfig: remoteConfig)
                } else {
                    print("Error fetching remote config: \(String(describing: error))")
                }
            }
        }
    
    func evaluateVersion(remoteConfig: RemoteConfig) {
        let minimumVersion = remoteConfig["minimum_version"].stringValue
        let forceUpdate = remoteConfig["force_update"].boolValue
            
        if forceUpdate && self.isVersionOutdated(minimumVersion: minimumVersion) {
            self.promptForUpdate()
        }
    }
    
    func isVersionOutdated(minimumVersion: String) -> Bool {
        guard let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return false
        }
        return currentVersion.compare(minimumVersion, options: .numeric) == .orderedAscending
    }
    
    func promptForUpdate() {
        let alert = UIAlertController(title: "업데이트가 필요합니다.", message: "앱을 업데이트 해주세요", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "업데이트", style: .default, handler: { _ in
            if let url = URL(string: "https://apps.apple.com/kr/app/weclimb-%ED%95%A8%EA%BB%98-%EB%A7%8C%EB%93%9C%EB%8A%94-%ED%81%B4%EB%9D%BC%EC%9D%B4%EB%B0%8D-%EC%BB%A4%EB%AE%A4%EB%8B%88%ED%8B%B0/id6670149812") {
                UIApplication.shared.open(url)
            }
        }))

        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
}
