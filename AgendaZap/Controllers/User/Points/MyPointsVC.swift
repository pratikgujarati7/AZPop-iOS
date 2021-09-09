//
//  MyPointsVC.swift
//  AgendaZap
//
//  Created by Innovative on 20/11/20.
//  Copyright © 2020 AgendaZap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import RealmSwift
import FirebaseDynamicLinks

class MyPointsVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblNavigationTitle: UILabel!
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var nslcBtnBackWidth: NSLayoutConstraint!
    
    @IBOutlet var btnCreate: UIButton!
    @IBOutlet var btnModeContainer: UIView!
    
    @IBOutlet var lblPointDescription: UILabel!
    @IBOutlet var btnPoints: UIButton!
    
    @IBOutlet var lblHowToEarnPoints: UILabel!
    @IBOutlet var linkDescription: UILabel!
    @IBOutlet var lblReferalLink: UILabel!
    @IBOutlet var btnCopy: UIButton!
    @IBOutlet var btnShare: UIButton!
    
    @IBOutlet var lblHowToUseYourPoints: UILabel!
    @IBOutlet var lblPoint1: UILabel!
    @IBOutlet var lblPoint2: UILabel!
    
    //MARK:- Variables
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    var boolIsOpenedFromDetailsScreen: Bool = false
    
    var points = 0
    var isApiCalled = false
    
    //MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupNotificationEvent()
        self.setUpNavigationBar()
        self.setupInitialView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupNotificationEvent()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        //API Call
        dataManager.user_getPoints()
        
        let strRefferalLink: String = "\(UserDefaults.standard.value(forKey: "refferalLink_new") ?? "")"
        
        if strRefferalLink == "" {
            self.generateDynamicLink()
        }
        else {
            self.lblReferalLink.text = strRefferalLink
        }
        
        let strIsAuthorized: String = "\(UserDefaults.standard.value(forKey: "isAuthorized") ?? "")"
        let strPassword: String = "\(UserDefaults.standard.value(forKey: "password") ?? "")"
        if(strIsAuthorized != "1")
        {
            if(strPassword != "" && strPassword.count > 0)
            {
                let viewController: User_LoginUsingPasswordViewController = User_LoginUsingPasswordViewController()
                viewController.boolIsLoadedFromSplashScreen = false
                self.navigationController?.pushViewController(viewController, animated: false)
            }
            else
            {
//                let viewController: User_RegisterEmailViewController = User_RegisterEmailViewController()
//                viewController.boolIsLoadedFromSplashScreen = false
//                viewController.boolIsNoWayBack = true
//                self.navigationController?.pushViewController(viewController, animated: false)
            }
        }
        
        if (boolIsOpenedFromDetailsScreen)
        {
            nslcBtnBackWidth.constant = 65
            btnBack.isHidden = false
        }
        else
        {
            nslcBtnBackWidth.constant = 0
            btnBack.isHidden = true
        }
        
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
        super.viewDidLayoutSubviews()
        
        self.btnPoints.layer.cornerRadius = 20
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.view.endEditing(true)
        
        self.removeNotificationEventObserver()
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
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.user_GetPointsDetailsEvent),
                name: Notification.Name("user_GetPointsDetailsEvent"),
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
    
    @objc func user_GetPointsDetailsEvent()
    {
        DispatchQueue.main.async(execute: {
            self.btnPoints.setTitle("Pontos Disponîveis : \(dataManager.strPoints)", for: .normal)
        })
    }
    
    //MARK:- IBActions
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
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
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else
        {
            UserDefaults.standard.setValue("1", forKey: "is_show_vendor_mode")
            UserDefaults.standard.synchronize()
//            AppDelegate().Delegate().setVendorTabBarVC()
        }
        
    }
    
    @IBAction func btnPointsTapped(_ sender: Any) {
        
    }
    
    @IBAction func btnCopyTapped(_ sender: Any) {
        UIPasteboard.general.string = self.lblReferalLink.text
        AppDelegate.showToast(message : NSLocalizedString("Copy_to_ClipBoard", value:"Link copiado", comment: ""), font:MySingleton.sharedManager().themeFontFourteenSizeBold!, view: self.view)
    }
    
    @IBAction func btnShareTapped(_ sender: Any) {
        
        guard self.lblReferalLink.text != "" else { return }
        
        let text = "Estou lhe dando 2 pontos (equivalente a R$2,00) para você trocar por descontos de até *100%* em produtos e serviços dentro do app *AZpop!*  É só baixar o aplicativo pelo link abaixo: \n\n\(self.lblReferalLink.text ?? "")"
        let textShare = [text]
        let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    //MARK:- NavigationBar Methods
    func setUpNavigationBar()
    {
        viewNavigation?.backgroundColor = MySingleton.sharedManager().navigationBarBackgroundColor
        
        lblNavigationTitle?.font = MySingleton.sharedManager().navigationBarTitleFont
        lblNavigationTitle?.textColor = MySingleton.sharedManager().navigationBarTitleColor
        //navigationTitle?.text = ""
    }
    
    //MARK: - Setting Initial Views Methods
    func setupInitialView() {
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        /*
         //API Call
         dataManager.user_getPoints()
         
         let strRefferalLink: String = "\(UserDefaults.standard.value(forKey: "refferalLink_new") ?? "")"
         
         if strRefferalLink == "" {
             self.generateDynamicLink()
         }
         else {
             self.lblReferalLink.text = strRefferalLink
         }
         */
    }
    
    //MARK:- Functions

    /*
     API : GetPointsDetails
     Params : user_id
     Response : rewardPoints,lifetimePoints
     just use reward points from this API
     QUERY: referral_code is missing
    */
    
    //To Generate Dynamic Referral Link
    func generateDynamicLink() {
        
        let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
        
        let strLink = "https://azpop.com.br/?invitedby=" + strLogedInUserID
        
        guard let link = URL(string: strLink) else { return }
        let dynamicLinksDomainURIPrefix = "https://app.azpop.com.br"
        let linkBuilder = DynamicLinkComponents(link: link, domainURIPrefix: dynamicLinksDomainURIPrefix)

        linkBuilder?.iOSParameters = DynamicLinkIOSParameters(bundleID: "com.agenda-zap")
        linkBuilder?.iOSParameters?.appStoreID = "1496435175"
        
        linkBuilder?.androidParameters = DynamicLinkAndroidParameters(packageName: "com.agendazap")
        
        /*
         guard let longDynamicLink = linkBuilder?.url else { return }
         print("The long URL is: \(longDynamicLink)")
         */
        
        linkBuilder?.shorten() { url, warnings, error in
            
            guard let refferalLink = url, error == nil else { return }
            print("The short URL is: \(refferalLink)")
            
            UserDefaults.standard.setValue(refferalLink.absoluteString, forKey: "refferalLink_new")
            UserDefaults.standard.synchronize()
            
            self.lblReferalLink.text = refferalLink.absoluteString
        }
    }
    
}
