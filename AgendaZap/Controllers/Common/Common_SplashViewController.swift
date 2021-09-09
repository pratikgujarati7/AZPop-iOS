//
//  Common_SplashViewController.swift
//  AgendaZap
//
//  Created by Dipen on 06/12/19.
//  Copyright © 2019 AgendaZap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import LGSideMenuController

class Common_SplashViewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate
{
    // MARK: - IBOutlet
    @IBOutlet var backgroundImageView: UIImageView?
    
    // MARK: - Other Variables
    
    var appDelegate: AppDelegate?
    var boolIsRedirected: Bool?
    
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    var boolIsExecuteRedirectionCalledOnce: Bool = false
    
    //MARK: - UIViewController Delegate Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNotificationEvent()
        self.setupInitialView()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupNotificationEvent()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.enable = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.view.endEditing(true)
        
        self.removeNotificationEventObserver()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Layout Subviews Methods
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    // MARK: - Setup Notification Methods
    
    func setupNotificationEvent()
    {
        if(boolIsSetupNotificationEventCalledOnce == false)
        {
            boolIsSetupNotificationEventCalledOnce = true
            
            NotificationCenter.default.addObserver(self,selector: #selector(self.user_GetSplashResponceEvent),name: Notification.Name("user_GetSplashResponceEvent"),object: nil)
        }
    }
    
    func removeNotificationEventObserver()
    {
        boolIsSetupNotificationEventCalledOnce = false
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func user_GetSplashResponceEvent()
    {
        DispatchQueue.main.async(execute: {
            self.executeRedirection()
        })
        
    }
    
    // MARK: - Setting Initial Views Methods
    
    func setupInitialView()
    {
        self.view.backgroundColor = MySingleton.sharedManager().themeGlobalSplashGreenColor
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        //API CALL
        dataManager.user_GetSplashResponce()
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
//            self.executeRedirection()
//        })
    }
    
    func executeRedirection()
    {
        dataManager.boolIsSplashScreenPassed = true
        
        let strUserID : String = UserDefaults.standard.value(forKey: "user_id") as? String ?? ""
        let strCityID : String = UserDefaults.standard.value(forKey: "city_id") as? String ?? ""
        let strIsAuthorized: String = "\(UserDefaults.standard.value(forKey: "isAuthorized") ?? "")"
        let strPassword: String = "\(UserDefaults.standard.value(forKey: "password") ?? "")"
        
        if (strUserID == "")
        {
            let viewController: User_RegisterViewController = User_RegisterViewController()
            self.navigationController?.pushViewController(viewController, animated: false)
        }
        else if(strIsAuthorized == "0" || strIsAuthorized == "")
        {
            if(strPassword != "" && strPassword.count > 0)
            {
                //PASSWORD IS CREATED
                let viewController: User_LoginUsingPasswordViewController = User_LoginUsingPasswordViewController()
                viewController.boolIsLoadedFromSplashScreen = true
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            else
            {
                //PASSWORD IS NOT CREATED
                if (strCityID == "")
                {
                    let viewController: User_SelectCityViewController = User_SelectCityViewController()
                    viewController.boolIsLoadedFromSplashScreen = true
                    self.navigationController?.pushViewController(viewController, animated: false)
                }
                else
                {
                    redirectToHome()
                }
            }
        }
        else
        {
            if (strCityID == "")
            {
                let viewController: User_SelectCityViewController = User_SelectCityViewController()
                viewController.boolIsLoadedFromSplashScreen = true
                self.navigationController?.pushViewController(viewController, animated: false)
            }
            else
            {
                redirectToHome()
            }
        }
    }
    
    // MARK: - Other Methods
    func redirectToHome()
    {
        if (dataManager.boolIsAppOpenedFromNotification == true)
        {
            dataManager.boolIsAppOpenedFromNotification = false
            let strCode: String = dataManager.strNotificationCode
            if strCode == "100"
            {
                //ORDER TAB
                dataManager.boolIsAppOpenedFromNotification = true
                AppDelegate().Delegate().openTabBarVCScreenClients()
            }
            else if strCode == "101"
            {
                //POINTS SCREEN
                let viewController: PointsToolVC = PointsToolVC()
                viewController.boolIsScreenOpenedFromNotification = true
                if let topController = UIApplication.topViewController() {
                    topController.navigationController?.pushViewController(viewController, animated: true)
                }
                
            }
            else if strCode == "102"
            {
                //BULK MESSAGE
                dataManager.boolIsAppOpenedFromNotification = true
                AppDelegate().Delegate().openTabBarVCScreenClients()
            }
            else if strCode == "103"
            {
                //PROMOTION TAB
                AppDelegate().Delegate().openTabBarVCScreenPromotions()
            }
            else if strCode == "104"
            {
                //PRODUCT DETAILS
                let viewController: ProductDetailsVC = ProductDetailsVC()
                viewController.boolIsScreenOpenedFromNotification = true
                viewController.strSelectedStoreProductID = dataManager.strNotificationID
                if let topController = UIApplication.topViewController() {
                    topController.navigationController?.pushViewController(viewController, animated: true)
                }
            }
            else
            {
                //GO TO HOME
                AppDelegate().Delegate().openTabBarVCScreenHome()
            }
        }
        else
        {
            AppDelegate().Delegate().setTabBarVC()
        }
    }
    
    // MARK: - UITextField Delegate Methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
