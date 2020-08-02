//
//  AppDelegate.swift
//  FanPassport
//
//  Created by Vadim on 09.12.2019.
//  Copyright © 2019 yorich. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GlobalConstants.apiService.startListeningNetworkChanges()
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        Auth.auth().languageCode = "ru"
        GMSServices.provideAPIKey("AIzaSyCIDGfxNaSEkadRtEibl5hiY3ciBkPi25M")
        
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        
           //Solicit permission from the user to receive notifications
           UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (_, error) in
               guard error == nil else{
                   print(error!.localizedDescription)
                   return
               }
           }
        //get application instance ID
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
            }
        }
        
        application.registerForRemoteNotifications()
        
        if UserDefaults.standard.string(forKey: UserKeys.firebaseUID) != nil {
            let newVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as! MainTabBarController
            newVC.isLoginAction = true
            window!.rootViewController = newVC
        }
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Pass device token to auth.
        let firebaseAuth = Auth.auth()
        Messaging.messaging().apnsToken = deviceToken
        #if DEBUG
            firebaseAuth.setAPNSToken(deviceToken, type: AuthAPNSTokenType.sandbox)
        #else
            firebaseAuth.setAPNSToken(deviceToken, type: AuthAPNSTokenType.prod)
        #endif
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let firebaseAuth = Auth.auth()

        if (firebaseAuth.canHandleNotification(userInfo)){
            print(userInfo)
            return
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        UserDefaults.standard.set(fcmToken, forKey: UserKeys.fcmToken)
        UserDefaults.standard.synchronize()

        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
     
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
//        if let nID = userInfo["id"] as? Int, GlobalConstants.apiService.isInternetAvailable(vc: UIViewController()) {
//            GlobalConstants.apiService.getViewed(messageID: nID) { result, data, error in
//                if result {
//                    print("Notification has been viewed")
//                } else if let error = error {
//                    print(error)
//                }
//            }
//        }

        print(userInfo["link"] as? String ?? "000")
        
        
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        print(userInfo)
//        if let nID = userInfo["id"] as? Int, GlobalConstants.apiService.isInternetAvailable(vc: UIViewController()) {
//            GlobalConstants.apiService.getDelivered(messageID: nID) { result, data, error in
//                if result {
//                    print("Notification has been delivered")
//                } else if let error = error {
//                    print(error)
//                }
//            }
//        }

        completionHandler([.alert, .sound])
    }

}


