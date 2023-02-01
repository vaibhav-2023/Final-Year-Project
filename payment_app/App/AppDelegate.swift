//
//  AppDelegate.swift
//  payment_app
//
//  Created by MacBook PRO on 31/12/22.
//

import UIKit
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    
    var window: UIWindow?
    
    let gcmMessageIDKey = "gcm.message_id"
    
    override init() {
        //FirebaseApp.configure()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        //set up nav bar color
        UINavigationBar.appearance().tintColor = .primaryColor
        // UINavigationBar.appearance().isTranslucent = false
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = .whiteColor
        navBarAppearance.titleTextAttributes = [.font: UIFont.bitterMedium(size: 20), .foregroundColor: UIColor.blackColor]
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance

        //set up table view/list
        UITableView.appearance().separatorColor = UIColor.clear
        UITableView.appearance().tintColor = UIColor.clear
        
        UITextView.appearance().backgroundColor = .clear

        //device apn token
        application.registerForRemoteNotifications()

        //firebase
        //Messaging.messaging().delegate = self

        //notification set up
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { [weak self] (granted,error) in
                if !granted {
                    let alert = UIAlertController(title: "Notification Access", message: "In order to use this application, turn on notification permissions.", preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
                    alert.addAction(alertAction)

                    self?.window?.rootViewController?.present(alert , animated: true, completion: nil)
                }
            })

        //check for app update
        //Singleton.sharedInstance.generalFunctions.checkUpdateAvailable()
        
        return true
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        let config = UISceneConfiguration(name: "Scene Delegate", sessionRole: connectingSceneSession.role)
        config.delegateClass = SceneDelegate.self
        return config
    }
    
    //    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
    //        <#code#>
    //    }
}

//MARK: - UNUserNotificationCenterDelegate
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    //willPresent function gets callback when notification is received on app open
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if #available(iOS 14.0, *) {
            completionHandler([.banner, .badge, .sound])
        } else {
            completionHandler([.alert, .badge, .sound])
        }
    }
    
    //didReceive function gets callback when app is opened from notifcation
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}

//MARK: - remote notification functions
extension AppDelegate {
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        //print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        //print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        //print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID with fetchCompletionHandler: \(messageID)")
        }
        
        //print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
}

//MARK: - generate device token - APN
//extension AppDelegate {
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        let dToken = Singleton.sharedInstance.generalFunctions.convertApnTokenDataToString(deviceToken)
//        UserDefaults.standard.set(dToken, forKey: AppConstants.UserDefaultKeys.apnDeviceToken)
//        UserDefaults.standard.synchronize()
//        print("Device-token", dToken)
//        Messaging.messaging().apnsToken = deviceToken
//    }
//
//    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//        print("Unable to register for remote notifications: \(error.localizedDescription)")
//    }
//}

//MARK: - Firebase
//extension AppDelegate : MessagingDelegate {
//
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
//        print("Firebase registration token: \(fcmToken)")
//        UserDefaults.standard.removeObject(forKey: AppConstants.UserDefaultKeys.firebaseToken)
//        UserDefaults.standard.set(fcmToken, forKey: AppConstants.UserDefaultKeys.firebaseToken)
//    }
//}
