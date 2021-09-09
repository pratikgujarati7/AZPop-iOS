//
//  User_RecommendViewController.swift
//  AgendaZap
//
//  Created by Dipen on 21/01/20.
//  Copyright © 2020 AgendaZap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class User_RecommendViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate
{
    // MARK: - IBOutlet
    @IBOutlet var statusBarContainerView: UIView?
    @IBOutlet var homeBarContainerView: UIView?
    @IBOutlet var masterContainerView: UIView?
    
    //NAVIGATION BAR
    @IBOutlet var navigationBarView: UIView?
    @IBOutlet var navigationTitle: UILabel?
    //BACK
    @IBOutlet var backContainerView: UIView?
    @IBOutlet var imageViewBack: UIImageView?
    @IBOutlet var btnBack: UIButton?
    
    @IBOutlet var mainScrollView: UIScrollView?
    @IBOutlet var scrollContainerView: UIView?
    
    @IBOutlet var btnAppStoreContainerView: UIView?
    @IBOutlet var imageViewAppStore: UIImageView?
    @IBOutlet var lblAppStore: UILabel?
    @IBOutlet var imageViewAppStoreArrow: UIImageView?
    @IBOutlet var btnAppStore: UIButton?
    
    @IBOutlet var btnShareContainerView: UIView?
    @IBOutlet var imageViewShare: UIImageView?
    @IBOutlet var lblShare: UILabel?
    @IBOutlet var imageViewShareArrow: UIImageView?
    @IBOutlet var btnShare: UIButton?
    
    // MARK: - Other Variables
    
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    
    // MARK: - UIViewController Delegate Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupNotificationEvent()
        self.setUpNavigationBar()
        self.setupInitialView()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupNotificationEvent()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .lightContent
        } else {
            return .lightContent
        }
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
    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        
//        self.view.endEditing(true)
//        
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Setup Notification Methods
    
    func setupNotificationEvent()
    {
        if(boolIsSetupNotificationEventCalledOnce == false)
        {
            boolIsSetupNotificationEventCalledOnce = true
            
            NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.user_UpdateMyProfileDetailsEvent),
            name: Notification.Name("user_UpdateMyProfileDetailsEvent"),
            object: nil)
        }
    }
    
    func removeNotificationEventObserver()
    {
        boolIsSetupNotificationEventCalledOnce = false
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func user_UpdateMyProfileDetailsEvent()
    {
        DispatchQueue.main.async(execute: {
            
            
        })
    }
    
    // MARK: - Layout Subviews Methods
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            
            self.btnAppStoreContainerView?.layer.masksToBounds = false
            self.btnAppStoreContainerView?.layer.shadowColor = MySingleton.sharedManager().themeGlobalBlackColor?.cgColor
            self.btnAppStoreContainerView?.layer.shadowPath = UIBezierPath(roundedRect: self.btnAppStoreContainerView!.bounds, cornerRadius: (self.btnAppStoreContainerView?.layer.cornerRadius)!).cgPath
            self.btnAppStoreContainerView?.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
            self.btnAppStoreContainerView?.layer.shadowOpacity = 0.5
            self.btnAppStoreContainerView?.layer.shadowRadius = 1.0
            
            self.btnShareContainerView?.layer.masksToBounds = false
            self.btnShareContainerView?.layer.shadowColor = MySingleton.sharedManager().themeGlobalBlackColor?.cgColor
            self.btnShareContainerView?.layer.shadowPath = UIBezierPath(roundedRect: self.btnShareContainerView!.bounds, cornerRadius: (self.btnShareContainerView?.layer.cornerRadius)!).cgPath
            self.btnShareContainerView?.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
            self.btnShareContainerView?.layer.shadowOpacity = 0.5
            self.btnShareContainerView?.layer.shadowRadius = 1.0
        }
        
        
    }
    
    // MARK: - NavigationBar Methods
    
    func setUpNavigationBar()
    {
        statusBarContainerView?.backgroundColor = MySingleton.sharedManager().navigationBarBackgroundColor
        navigationBarView?.backgroundColor = MySingleton.sharedManager().navigationBarBackgroundColor
        
        navigationTitle?.font = MySingleton.sharedManager().navigationBarTitleFont
        navigationTitle?.textColor = MySingleton.sharedManager().navigationBarTitleColor
        navigationTitle?.text = NSLocalizedString("menu_recommend", value:"Recomende o AgendaZap", comment: "")
        
        btnBack?.addTarget(self, action: #selector(self.btnBackClicked(_:)), for: .touchUpInside)
    }
    
    @IBAction func btnBackClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: false)
    }
    
    // MARK: - Setting Initial Views Methods
    
    func setupInitialView()
    {
        mainScrollView?.backgroundColor = MySingleton.sharedManager().themeGlobalBackgroundGreyColor
        homeBarContainerView?.backgroundColor = MySingleton.sharedManager().themeGlobalBackgroundGreyColor
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        scrollContainerView?.backgroundColor = .clear
        
        btnAppStoreContainerView?.backgroundColor = MySingleton.sharedManager().themeGlobalWhiteColor
        btnAppStoreContainerView?.layer.cornerRadius = 5.0
        lblAppStore?.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        lblAppStore?.textColor = MySingleton.sharedManager().themeGlobalDarkGreyColor
        lblAppStore?.text = "\(NSLocalizedString("review_on_app_store", value:"Faça um Review no App Store", comment: ""))"
        btnAppStore?.addTarget(self, action: #selector(self.btnAppStoreClicked(_:)), for: .touchUpInside)
        
        btnShareContainerView?.backgroundColor = MySingleton.sharedManager().themeGlobalWhiteColor
        btnShareContainerView?.layer.cornerRadius = 5.0
        lblShare?.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        lblShare?.textColor = MySingleton.sharedManager().themeGlobalDarkGreyColor
        lblShare?.text = "\(NSLocalizedString("share_with_friends", value:"Indique o AgendaZap", comment: ""))"
        btnShare?.addTarget(self, action: #selector(self.btnShareClicked(_:)), for: .touchUpInside)
    }
    
    @IBAction func btnAppStoreClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        UserDefaults.standard.setValue("1", forKey: "is_user_rated_app")
        UserDefaults.standard.synchronize()
        
        //OPEN URL//App store rating & review"
        guard let url = URL(string: "https://apps.apple.com/app/agendazap/id1496435175") else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func btnShareClicked(_ sender: UIButton)
    {
        //self.view.endEditing(true)
        
        UserDefaults.standard.setValue("1", forKey: "is_user_shared_app")
        UserDefaults.standard.synchronize()
        
        let text = "AgendaZap - App para Achar o WhatsApp de Qualquer Negócio https://apps.apple.com/app/agendazap/id1496435175"
        let textShare = [text]
        let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }

}
