//
//  AppDelegate.swift
//  WeClimb
//
//  Created by Soo Jang on 8/26/24.
//

import AVFoundation
import UIKit

import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseMessaging
import GoogleSignIn
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // 파이어베이스 설정
        FirebaseApp.configure()
        // Override point for customization after application launch.
        // 파이어스토어 디비
        let db = Firestore.firestore()
        
        if let nativeAppKey =
            Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] as? String {
            // 카카오 설정
            KakaoSDK.initSDK(appKey: nativeAppKey)
        }
        
        Thread.sleep(forTimeInterval: 0.7)
        
        // AVAudioSession (무음시에도 소리 출력)
        do {
                   try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                   try AVAudioSession.sharedInstance().setActive(true)
               } catch {
                   print("Failed to set audio session category: \(error)")
               }
        
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        let authOption: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOption) { granted, error in
            if granted {
                print("알림 권한 승인됨")
            } else {
                print("알림 권한 거부됨")
            }
            if let error {
                print(error)
            }
        }
        application.registerForRemoteNotifications()
        
        return true
    }
    
    // Google 로그인 페이지 열기
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        // 카카오 로그인
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            return AuthController.handleOpenUrl(url: url)
        }
        // 구글 로그인
        return GIDSignIn.sharedInstance.handle(url)
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      // TODO: Handle data of notification

      // With swizzling disabled you must let Messaging know about the message, for Analytics
      // Messaging.messaging().appDidReceiveMessage(userInfo)

      // Print message ID.
      print(userInfo)
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        print("APNs 토큰 등록됨: \(deviceToken.map { String(format: "%02.2hhx", $0) }.joined())")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("APNs 등록 실패: \(error.localizedDescription)")
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {

    // 앱이 포그라운드일 때 알림 수신 처리
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        let userInfo = notification.request.content.userInfo
        print("포그라운드 알림 수신: \(userInfo)")

        completionHandler([.badge, .sound, .banner])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {

        let userInfo = response.notification.request.content.userInfo
        print("사용자 응답 수신: \(userInfo)")

        completionHandler()
    }
}

extension AppDelegate: MessagingDelegate {
  // [START refresh_token]
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    print("Firebase registration token: \(String(describing: fcmToken))")

    let dataDict: [String: String] = ["token": fcmToken ?? ""]
    NotificationCenter.default.post(
      name: Notification.Name("FCMToken"),
      object: nil,
      userInfo: dataDict
    )
    // TODO: If necessary send token to application server.
    // Note: This callback is fired at each app startup and whenever a new token is generated.
      guard let fcmToken else { return }
      
      guard let uid = Auth.auth().currentUser?.uid else { return }
      Firestore.firestore().collection("users").document(uid).setData(["fcmToken": fcmToken], merge: true)
  }
  // [END refresh_token]
}
