//
//  AppDelegate.swift
//  AgendaZap
//
//  Created by Dipen on 06/12/19.
//  Copyright © 2019 AgendaZap. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import MBProgressHUD
import NYAlertViewController
import IQKeyboardManagerSwift
import SwiftKeychainWrapper
import RealmSwift
import FirebaseDynamicLinks
import FBSDKCoreKit

import AppCenter
import AppCenterAnalytics
import AppCenterCrashes

let objCommonUtility: CommonUtility = CommonUtility()


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?
    var navigationController : UINavigationController?
    
    let currentLanguage = "pt-BR"
    var myOrientation: UIInterfaceOrientationMask = .portrait
    
    let gcmMessageIDKey = "gcm.message_id"
    
    var appDel: AppDelegate?
    
//    override init() {
//    if let languages = UserDefaults.standard.object(forKey: "AppleLanguages") as? [String],
//        let language = languages.first(where:{!$0.hasPrefix("en")})
//    {
//        UserDefaults.standard.set(["pt-BR", "en"], forKey: "AppleLanguages")
//    }
//
//    super.init()
//    }
    
    class func sharedInstance() -> AppDelegate
    {
        return UIApplication.shared.delegate as! AppDelegate
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //FOR FB
        ApplicationDelegate.shared.application(
                    application,
                    didFinishLaunchingWithOptions: launchOptions
                )
        
        //UserDefaults.standard.set(["pt-BR"], forKey: "AppleLanguages")
        MSAppCenter.start("c7729598-d8d2-40f5-8a84-5e379e85b353", withServices:[
          MSAnalytics.self,
          MSCrashes.self
        ])
        
        let strPassword: String = "\(UserDefaults.standard.value(forKey: "password") ?? "")"
        
        if(strPassword == "")
        {
            UserDefaults.standard.setValue("", forKey: "password")
            UserDefaults.standard.synchronize()
        }
        
        let strIsAuthorized: String = "\(UserDefaults.standard.value(forKey: "isAuthorized") ?? "")"
        
        if(strIsAuthorized == "")
        {
            UserDefaults.standard.setValue("0", forKey: "isAuthorized")
            UserDefaults.standard.synchronize()
        }
      
        UserDefaults.standard.set(currentLanguage, forKey: "AppleLanguage")
        Bundle.swizzleLocalization()
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableDebugging = false
        
        let retrievedDeviceUUID: String? = KeychainWrapper.standard.string(forKey: "device_id")
        
        if(retrievedDeviceUUID != nil)
        {
            print("UUID: \(retrievedDeviceUUID)")
            UserDefaults.standard.set(retrievedDeviceUUID, forKey: "device_id")
            UserDefaults.standard.synchronize()
        }
        else
        {
            let uuid = UIDevice.current.identifierForVendor!.uuidString
            print("UUID: \(uuid)")
            UserDefaults.standard.set(uuid, forKey: "device_id")
            
            let saveSuccessful: Bool = KeychainWrapper.standard.set(uuid, forKey: "device_id")
            print("Save was successful: \(saveSuccessful)")
        }
        let modelName = UIDevice.current.model
        UserDefaults.standard.set(modelName, forKey: "device_name")
        UserDefaults.standard.synchronize()
        
        //========== REALM MIGRATION ==========//
        let config = Realm.Configuration(
            
            //schemaVersion: 0,//FOR ALL THE PREVIOUS VERSION BEFORE 1.1.3
            //schemaVersion: 1,//SET IN VERSION 1.1.3
            //schemaVersion: 2,//SET IN VERSION 3.0.3
            //schemaVersion: 3,//SET IN VERSION 3.0.3
            //schemaVersion: 4,//SET IN VERSION 3.0.4
            schemaVersion: 5,//SET IN VERSION 3.3.27
            
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                    
                    migration.enumerateObjects(ofType: MyStore.className()) { oldObject, newObject in
                        
                        // combine name fields into a single field
                        let strName = oldObject!["strName"] as! String
                        newObject!["strSlug"] = "\(strName)"
                    }
                }
                if (oldSchemaVersion == 1) {
                    
                    migration.enumerateObjects(ofType: MyStore.className()) { oldObject, newObject in
                        
                        // added new fiels in MyStore
                        newObject!["strInstagram_link"] = ""
                        newObject!["strFacebook_link"] = ""
                    }
                }
                if (oldSchemaVersion == 2) {
                    
                    migration.enumerateObjects(ofType: MyStore.className()) { oldObject, newObject in
                        
                        // added new fiels in MyStore
                        newObject!["strTaxIdStatus"] = ""
                    }
                }
                if (oldSchemaVersion == 3) {
                    
                    migration.enumerateObjects(ofType: MyStore.className()) { oldObject, newObject in
                        
                        // added new fiels in MyStore
                        newObject!["strIsStoreVisible"] = ""
                    }
                }
                if (oldSchemaVersion == 4) {
                    
                    migration.enumerateObjects(ofType: MyStore.className()) { oldObject, newObject in
                        
                        // added new fiels in MyStore
                        newObject!["strIsFreeDelivery"] = ""
                    }
                }
            })

        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config

        // Now that we've told Realm how to handle the schema change, opening the file
        // will automatically perform the migration
        let realm = try! Realm()
        //========== REALM MIGRATION ==========//
        
        //========== FCM PUSH NOTIFICATIONS REGISTRATION ==========//
        //registerForPushNotifications()
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        } else {
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        //========== FCM PUSH NOTIFICATIONS REGISTRATION ==========//
        
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.backgroundColor = UIColor.white
        
        let viewController: Common_SplashViewController = Common_SplashViewController()
        self.navigationController = UINavigationController(rootViewController: viewController)
        self.window!.rootViewController = navigationController
        self.window!.makeKeyAndVisible()
        
        //DISABLE DARK MODE
        if #available(iOS 13.0, *) {
            self.window!.overrideUserInterfaceStyle = .light
        }
        
        return true
    }

    // https://app.azpop.com.br/TG78
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
                
        self.window?.endEditing(true)
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "applicationDidEnterBackgroundEvent"), object: self)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "applicationWillEnterForegroundEvent"), object: self)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        //application.applicationIconBadgeNumber = 0
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return myOrientation
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //MARK:- For Deeplink
    
    //==================================================================================
    func application(_ application: UIApplication, continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
      let handled = DynamicLinks.dynamicLinks().handleUniversalLink(userActivity.webpageURL!) { (dynamiclink, error) in
        
        //https://app.azpop.com.br/myHi
        if let url = dynamiclink?.url?.absoluteString {
            let referrerUid = CommonUtility().getQueryStringParameter(url: url , param: "invitedby")
            
            /*
            let strCityID : String = UserDefaults.standard.value(forKey: "city_id") as? String ?? ""
            let strIsAuthorized: String = "\(UserDefaults.standard.value(forKey: "isAuthorized") ?? "")"
            
            if(strIsAuthorized == "1") && (strCityID != "") {
                
            }
            else {
                let strReferrerUid: String = "\(UserDefaults.standard.value(forKey: "referrerUid") ?? "")"
                
                if strReferrerUid == "" {
                    UserDefaults.standard.setValue(referrerUid, forKey: "referrerUid")
                    UserDefaults.standard.synchronize()
                }
            }
            */
            
            let strReferrerUid: String = "\(UserDefaults.standard.value(forKey: "referrerUid") ?? "")"
            
            if strReferrerUid == "" {
                UserDefaults.standard.setValue(referrerUid, forKey: "referrerUid")
                UserDefaults.standard.synchronize()
            }
            
        }
      }

      return handled
    }
    
    /*
     FIRDynamicLinks.dynamicLinks()?.handleUniversalLink(userActivity.webpageURL!) { (dynamiclink, error) in
         let link = dynamiclink.url
     }
    */
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
      return application(app, open: url,
                         sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                         annotation: "")
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
      if let dynamiclink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
        
        if let url = dynamiclink.url?.absoluteString {
            let referrerUid = CommonUtility().getQueryStringParameter(url: url , param: "invitedby")
            
            let strReferrerUid: String = "\(UserDefaults.standard.value(forKey: "referrerUid") ?? "")"
            
            if strReferrerUid == "" {
                UserDefaults.standard.setValue(referrerUid, forKey: "referrerUid")
                UserDefaults.standard.synchronize()
            }
        }
       
        return true
      }
      return false
    }
    
    //===================================================================================
    
    // MARK: - FCM Push Notifications Methods
    // [START register_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        UserDefaults.standard.setValue(fcmToken, forKey: "fcmToken")
        UserDefaults.standard.synchronize()
        
        Messaging.messaging().subscribe(toTopic: "Agendazap")//"AgendaZap")
//        Messaging.messaging().subscribe(toTopic: "AgendazapDevelopment")
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
      // If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    // [END register_token]
    
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        UserDefaults.standard.setValue(fcmToken, forKey: "fcmToken")
        UserDefaults.standard.synchronize()
        
        Messaging.messaging().subscribe(toTopic: "Agendazap")//"AgendaZap")
//        Messaging.messaging().subscribe(toTopic: "AgendazapDevelopment")
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
    // [END refresh_token]
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
        UserDefaults.standard.setValue("", forKey: "fcmToken")
        UserDefaults.standard.synchronize()
    }
    
    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
    }
    
    func application(application: UIApplication,  didReceiveRemoteNotification userInfo: [NSObject : AnyObject],  fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
                
    print("application:didReceiveRemoteNotification:fetchCompletionHandler: \(userInfo)")
       completionHandler(.newData)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    // [END receive_message]
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the FCM registration token.
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        print("APNs token retrieved: \(deviceToken)")
//
//        // With swizzling disabled you must set the APNs token here.
//        // Messaging.messaging().apnsToken = deviceToken
//    }
    
    // [START ios_10_message_handling]
    @available(iOS 10, *)
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
      withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
    // If you are receiving a notification message while your app is in the foreground,
    // this callback will not be fired as soon as the notification is received by the application
        
      let userInfo = notification.request.content.userInfo

      // With swizzling disabled you must let Messaging know about the message, for Analytics
//       Messaging.messaging().appDidReceiveMessage(userInfo)
      // Print message ID.
      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }

      // Print full message.
      print(userInfo)

      // Change this to your preferred presentation option
      completionHandler([[.alert, .sound]])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
                
        if let userInfo: Dictionary<String, Any> = response.notification.request.content.userInfo as? Dictionary<String, Any>
        {
            
            // Print full message.
            print(userInfo)
            
            let strCode: String = "\(userInfo["code"] ?? "")"
            
            let strUserID : String = UserDefaults.standard.value(forKey: "user_id") as? String ?? ""
            if (strUserID != "")
            {
                //User Loggedin, Check if App is in Active state
                if (dataManager.boolIsSplashScreenPassed)
                {
                    //App is active/background, Redirect from here
                    if strCode == "100"
                    {
                        //ORDER TAB
                        dataManager.boolIsAppOpenedFromNotification = true
                        self.openTabBarVCScreenClients()
                    }
                    else if strCode == "101"
                    {
                        //POINTS SCREEN
                        let viewController: PointsToolVC = PointsToolVC()
                        viewController.boolIsScreenOpenedFromNotification = true
                        DispatchQueue.main.async {

                            if let topController = UIApplication.topViewController() {
                                topController.navigationController?.pushViewController(viewController, animated: true)
                            }
                        }
                        
                    }
                    else if strCode == "102"
                    {
                        //BULK MESSAGE
                        dataManager.boolIsAppOpenedFromNotification = true
                        self.openTabBarVCScreenClients()
                    }
                    else if strCode == "103"
                    {
                        //PROMOTION TAB
                        self.openTabBarVCScreenPromotions()
                    }
                    else if strCode == "104"
                    {
                        //PRODUCT DETAILS
                        let viewController: ProductDetailsVC = ProductDetailsVC()
                        viewController.boolIsScreenOpenedFromNotification = true
                        viewController.strSelectedStoreProductID = "\(userInfo["product_id"] ?? "")"
                        DispatchQueue.main.async {

                            if let topController = UIApplication.topViewController() {
                                topController.navigationController?.pushViewController(viewController, animated: true)
                            }
                        }
                    }
                    else
                    {
                        //GO TO HOME
                        self.openTabBarVCScreenHome()
                    }
                }
                else
                {
                    //App is inactive, Let splash called first then redirect
                    dataManager.boolIsAppOpenedFromNotification = true
                    dataManager.strNotificationCode = strCode
                    dataManager.strNotificationID = "\(userInfo["product_id"] ?? "")"
                }
            }
            else
            {
                //User Not Loggedin, Let app Open Normaly
            }
        }
      

      completionHandler()
    }
    // [END ios_10_message_handling]
    
    // MARK: - Other Methods
    func Delegate() -> AppDelegate
    {
        if nil == appDel
        {
            appDel = (UIApplication.shared.delegate as! AppDelegate)
        }
        return appDel!
    }
    
    @objc func setTabBarVC()
    {
        let tabBarVC = TabBarVC()
        let navC = UINavigationController.init(rootViewController: tabBarVC)
        navC.isNavigationBarHidden = true
        
        AppDelegate().Delegate().window?.rootViewController = nil
        AppDelegate().Delegate().window?.rootViewController = navC
        AppDelegate().Delegate().window?.makeKeyAndVisible()
    }
    
    @objc func openTabBarVCScreenHome()
    {
        let tabBarVC = TabBarVC()
        let navC = UINavigationController.init(rootViewController: tabBarVC)
        navC.isNavigationBarHidden = true

        AppDelegate().Delegate().window?.rootViewController = nil
        AppDelegate().Delegate().window?.rootViewController = navC
        AppDelegate().Delegate().window?.makeKeyAndVisible()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            tabBarVC.tabBar(tabBarVC.tabController, didSelectTabAtIndex: 0)
        }
    }
    
    @objc func openTabBarVCScreenPromotions()
    {
        let tabBarVC = TabBarVC()
        let navC = UINavigationController.init(rootViewController: tabBarVC)
        navC.isNavigationBarHidden = true

        AppDelegate().Delegate().window?.rootViewController = nil
        AppDelegate().Delegate().window?.rootViewController = navC
        AppDelegate().Delegate().window?.makeKeyAndVisible()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            tabBarVC.tabBar(tabBarVC.tabController, didSelectTabAtIndex: 1)
        }
    }
    
    @objc func openTabBarVCScreenTools()
    {
        let tabBarVC = TabBarVC()
        let navC = UINavigationController.init(rootViewController: tabBarVC)
        navC.isNavigationBarHidden = true

        AppDelegate().Delegate().window?.rootViewController = nil
        AppDelegate().Delegate().window?.rootViewController = navC
        AppDelegate().Delegate().window?.makeKeyAndVisible()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            tabBarVC.tabBar(tabBarVC.tabController, didSelectTabAtIndex: 2)
        }
    }
    
    @objc func openTabBarVCScreenClients()
    {
        let tabBarVC = TabBarVC()
        let navC = UINavigationController.init(rootViewController: tabBarVC)
        navC.isNavigationBarHidden = true

        AppDelegate().Delegate().window?.rootViewController = nil
        AppDelegate().Delegate().window?.rootViewController = navC
        AppDelegate().Delegate().window?.makeKeyAndVisible()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            tabBarVC.tabBar(tabBarVC.tabController, didSelectTabAtIndex: 3)
        }
    }
    
    @objc func openTabBarVCScreenMyProfile()
    {
        let tabBarVC = TabBarVC()
        let navC = UINavigationController.init(rootViewController: tabBarVC)
        navC.isNavigationBarHidden = true

        AppDelegate().Delegate().window?.rootViewController = nil
        AppDelegate().Delegate().window?.rootViewController = navC
        AppDelegate().Delegate().window?.makeKeyAndVisible()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            tabBarVC.tabBar(tabBarVC.tabController, didSelectTabAtIndex: 4)
        }
    }
    
    func showAlertViewWithTitle(title: String, detail: String)
    {
        let alertViewController = NYAlertViewController()
        
        // Set a title and message
        alertViewController.title = title
        alertViewController.message = detail
        
        // Customize appearance as desired
        alertViewController.view.tintColor = UIColor.white
        alertViewController.backgroundTapDismissalGestureEnabled = true
        alertViewController.swipeDismissalGestureEnabled = true
        alertViewController.transitionStyle = NYAlertViewControllerTransitionStyle.fade
        
        alertViewController.titleFont = MySingleton.sharedManager().alertViewTitleFont
        alertViewController.messageFont = MySingleton.sharedManager().alertViewMessageFont
        alertViewController.buttonTitleFont = MySingleton.sharedManager().alertViewButtonTitleFont
        alertViewController.cancelButtonTitleFont = MySingleton.sharedManager().alertViewCancelButtonTitleFont
        alertViewController.buttonTitleColor = MySingleton.sharedManager().themeGlobalBlackColor
        alertViewController.cancelButtonTitleColor = MySingleton.sharedManager().themeGlobalBlackColor
        
        alertViewController.buttonColor = MySingleton.sharedManager().alertViewLeftButtonBackgroundColor
        
        // Add alert actions
        let okAction = NYAlertAction(
            title: "Ok",
            style: .default,
            handler: { (action: NYAlertAction!) -> Void in
                
                DispatchQueue.main.async {
                    
                    self.window?.rootViewController?.dismiss(animated: true, completion: nil)
                }
        })
        
        alertViewController.addAction(okAction)
                
        DispatchQueue.main.async {
            self.window?.rootViewController?.present(alertViewController, animated: true, completion: nil)
        }
    }
    
    func showAlertViewInGreenWithTitle(title: String, detail: String)
    {
        let alertViewController = NYAlertViewController()
        
//        let imageView: UIImageView = UIImageView(image: UIImage(named: "ic_check_green.png"))
//        imageView.contentMode = .scaleAspectFit
//        imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        alertViewController.alertViewContentView = imageView
        
        // Set a title and message
        alertViewController.title = title
        alertViewController.message = detail
        
        // Customize appearance as desired
        alertViewController.view.tintColor = UIColor.white
        alertViewController.backgroundTapDismissalGestureEnabled = true
        alertViewController.swipeDismissalGestureEnabled = true
        alertViewController.transitionStyle = NYAlertViewControllerTransitionStyle.fade
        
        alertViewController.titleFont = MySingleton.sharedManager().alertViewTitleFont
        alertViewController.messageFont = MySingleton.sharedManager().alertViewMessageFont
        alertViewController.buttonTitleFont = MySingleton.sharedManager().alertViewButtonTitleFont
        alertViewController.cancelButtonTitleFont = MySingleton.sharedManager().alertViewCancelButtonTitleFont
        alertViewController.buttonTitleColor = MySingleton.sharedManager().themeGlobalWhiteColor
        alertViewController.cancelButtonTitleColor = MySingleton.sharedManager().themeGlobalBlackColor
        
        alertViewController.buttonColor = MySingleton.sharedManager().themeGlobalGreen2Color
        
        // Add alert actions
        let okAction = NYAlertAction(
            title: "Ok",
            style: .default,
            handler: { (action: NYAlertAction!) -> Void in
                
                DispatchQueue.main.async {
                    
                    self.window?.rootViewController?.dismiss(animated: true, completion: nil)
                }
        })
        
        alertViewController.addAction(okAction)
                
        DispatchQueue.main.async {
            self.window?.rootViewController?.present(alertViewController, animated: true, completion: nil)
        }
    }
    
    func showGlobalProgressHUDWithTitle(title: String)
    {
        DispatchQueue.main.async {
            //let app = UIApplication.shared.delegate as? AppDelegate
            //let window = app?.window
            
            MBProgressHUD.hide(for: self.window!, animated: true)
            
            let hud = MBProgressHUD.showAdded(to: self.window!, animated: true)
            hud.mode = MBProgressHUDMode.indeterminate
            hud.label.text = title
            hud.label.numberOfLines = 0
            hud.dimBackground = true
        }
    }
    
    static func showToast(message : String, font: UIFont, view: UIView) {

        let toastLabel = UILabel(frame: CGRect(x: view.frame.size.width/2 - 75, y: view.frame.size.height-150, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 3.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func dismissGlobalHUD()
    {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.window!, animated: true)
        }
    }
}

extension Bundle {
    static func swizzleLocalization() {
        let orginalSelector = #selector(localizedString(forKey:value:table:))
        guard let orginalMethod = class_getInstanceMethod(self, orginalSelector) else { return }

        let mySelector = #selector(myLocaLizedString(forKey:value:table:))
        guard let myMethod = class_getInstanceMethod(self, mySelector) else { return }

        if class_addMethod(self, orginalSelector, method_getImplementation(myMethod), method_getTypeEncoding(myMethod)) {
            class_replaceMethod(self, mySelector, method_getImplementation(orginalMethod), method_getTypeEncoding(orginalMethod))
        } else {
            method_exchangeImplementations(orginalMethod, myMethod)
        }
    }

    @objc private func myLocaLizedString(forKey key: String,value: String?, table: String?) -> String {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let bundlePath = Bundle.main.path(forResource: appDelegate.currentLanguage, ofType: "lproj"),
            let bundle = Bundle(path: bundlePath) else {
                return Bundle.main.myLocaLizedString(forKey: key, value: value, table: table)
        }
        return bundle.myLocaLizedString(forKey: key, value: value, table: table)
    }
}

//// [START ios_10_message_handling]
//@available(iOS 10, *)
//extension AppDelegate : UNUserNotificationCenterDelegate {
//
//  // Receive displayed notifications for iOS 10 devices.
//  func userNotificationCenter(_ center: UNUserNotificationCenter,
//                              willPresent notification: UNNotification,
//    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//    let userInfo = notification.request.content.userInfo
//
//    // With swizzling disabled you must let Messaging know about the message, for Analytics
//    // Messaging.messaging().appDidReceiveMessage(userInfo)
//    // Print message ID.
//    if let messageID = userInfo[gcmMessageIDKey] {
//      print("Message ID: \(messageID)")
//    }
//
//    // Print full message.
//    print(userInfo)
//
//    // Change this to your preferred presentation option
//    completionHandler([[.alert, .sound]])
//  }
//
//  func userNotificationCenter(_ center: UNUserNotificationCenter,
//                              didReceive response: UNNotificationResponse,
//                              withCompletionHandler completionHandler: @escaping () -> Void) {
//    let userInfo = response.notification.request.content.userInfo
//    // Print message ID.
//    if let messageID = userInfo[gcmMessageIDKey] {
//      print("Message ID: \(messageID)")
//    }
//
//    // Print full message.
//    print(userInfo)
//
//    completionHandler()
//  }
//}
//// [END ios_10_message_handling]

