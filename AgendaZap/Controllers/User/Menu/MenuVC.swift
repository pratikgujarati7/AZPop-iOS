//
//  MenuVC.swift
//  AgendaZap
//
//  Created by Innovative on 03/11/20.
//  Copyright © 2020 AgendaZap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import RealmSwift

class MenuVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblNavigationTitle: UILabel!
    
    @IBOutlet var btnCreate: UIButton!
    @IBOutlet var btnModeContainer: UIView!
    
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var lblPhoneNumber: UILabel!
    
    @IBOutlet var lblOption1: UILabel!
    @IBOutlet var lblOption2: UILabel!
    @IBOutlet var lblOption3: UILabel!
    @IBOutlet var lblOption4: UILabel!
    @IBOutlet var lblOption5: UILabel!
    
    //MARK:- Variables
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    
    //MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpNavigationBar()
        self.setupInitialViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupNotificationEvent()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        let realm = try! Realm()
        
        if (realm.objects(MyStore.self).count > 0)
        {
            btnCreate.isHidden = true
            btnModeContainer.isHidden = false
        }
        else
        {
            btnCreate.isHidden = false
            btnModeContainer.isHidden = true
        }
        
        //API CALL
        dataManager.user_GetAllMyStores()
        
        self.setupInitialViews()
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.enable = true
    }
    
    override func viewDidLayoutSubviews() {
        //self.searchViewContainer.layer.cornerRadius = 15.0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.removeNotificationEventObserver()
        
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Setup Notification Methods
    
    func setupNotificationEvent()
    {
        if(boolIsSetupNotificationEventCalledOnce == false)
        {
            boolIsSetupNotificationEventCalledOnce = true
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.user_GetAllMyStoresEvent),
                name: Notification.Name("user_GetAllMyStoresEvent"),
                object: nil)
        }
    }
    
    func removeNotificationEventObserver()
    {
        boolIsSetupNotificationEventCalledOnce = false
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func user_GetAllMyStoresEvent()
    {
        DispatchQueue.main.async(execute: {
            
            let realm = try! Realm()
            try! realm.write({
                realm.delete(realm.objects(MyStore.self))
                realm.add(dataManager.arrayAllMyStores)
            })
            
            if (dataManager.arrayAllMyStores.count > 0)
            {
                self.btnCreate.isHidden = true
                self.btnModeContainer.isHidden = false
            }
            else
            {
                self.btnCreate.isHidden = false
                self.btnModeContainer.isHidden = true
            }
        })
    }
    
    //MARK:- Layout Subviews Methods
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    //MARK:- IBActions
    @IBAction func btnCreateTapped(_ sender: Any) {

        let strIsAuthorized: String = "\(UserDefaults.standard.value(forKey: "isAuthorized") ?? "")"
        let strPassword: String = "\(UserDefaults.standard.value(forKey: "password") ?? "")"
        if(strIsAuthorized != "1")
        {
            //NOT AUTHORIZED
            if(strPassword != "" && strPassword.count > 0)
            {
                let viewController: User_LoginUsingPasswordViewController = User_LoginUsingPasswordViewController()
                viewController.boolIsLoadedFromSplashScreen = false
//                viewController.boolIsNoWayBack = false
                self.navigationController?.pushViewController(viewController, animated: false)
            }
            else
            {
//                let viewController: User_RegisterEmailViewController = User_RegisterEmailViewController()
//                viewController.boolIsLoadedFromSplashScreen = false
//                viewController.boolIsNoWayBack = false
//                self.navigationController?.pushViewController(viewController, animated: false)
            }
        }
        else
        {
            let viewController: User_AddStoreViewController = User_AddStoreViewController()
            viewController.objMyStore = MyStore()
            viewController.boolIsOpenForEdit = false
            self.navigationController?.pushViewController(viewController, animated: false)
        }
        
    }
    
    @IBAction func btnModeTapped(_ sender: Any) {

        let strIsAuthorized: String = "\(UserDefaults.standard.value(forKey: "isAuthorized") ?? "")"
        if(strIsAuthorized != "1")
        {
            let viewController: User_LoginUsingPasswordViewController = User_LoginUsingPasswordViewController()
            viewController.boolIsLoadedFromSplashScreen = true
//            viewController.boolIsLoadedForVendorMode = true
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else
        {
            UserDefaults.standard.setValue("1", forKey: "is_show_vendor_mode")
            UserDefaults.standard.synchronize()
//            AppDelegate().Delegate().setVendorTabBarVC()
        }
        
    }
    
    @IBAction func btnOption1Tapped(_ sender: Any) {
        //Trocar cidade
        let viewController: User_SelectCityViewController = User_SelectCityViewController()
        viewController.backContainerView?.isHidden = false
        viewController.isFromHomeScreen = true
        self.navigationController?.pushViewController(viewController, animated: false)
    }
    
    @IBAction func btnOption2Tapped(_ sender: Any) {
        
        let strIsAuthorized: String = "\(UserDefaults.standard.value(forKey: "isAuthorized") ?? "")"
        let strPassword: String = "\(UserDefaults.standard.value(forKey: "password") ?? "")"
        if(strIsAuthorized != "1")
        {
            //NOT AUTHORIZED
            if(strPassword != "" && strPassword.count > 0)
            {
                let viewController: User_LoginUsingPasswordViewController = User_LoginUsingPasswordViewController()
                viewController.boolIsLoadedFromSplashScreen = true
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            else
            {
//                let viewController: User_RegisterEmailViewController = User_RegisterEmailViewController()
//                viewController.boolIsLoadedFromSplashScreen = true
//                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
        else
        {
            //MY PROFILE
            let viewController: User_MyProfileViewController = User_MyProfileViewController()
            self.navigationController?.pushViewController(viewController, animated: false)
        }
        
    }
    
    @IBAction func btnOption3Tapped(_ sender: Any) {
        //NOTIFICATIONS
        let viewController: NotificationSettingsVC = NotificationSettingsVC()
        self.navigationController?.pushViewController(viewController, animated: false)
        
    }
    
    @IBAction func btnOption4Tapped(_ sender: Any) {
        //RECENT
        let viewController: User_RecentViewController = User_RecentViewController()
        self.navigationController?.pushViewController(viewController, animated: false)
    }
    
    @IBAction func btnOption5Tapped(_ sender: Any) {
        //Contact ADMINISTRATOR
        let viewController: User_ContactAdminViewController = User_ContactAdminViewController()
        self.navigationController?.pushViewController(viewController, animated: false)
    }
    
    
    //MARK:- Functions
    func setUpNavigationBar()
    {
        viewNavigation?.backgroundColor = MySingleton.sharedManager().navigationBarBackgroundColor
        
        lblNavigationTitle?.font = MySingleton.sharedManager().navigationBarTitleFont
        lblNavigationTitle?.textColor = MySingleton.sharedManager().navigationBarTitleColor
        lblNavigationTitle?.text = NSLocalizedString("my_profile", value: "Meu perfil", comment: "").uppercased()
    }
    
    func setupInitialViews() {
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        self.lblName.font = MySingleton.sharedManager().themeFontTwentySizeBold
        
        self.lblEmail.font = MySingleton.sharedManager().themeFontTwentySizeRegular
        self.lblPhoneNumber.font = MySingleton.sharedManager().themeFontTwentySizeRegular
        
        self.lblOption1.font = MySingleton.sharedManager().themeFontEighteenSizeRegular
        self.lblOption2.font = MySingleton.sharedManager().themeFontEighteenSizeRegular
        self.lblOption3.font = MySingleton.sharedManager().themeFontEighteenSizeRegular
        self.lblOption4.font = MySingleton.sharedManager().themeFontEighteenSizeRegular
        self.lblOption5.font = MySingleton.sharedManager().themeFontEighteenSizeRegular
        
        if let strFName = (UserDefaults.standard.value(forKey: "first_name") as? String), let strLName = (UserDefaults.standard.value(forKey: "first_name") as? String) , strFName != "<null>", strLName != "<null>" {
            self.lblName.text = "Usuário : \(UserDefaults.standard.value(forKey: "first_name") as? String ?? "") \(UserDefaults.standard.value(forKey: "last_name") as? String ?? "")"
        }
        
        if let strEmail = UserDefaults.standard.value(forKey: "email") as? String, strEmail != "<null>" {
            self.lblEmail.text = strEmail
        }
        else {
            self.lblEmail.text = ""
        }
        
        //self.lblEmail.text = "\(UserDefaults.standard.value(forKey: "email") as? String ?? "")"
        self.lblPhoneNumber.text = "\(UserDefaults.standard.value(forKey: "phone_number") as? String ?? "")"
        
    }
    
}
